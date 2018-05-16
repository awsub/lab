"
This R script compiles the time logs spent in 'STAR' command
for each combination of shared data instance type and conccurency,
and append the summary data to 'all.tsv'.
The summary is expected to be like
[ instance type | concurrency | average | min | max | standard deviation ]

Usage example:

  R --vanilla --args m4.2xlarge 128 < compile.R

"

instancetype <- commandArgs(trailingOnly=TRUE)[1]
concurrency <- as.double(commandArgs(trailingOnly=TRUE)[2])

workingdir <- paste(setwd("."), "results", sep = "/")
casename <- sprintf("%s-x%02d", instancetype, concurrency)
datasetfile <- paste(workingdir, casename, "dataset", sep = "/")
destination <- paste(workingdir, "all.tsv", sep = "/")

dataset <- read.csv(datasetfile, header = FALSE)
records <- apply(dataset, 1, function(x) {
  start <- strptime(x[1], "%B %d %H:%M:%S")
  finish <- strptime(x[2], "%B %d %H:%M:%S")
  return(as.numeric(finish - start, units = "secs"))
})

summary <- t(as.data.frame(c(instancetype, concurrency, mean(records), min(records), max(records), sd(records))))
write.table(summary, destination, append = TRUE, row.names = FALSE, quote = FALSE, col.names = FALSE, sep = "\t")