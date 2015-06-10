#!/usr/bin/Rscript
## LOOOOOOOOOL
## Dis script is ment to meek some
## Cool plotz. pls.
##
## Author: Mehdi Nellen, Tuebingen 2015

library("rjson")
library("ggplot2")

word <- "kanker" # woordje is allowed to be regex
json_file <- "/home/mad-e/Desktop/analystics/live-a-little"

json_data <- fromJSON(file=json_file)
results <- list()  # will contain regex results
names <- character()
dates <- numeric()

containsWoordje <- function(mess, word){
  #takz message (mess) end loeks if contains de 
  #word said, then riturns name en deet
  if(length(mess$text) != 0 && grepl(word, mess$text)){
    result <- list()
    result$name <- mess$from$print_name
    result$date <- mess$date
    return(result)
  }
}

for(message in json_data){
  print(message$text)
  print(message$from$print_name)
  #print(message)
  results <- containsWoordje(message, word)
  names <- c(names, results$name)
  dates <- c(dates, results$date)
}

e.dates <- as.Date(as.POSIXct(dates, origin="1970-01-01"))
print(table(names))
names.freq <- as.vector(table(names))
names(names.freq) <- names(table(names))

# Make the Bar plolt
ggplot(as.data.frame(table(names)), aes(names, Freq)) +
  geom_bar(stat="identity") +
  ggtitle(paste("woorje", word)) 

# Make the time series
ggplot(as.data.frame(table(e.dates)), aes(x=e.dates, y=Freq, group=1)) +
  geom_line() +
  ggtitle(paste("woorje", word)) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))