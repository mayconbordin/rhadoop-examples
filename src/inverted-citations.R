## Load and initialize libraries
library(rhdfs)
hdfs.init()
library(rmr2)

invertedCitations <- function(input, output = NULL) {
  ic.map <- function(., lines) {
    split.l <- unlist(strsplit(lines, "\n"))
    split.v <- ldply(split.l, function(l) {
      lsplit <- unlist(strsplit(l, ","))
      c(lsplit[2], lsplit[1])
    })
    
    keyval(split.v$V1, split.v$V2)
  }
  
  ic.reduce <- function(citedPatent, citingPatents) {
    keyval(citedPatent, paste(citingPatents, collapse=","))
  }
  
  mapreduce(input = input, output = output, input.format = "text",
            map = ic.map, reduce = ic.reduce, combine = T)
}
