#!/usr/bin/Rscript
## Activity per user over time
##
## Author: Mehdi Nellen, Tuebingen 2015

library("rjson")
library("ggplot2")
library("plyr")

args <- commandArgs(trailingOnly = TRUE)

json.file <- args[1]  #"/home/mad-e/Desktop/analystics/live-a-little"

json.data <- fromJSON(file=json.file)
names <- character()
dates <- numeric()

for(message in json.data){
  names <- c(names, message$from$print_name)
  dates <- c(dates, message$date)
}

data <- data.frame(names=names, date=as.Date(as.POSIXct(dates, origin="1970-01-01")), mess=1)
cdata <- ddply(data, c("names", "date"), summarise, mesPerDay =sum(mess))

# plot lines
ggplot(cdata, aes(x=date, y=mesPerDay, group = names, colour = names, linetype = names)) +
  geom_line(lwd = 1) +
  scale_linetype_manual(values = c(rep("solid", 5), rep("dashed", 3)))
