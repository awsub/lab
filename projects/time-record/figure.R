"
This R script creates a figure from summarized 'all.tsv' data.
"

if (!require("ggplot2")) {
  install.packages("ggplot2", dependencies = TRUE, quiet = TRUE)
}

workingdir <- paste(setwd("."), "results", sep = "/")
tsvfile <- paste(workingdir, "all.tsv", sep = "/")
dataset <- read.table(tsvfile, header = TRUE, sep = "\t")

errors <- aes(ymin = average - std, ymax = average + std)

g <- ggplot(dataset, aes(x=concurrency, y=average, colour=instance_type)) + geom_line(size=1) + geom_point(shape=22, size=3)
g <- g + scale_colour_brewer(palette="Set2") + scale_x_log10(breaks=c(1,2,4,8,16,32,64,128)) + scale_y_continuous(breaks=seq(0,10000,by=1000))
g <- g + xlab("#instances") + ylab("Time (sec)") + geom_errorbar(errors, width = 0.2) 

ggsave(paste(workingdir, "figure.png", sep = "/"))