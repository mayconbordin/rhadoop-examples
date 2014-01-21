source('../src/inverted-citations.R')

# dataset: http://nber.org/patents/
# file: acite75_99.zip
# input/output paths
input.file.local <- '../data/patent-citations.txt'
input.file.hdfs  <- '/patent-citations.txt'
output.dir.hdfs  <- '/patent-citations-output'

# equivalent to hadoop dfs -copyFromLocal
hdfs.put(input.file.local, input.file.hdfs)

invertedCitations(input.file.hdfs, output.dir.hdfs)

# Fetch results from HDFS
results <- from.dfs(output.dir.hdfs)
results.df <- as.data.frame(results, stringsAsFactors=F)
colnames(results.df) <- c('cited', 'citing')
