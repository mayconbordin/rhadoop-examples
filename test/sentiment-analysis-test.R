library(maps)
library(RColorBrewer)
library(classInt)

source('../src/sentiment-analysis.R')

# input/output paths
input.file.local <- '../data/tweets.dataset'
input.file.hdfs  <- '/tweets.dataset'
output.dir.hdfs  <- '/twitter-output'

# equivalent to hadoop dfs -copyFromLocal
hdfs.put(input.file.local, input.file.hdfs)

# load opinion lexicons
pos_words <- scan('../data/positive-words.txt', what='character', comment.char=';')
neg_words <- scan('../data/negative-words.txt', what='character', comment.char=';')

# execute the application
sentimentAnalysis(input.file.hdfs, output.dir.hdfs, pos_words, neg_words)

# fetch results from HDFS
results <- from.dfs(output.dir.hdfs)

# put the result in a dataframe
results.df <- ldply(results$val, function(s) {
  strSplit <- unlist(strsplit(s, ","))
  if (nchar(strSplit[2]) > 0 && nchar(strSplit[3]) > 0)
    c(as.numeric(strSplit[1]), as.numeric(strSplit[2]), as.numeric(strSplit[3]))
})
colnames(results.df) <- c('score', 'lat', 'lon')

# create the map
map("state", interior = FALSE)
map("state", boundary = FALSE, col="gray", add = TRUE)

# Define number of colours to be used in plot
scoreRange <- range(results.df$score)
nclr <- length(scoreRange[1]:scoreRange[2])

# Define colour palette to be used
plotclr <- brewer.pal(nclr,"RdYlBu")

# Define colour intervals and colour code variable for plotting
class <- classIntervals(results.df$score, nclr, style = "pretty")
colcode <- findColours(class, plotclr)

# plot the points
points(results.df$lon, results.df$lat, pch = 16, col = colcode, cex = 2)

# create a legend
legend("bottomright", legend = names(attr(colcode, "table")),
       fill = attr(colcode, "palette"), cex = 0.7, bty = "n")
