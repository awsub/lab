all <- c()
for (i in seq(0, 15)) {
  fname <- sprintf("results/16/%d.stdout.log", i)
  lines <- readLines(fname)
  start  <- strptime(strsplit(lines[1],             " ")[[1]][3], format = "%H:%M:%S")
  finish <- strptime(strsplit(lines[length(lines)], " ")[[1]][3], format = "%H:%M:%S")
  all <- c(all, as.character(as.numeric(finish - start, units = "secs")))
}
writeLines(all, "results/dataset")