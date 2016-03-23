library(tools)
files = list.files(pattern="*.csv")
data_ary = lapply(files, read.csv)
data_ary_len = length(data_ary)
for (i in seq(1,data_ary_len))
{
  data = unlist(data_ary[i])
  #Calculate max and min for width
  data_max = max(data)
  data_min = min(data)
  range = data_max - data_min
  bin_nums = 14.0
  bin_width = range/bin_nums

  #Get output name and create histogram
  title = file_path_sans_ext(files[i])
  outname = paste(title, ".png", sep="")
  png(outname)
  graph = hist(data, breaks=seq(0, data_max+1, by=0.1), freq=FALSE, main=title, xlim=c(data_min, data_max))
  print(title)
  print(graph$counts)
  dev.off()
}
