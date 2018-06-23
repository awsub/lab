EC2.pricing <- read.csv("./EC2_pricing.csv")
S3.DL.price <- 0.0008 # $/GB
EBS.price <- 0

Reference.size <- 30 # GB

time.DL.Reference <- function() {
  switch(
    as.character(Reference.size),
    "30"=600
  )
}

EC2.price.for <- function(instance.type) {
  return(EC2.pricing[EC2.pricing$instance_type == instance.type, 2][1] / (60*60))
}

records <- read.csv("../STAR-measurement/results/all.tsv", sep="\t")

results <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(results) <- c("instance_type", "concurrency", "avg", "min", "max")

price.ExTL <- function(itype, concurrency, time) {
  dl <- (S3.DL.price * Reference.size)
  shared.instance <- dl + (EC2.price.for(itype) + EBS.price) * (time.DL.Reference() + time)
  computing.instances <- EC2.price.for("m4.2xlarge") * time * concurrency
  return(shared.instance + computing.instances)
}

push <- function(record) {
  itype <- record[1]
  conc <- as.numeric(record[2])
  avgtime <- as.numeric(record[3])
  mintime <- as.numeric(record[4])
  maxtime <- as.numeric(record[5])
  avgp <- price.ExTL(itype, conc, avgtime)
  minp <- price.ExTL(itype, conc, mintime)
  maxp <- price.ExTL(itype, conc, maxtime)
  results <<- rbind(results, data.frame(instance_type=itype, concurrency=conc, avg=avgp, min=minp, max=maxp, row.names = NULL))
}

apply(head(records[records$instance_type == "m4.2xlarge",], 5), MARGIN=1, FUN=push)
apply(head(records[records$instance_type == "m4.4xlarge",], 6), MARGIN=1, FUN=push)
apply(head(records[records$instance_type == "m4.10xlarge",], 7), MARGIN=1, FUN=push)
apply(head(records[records$instance_type == "m4.16xlarge",], 8), MARGIN=1, FUN=push)

ETL.control <- unlist(read.csv("./control-ETL/results/dataset"))
ETL.avg <- mean(ETL.control)
ETL.min <- min(ETL.control)
ETL.max <- max(ETL.control)

price.ETL <- function(concurrency, time) {
  dl <- (S3.DL.price * Reference.size)
  instance <- EC2.price.for("m4.large") * (time + time.DL.Reference()) * concurrency
  return((dl + instance) * concurrency)
}
sapply(seq(0,3), function(i) {
  c <- 2^i
  results <<- rbind(results, data.frame(instance_type = "ETL (control)", concurrency = c, avg = price.ETL(c, ETL.avg), min = price.ETL(c, ETL.min), max = price.ETL(c, ETL.max), row.names = NULL))
})

if (!require("ggplot2")) {
  install.packages("ggplot2", dependencies = TRUE, quiet = TRUE)
}

errors <- aes(ymin = min, ymax = max)

g <- ggplot(results, aes(x=concurrency, y=avg, colour=instance_type)) +
  geom_line(size = 0.5) +
  geom_point(size = 1) +
  scale_colour_brewer(palette="Set1") +
  scale_x_log10(breaks=c(1,2,4,8,16,32,64)) +
  scale_y_continuous(breaks=seq(0, 50,by=5)) +
  theme_bw() +
  theme(legend.position = "bottom") +
  labs(x = "Number of instances", y = "Price ($)", colour = "Shared Data Instance Type")

ggsave("figure.png", width = 24, height = 15, units = "cm", dpi = 600)