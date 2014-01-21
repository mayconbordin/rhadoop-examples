source('../src/k-mers.R')

# dataset
# curl -O https://s3.amazonaws.com/public.ged.msu.edu/ecoli_ref-5m.fastq.gz
# zcat ecoli_ref-5m.fastq.gz | head -n 32 | gzip > ecoli.small.fastq.gz
input.file.local <- '../data/ecoli.small.fastq'
input.file.hdfs  <- '/ecoli.small.fastq'
output.dir.hdfs  <- '/kmers-output'

hdfs.put(input.file.local, input.file.hdfs)

kmers(3, input.file.hdfs, output.dir.hdfs)

# retrieve the results and put them in a data frame
results <- from.dfs(output.dir.hdfs)
results.df <- as.data.frame(results, stringsAsFactors=F)
colnames(results.df) <- c('kmer', 'freq')

# order results by frequency (descendent order)
results.ordered <- results.df[ with(results.df, order( -freq  )), ]

# get only the top 50 results
results.top <- head(results.ordered, 50)
results.top <- results.top[ with(results.top, order( freq  )), ]


# plot the results
dotchart(results.top$freq, labels = results.top$kmer, cex = .7, pch = 19,
         main = "Frequency of k-mers", xlab = "Frequency", ylab = "k-mer")
