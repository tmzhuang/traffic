#!/usr/bin/env Rscript
require('plotrix')
for(i in seq(1,9,2))
{
  #Get filename 
  filename = paste("interarrival_lambda_", i, ".csv", sep="")

  #Get data from csv
  csv = read.csv(filename)
  data = csv[,"interarrival_times"]

  #Calculate max and min for width
  data_max = max(data)
  data_min = min(data)
  range = data_max - data_min
  bin_nums = 14.0
  bin_width = range/bin_nums

  #Get output name and create histogram
  title = paste("Interarrival times for lambda = ", i, sep="")
  outname = paste("interarrival_lambda_", i, ".png", sep="")
  png(outname)
  graph = hist(data, breaks=seq(0, data_max+1, by=0.1), freq=FALSE, main=title, xlim=c(data_min, data_max))
  dev.off()
}
