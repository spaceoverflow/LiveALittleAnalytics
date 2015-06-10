#!/usr/bin/Rscript
## LOOOOOOOOOL
## Dis script is ment to meek some
## Cool plotz. pls.
##
## Author: Mehdi Nellen, Tuebingen 2015

library("rjson")
library("ggplot2")
args <- commandArgs(trailingOnly = TRUE)

word      <- args[2] # woordje is allowed to be regex
json.file <- args[1] # e.g. "/home/mad-e/Desktop/analystics/live-a-little"

json.data <- fromJSON(file=json.file)
results <- list()  # will contain regex results
names   <- character()
dates   <- numeric()

containsWoordje <- function(mess, word){
  #takz message (mess) end loeks if contains de 
  #word said, then riturns name en deet
  if(length(mess$text) != 0 && grepl(word, mess$text, ignore.case = TRUE)){
    result <- list()
    result$name <- mess$from$print_name
    result$date <- mess$date
    return(result)
  }
}

for(message in json.data){
  results <- containsWoordje(message, word)
  names   <- c(names, results$name)
  dates   <- c(dates, results$date)
}

e.dates           <- as.Date(as.POSIXct(dates, origin="1970-01-01"))
names.freq        <- as.vector(table(names))
names(names.freq) <- names(table(names))

# Make the Bar plolt
png(paste("wordstats1", word,".png", sep =""))
ggplot(as.data.frame(table(names)), aes(names, Freq)) +
  geom_bar(stat="identity") +
  ggtitle(paste("woorje", word)) 
dev.off()

# Make the time series
png(paste("wordstats2", word,".png", sep =""))
ggplot(as.data.frame(table(e.dates)), aes(x=e.dates, y=Freq, group=1)) +
  geom_line() +
  ggtitle(paste("woorje", word)) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
dev.off()