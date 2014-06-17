
library(plyr)
library(ggplot2)

summary(stormData$FATALITIES)
summary(stormData$INJURIES)
stormData$health <- stormData$FATALITIES + stormData$INJURIES
summary(stormData$health)

healthByEvtype <- ddply(subset(stormData, health > 0), .(EVTYPE), summarise, total.health = sum(health))
summary(healthByEvtype)
sumByEvtype <- healthByEvtype[order(-healthByEvtype$total.health),][1:20,]
sumByEvtype <- transform(sumByEvtype, EVTYPE = reorder(EVTYPE, total.health))
summary(sumByEvtype)

ggplot(sumByEvtype)+ geom_bar(aes(x=EVTYPE,y=total.health), stat="identity", fill="gray") +
    coord_flip() +  theme(axis.text.y=element_text(size=rel(0.8)))




                                 
