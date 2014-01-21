library(tm)
library(wordcloud)

source('../src/wordcount.R')

# input/output paths
input.file.local <- '../data/pg2701.txt'
input.file.hdfs  <- '/mobydick.txt'
output.dir.hdfs  <- '/wordcount-output'

# equivalent to hadoop dfs -copyFromLocal
hdfs.put(input.file.local, input.file.hdfs)

# execute
wordcount(input.file.hdfs, output.dir.hdfs)

## Fetch results from HDFS
results <- from.dfs(output.dir.hdfs)
results.df <- as.data.frame(results, stringsAsFactors=F)
colnames(results.df) <- c('word', 'count')
head(results.df)

## Order list by count (descending order)
results.ordered <- results.df[ with(results.df, order( -count  )), ]

# remove words with one or less characters
results.ordered <- results.ordered[!nchar(results.ordered$word) < 2, ]

# remove stopwords
newresults <- results.ordered[!results.ordered$word %in% stopwords("en"), ]

# create the wordcloud
wordcloud(newresults$word, newresults$count, scale = c(8,.3), min.freq = 2,
          max.words = 100, random.order = FALSE, random.color = FALSE,
          rot.per = .35, colors = brewer.pal(8, "Dark2"))
