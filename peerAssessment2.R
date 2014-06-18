Sys.setlocale(category = "LC_ALL", locale = "C")
stormData <- read.csv("./data/repdata-data-StormData.csv.bz2")

exponentCodeMap <- list('0'='',
                        '1'=c('-', '?', '+'),
                        '10'=c(1),
                        '100'=c(2,'h','H'),
                        '1000'=c(3,'k','K'),
                        '10000'=c(4),
                        '100000'=c(5),
                        '1000000'=c(6,'m','M'),
                        '10000000'=c(7),
                        '100000000'=c(8),
                        '1000000000'=c(9,'b','B'))


levels(stormData$PROPDMGEXP) <- exponentCodeMap
stormData$proDmgExp.fix <- as.numeric(levels(stormData$PROPDMGEXP))[stormData$PROPDMGEXP]

levels(stormData$CROPDMGEXP) <- exponentCodeMap
stormData$cropDmgExp.fix <- as.numeric(levels(stormData$CROPDMGEXP))[stormData$CROPDMGEXP]




library(plyr)
library(ggplot2)

summary(stormData$FATALITIES)
summary(stormData$INJURIES)
stormData$harmOfHealth <- stormData$FATALITIES + stormData$INJURIES
summary(stormData$harmOfHealth)

harmOfHealthByEvtype <- ddply(subset(stormData, harmOfHealth > 0), .(EVTYPE), summarise, total.harmOfHealth = sum(harmOfHealth))
summary(harmOfHealthByEvtype)
sumByEvtype <- harmOfHealthByEvtype[order(-harmOfHealthByEvtype$total.harmOfHealth),][1:20,]
sumByEvtype <- transform(sumByEvtype, EVTYPE = reorder(EVTYPE, total.harmOfHealth))
summary(sumByEvtype)

ggplot(sumByEvtype)+ geom_bar(aes(x=EVTYPE,y=total.harmOfHealth), stat="identity", fill="gray") +
    labs(list(title="Total number of people injured or killed \n by severe weather from 1950-2011 accross the USA" , x="Event Type", y="Total number of people" )) +
    coord_flip() +  theme(axis.text.y=element_text(size=rel(0.8)))




stormData$dmgOfEncomic <- stormData$proDmgExp.fix+ stormData$cropDmgExp.fix
dmgOfEconomic.data <- ddply(subset(stormData, dmgOfEncomic >0), .(EVTYPE), summarise, total.dmgEco = sum(dmgOfEncomic))
sumByEvtype2<- dmgOfEconomic.data[order(-dmgOfEconomic.data$total.dmgEco),][1:30,]                                
sumByEvtype2 <- transform(sumByEvtype2, EVTYPE = reorder(EVTYPE,total.dmgEco))

library(scales)
ggplot(sumByEvtype2)+ geom_bar(aes(x=EVTYPE,y=total.dmgEco), stat="identity", fill="gray") +
    labs(list(title="Total amount of economical damaged by severe weather\n from 1950-2011 accross the USA" , x="Event Type", y="Total amount ( dollar )" )) +
    scale_y_continuous(labels=dollar) +
    coord_flip() +  theme(axis.text.y=element_text(size=rel(0.8)))