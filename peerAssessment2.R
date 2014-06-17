# getting and cleaning data
zipFile <- bzfile(description="./data/repdata-data-StormData.csv.bz2",open="r")
stormData<- read.csv(zipFile, sep="," , header=T, comment.char="")
close(zipFile)

str(stormData$EVTYPE)




sampleIndicator <- rnorm(nrow(rawdata))
rawdata$samplekey <- sampleIndicator

stormData<- subset(rawdata,samplekey < quantile(samplekey,probs=c(0.01))) 
save(rawSample,file="./data/rawSampled.rds")
