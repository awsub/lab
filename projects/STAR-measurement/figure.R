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

g <- ggplot(dataset, aes(x=concurrency, y=average, colour=instance_type)) +
     geom_line(size = 0.5) +
     geom_point(size = 1) +
     scale_colour_brewer(palette="Set1") +
     scale_x_log10(breaks=c(1,2,4,8,16,32,64)) +
     scale_y_continuous(breaks=seq(0,18000,by=1000)) +
     geom_errorbar(errors, width = 0.2) +
     theme_bw() +
     theme(legend.position = "bottom") +
     labs(x = "Number of instances", y = "Time (secs)")

ggsave("figure.png", width = 24, height = 15, units = "cm", dpi = 600)