## Load and initialize libraries
library(rhdfs)
hdfs.init()
library(rmr2)

# Define the wordcount application
invertedIndex = function(input, output = NULL, pattern = '[[:punct:][:space:]]+') {
  mapper <- function(., lines) {
    keyval(tolower(unlist(strsplit(x = lines, split = pattern))), Sys.getenv("map_input_file"))
  }
  
  reducer <- function(word, filenames) {
    keyval(word, toString(unique(unlist(filenames, use.names=FALSE))))
  }
  
  mapreduce(input = input, output = output, input.format = "text",
            map = mapper, reduce = reducer, combine = T)
}
