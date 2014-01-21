source('../src/inverted-index.R')

# input/output paths
input.file.local <- '../data/pg2701.txt'
input.file.hdfs  <- '/pg2701.txt'
output.dir.hdfs  <- '/ii-output'

# equivalent to hadoop dfs -copyFromLocal
hdfs.put(input.file.local, input.file.hdfs)

# execute
invertedIndex(input.file.hdfs, output.dir.hdfs)

## Fetch results from HDFS
results <- from.dfs(output.dir.hdfs)
results.df <- as.data.frame(results, stringsAsFactors=F)
colnames(results.df) <- c('word', 'files')
