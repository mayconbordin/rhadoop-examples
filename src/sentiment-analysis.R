## Load and initialize libraries
library(rhdfs)
hdfs.init()
library(rmr2)

# sentiment analysis
# source: https://github.com/jeffreybreen/twitter-sentiment-analysis-tutorial-201107
score.sentiment = function(sentence, pos.words, neg.words)
{
    require(plyr)
    require(stringr)

    # clean up sentences with R's regex-driven global substitute, gsub():
    sentence = gsub('[[:punct:]]', '', sentence)
    sentence = gsub('[[:cntrl:]]', '', sentence)
    sentence = gsub('\\d+', '', sentence)
    # and convert to lower case:
    sentence = tolower(sentence)

    # split into words. str_split is in the stringr package
    word.list = str_split(sentence, '\\s+')
    # sometimes a list() is one level of hierarchy too much
    words = unlist(word.list)

    # compare our words to the dictionaries of positive & negative terms
    pos.matches = match(words, pos.words)
    neg.matches = match(words, neg.words)
 
    # match() returns the position of the matched term or NA
    # we just want a TRUE/FALSE:
    pos.matches = !is.na(pos.matches)
    neg.matches = !is.na(neg.matches)

    # and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():
    score = sum(pos.matches) - sum(neg.matches)

    return(score)
}

json.reader <- function(con, nrecs) {
  line <- readLines(con, 1)
  if (length(line) == 0 || nchar(line) < 2)
    NULL
  else {
    h = basicJSONHandler()
    tweet = fromJSON(line, h)
    keyval(tweet$id, tweet)
  }
}

sentimentAnalysis <- function(input, output = NULL, posWords, negWords) {
  mapper <- function(id, tweet) {
    score = score.sentiment(tweet$id_str, posWords, negWords)
    keyval(id, paste(score, tweet$user$coordinates[[1]], tweet$user$coordinates[[2]], sep=","))
  }
  
  mapreduce(input = input, output = output, map = mapper,
            input.format = make.input.format(format = json.reader, mode = "text"))
}
