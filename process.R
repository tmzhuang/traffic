#!/usr/bin/env Rscript
require('plotrix')
files = list.files(pattern="*.csv")
for(f in files)
{
  #Get data from csv
  print(f)
  csv = read.csv(f)
  data = csv[,1]
  print(mean(data))

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
