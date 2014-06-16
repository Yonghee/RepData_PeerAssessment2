# load data
zipFile <- bzfile(description="./data/repdata-data-StormData.csv.bz2",open="r")
rawdata <- read.table(zipFile, sep="," , header=T)
close(zipFile)

sampleIndicator <- rnorm(nrow(rawdata))
rawdata$samplekey <- sampleIndicator

rawSample <- subset(rawdata,samplekey < quantile(samplekey,probs=c(0.01))) 
save(rawSample,file="./data/rawSampled.rds")
