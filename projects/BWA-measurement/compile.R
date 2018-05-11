"
This R script compiles the time logs spent in 'bwa mem' command
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
casename <- sprintf("%s-x%03d", instancetype, concurrency)
datasetfile <- paste(workingdir, casename, "dataset", sep = "/")
destination <- paste(workingdir, "all.tsv", sep = "/")

dataset <- unlist(read.csv(datasetfile, header = FALSE))
summary <- t(as.data.frame(c(instancetype, concurrency, mean(dataset), min(dataset), max(dataset), sd(dataset))))
write.table(summary, destination, append = TRUE, row.names = FALSE, quote = FALSE, col.names = FALSE, sep = "\t")
