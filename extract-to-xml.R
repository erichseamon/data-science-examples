

library(shiny)
library(dplyr)
library(ggplot2)
library(scales)
library(zoo)
library(gridExtra)

# load some data
url1 <- paste("http://lar.wsu.edu/R_apps/2015ap4/data/mon2015_short.csv")  # monitoring sites (source)
url2 <- paste("http://lar.wsu.edu/R_apps/2015ap4/data/hrly2015.csv")       # hourly Model and OBS  data (source)
mon <- read.csv(url1, stringsAsFactors=FALSE)   # read the monitoring sites
o3pm <- read.csv(url2, stringsAsFactors=FALSE)  # read the hourly ozone and pm2.5 data
o3pm$DateTime <- strptime(o3pm$DateTime, "%m/%d/%y %H:%M", tz = "GMT")       # want to convert character to POSIXlt
o3pm$DateTime <- as.POSIXct(o3pm$DateTime, "%Y-%m-%d %H:%M:%S", tz = "GMT", usetz = FALSE)      # convert POSIXlt to POSIXct



library(XML)

xml <- xmlTree()
xml$addTag("document", close=FALSE)
for (i in 1:nrow(mon)) {
  xml$addTag("row", close=FALSE)
  for (j in names(mon)) {
    xml$addTag(j, mon[i, j])
  }
  xml$closeTag()
}
xml$closeTag()

# view the result
cat(saveXML(xml))