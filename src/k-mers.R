## Load and initialize libraries
library(rhdfs)
hdfs.init()
library(rmr2)

fastq.reader <- function(con, nrecs) {
  lines <- readLines(con, 4)
  if (length(lines) == 0)
    NULL
  else
    keyval(lines[1], list(seq=lines[2], desc=lines[3], quality=lines[4]))
}

kmers <- function(k, input, output = NULL) {
  mapper <- function(key, values) {
    keys <- lapply(1:(nchar(values$seq)-k), function(i, s) substr(s, i, i+k-1),
                   s=values$seq)
    keyval(unlist(keys), 1)
  }
  
  reducer <- function(key, counts) {
    keyval(key, sum(counts))
  }
  
  mapreduce(input = input, output = output,
            input.format = make.input.format(format = fastq.reader, mode = "text"),
            map = mapper, reduce = reducer, combine = T)
}
