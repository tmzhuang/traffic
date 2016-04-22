#!/usr/bin/env Rscript
require('plotrix')
files = list.files(pattern="*.csv")
sums = numeric(100000)
for(i in seq_along(files)) {
  #Get data from csv
  print(paste("Reading from: ", files[i]))
  csv = read.csv(files[i])
  data = csv[,1]
  for(j in seq_along(data)){
    sums[j] = sums[j] + data[j]
  }

  if(i==1) {
    print(files[i])
    write.csv(data, file="data1.csv", row.names = FALSE)
  }
  #Calculate max and min for width
  #data_max = max(data)
  #data_min = min(data)
  #range = data_max - data_min
  #bin_nums = 14.0
  #bin_width = range/bin_nums

  ##Get output name and create histogram
  #title = paste("Interarrival times for lambda = ", i, sep="")
  #outname = paste("interarrival_lambda_", i, ".png", sep="")
  #png(outname)
  #graph = hist(data, breaks=seq(0, data_max+1, by=0.1), freq=FALSE, main=title, xlim=c(data_min, data_max))
  #dev.off()
}

avgs = numeric(100000)
for(i in seq_along(sums)){
  avgs[i] = sums[i] / 20
}

write.csv(sums, file="sums.csv", row.names = FALSE)
write.csv(avgs, file="averages.csv", row.names = FALSE)
