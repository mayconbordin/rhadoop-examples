# make sure that $PATH and $JAVA_HOME point to the same Java installation
# there's a difference between /usr/lib/jvm/java-6-openjdk/jre/ and /usr/lib/jvm/java-6-openjdk/
# sudo update-alternatives --config java
# sudo R CMD javareconf

Sys.setenv("HADOOP_HOME"="<path>/hadoop-1.1.2")
Sys.setenv("HADOOP_CMD"="<path>/hadoop-1.1.2/bin/hadoop")
Sys.setenv("HADOOP_STREAMING"="<path>/hadoop-1.1.2/contrib/streaming/hadoop-streaming-1.1.2.jar")

install.packages("lib/Rcpp_0.10.5.tar.gz", repos = NULL, type="source")
install.packages("lib/plyr_1.8.tar.gz", repos = NULL, type="source")

install.packages(c("RJSONIO", "bitops", "digest", "functional", "stringr", "plyr",
                   "reshape2", "slam", "wordcloud", "maps", "RColorBrewer", 
                   "classInt", "rJava"), repos="http://cran.us.r-project.org")

# install RHadoop packages
install.packages("lib/rhdfs_1.0.8.tar.gz", repos = NULL, type="source")
install.packages("lib/rmr2_2.3.0.tar.gz", repos = NULL, type="source")
install.packages("lib/tm_0.5-9.tar.gz", repos = NULL, type="source")
