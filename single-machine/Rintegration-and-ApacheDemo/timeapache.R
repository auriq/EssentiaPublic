### MONTHSUMMARY TABLE 
uniquevisitors <- data.frame(monthsummary = I(c(1)))
monthsummary <- merge(uniquevisitors,command1,by="monthsummary")
monthsummary[,1] <- "CurrentMonth"
print(monthsummary)

### Days of Month Counts
DaysofMonth <- command2[order(command2[,1]),]
print(DaysofMonth)

### Days of Week Counts
DaysofWeek <- command3[c(which(command3[,1] == "Sun"),which(command3[,1] == "Mon"),which(command3[,1] == "Tue"),which(command3[,1] == "Wed"),which(command3[,1] == "Thu"),which(command3[,1] == "Fri"),which(command3[,1] == "Sat")),]
print(DaysofWeek)

### Hours Counts
Hours <- command4[order(command4[,1]),]
print(Hours)



### Graphing Each Count by Percent of Max Value
# Month Aggregates
msgraph <- monthsummary[1,]
msgraph[,2] <- msgraph[,2]*100/max(msgraph[,2])
msgraph[,3] <- msgraph[,3]*100/max(msgraph[,3])
msgraph[,4] <- msgraph[,4]*100/max(msgraph[,4])

# By Day of the Month
domgraph <- DaysofMonth
domgraph[,2] <- domgraph[,2]*100/max(domgraph[,2])
domgraph[,3] <- domgraph[,3]*100/max(domgraph[,3])
domgraph[,4] <- domgraph[,4]*100/max(domgraph[,4])

# By Day of the Week
dowgraph <- DaysofWeek
dowgraph[,2] <- dowgraph[,2]*100/max(dowgraph[,2])
dowgraph[,3] <- dowgraph[,3]*100/max(dowgraph[,3])
dowgraph[,4] <- dowgraph[,4]*100/max(dowgraph[,4])

# By Hour of the Day
hourgraph <- Hours
hourgraph[,2] <- hourgraph[,2]*100/max(hourgraph[,2])
hourgraph[,3] <- hourgraph[,3]*100/max(hourgraph[,3])
hourgraph[,4] <- hourgraph[,4]*100/max(hourgraph[,4])



# Day of Month Graph
par(mar=c(5, 12.5, 6, 4) + 0.1)
barplot(t(as.matrix(domgraph[,2:4])), names.arg=domgraph[,1], col=c("black","blue","red"), beside=TRUE, main="DaysofMonth: Pages, Hits, and Bandwidth",xlab="DayofMonth",axes=FALSE,las=2) #,ylab="Proportion of Counts"
Axis(side=2,at=seq(0,max(domgraph[,2]),length.out = 11),lwd=2,labels=round(seq(0,max(DaysofMonth[,2]),length.out = 11)),line=3.5)
mtext(2,text="Percent Of Max Pages",line=5.5)
Axis(side=2, at=seq(0,max(domgraph[,3]),length.out = 11),lwd=2,labels=round(seq(0,max(DaysofMonth[,3]),length.out = 11)),line=6.5)
mtext(2,text="Percent Of Max Hits",line=8.5)
Axis(side=2, at=seq(0,max(domgraph[,4]),length.out = 11),lwd=2,labels=round(seq(0,max(DaysofMonth[,4]),length.out = 11)),line=9.5)
mtext(2,text="Percent Of Max Bandwidth",line=11.5)
legend("topright",inset=c(0,-.15),legend=c("% Of Max Pages","% Of Max Hits","% Of Max Bandwidth"),fill=c("black","blue","red"),bty="n")

# Day of Week Graph
par(mar=c(5, 9.5, 6, 4) + 0.1)
barplot(t(as.matrix(dowgraph[,2:4])), names.arg=dowgraph[,1], col=c("black","blue","red"), beside=TRUE, main="DaysofWeek: Pages, Hits, and Bandwidth",xlab="DayofWeek",axes=FALSE,las=2) #,ylab="Proportion of Counts"
Axis(side=2, at=seq(0,max(dowgraph[,2]),length.out = 10),lwd=2,labels=round(seq(0,max(DaysofWeek[,2]),length.out = 10)),line=.5)
mtext(2,text="Percent Of Max Pages",line=2.5)
Axis(side=2,at=seq(0,max(dowgraph[,3]),length.out = 10),lwd=2,labels=round(seq(0,max(DaysofWeek[,3]),length.out = 10)),line=3.5)
mtext(2,text="Percent Of Max Hits",line=5.5)
Axis(side=2, at=seq(0,max(dowgraph[,4]),length.out = 10),lwd=2,labels=round(seq(0,max(DaysofWeek[,4]),length.out = 10)),line=6.5)
mtext(2,text="Percent Of Max Bandwidth",line=8.5)
legend("topright",inset=c(0,-.15),legend=c("% of Max Pages","% of Max Hits","% of Max Bandwidth"),fill=c("black","blue","red"),bty="n")

# Hour of Day Graph
par(mar=c(5, 9.5, 6, 4) + 0.1)
barplot(t(as.matrix(hourgraph[,2:4])), names.arg=hourgraph[,1], col=c("black","blue","red"), beside=TRUE, main="Hours: Pages, Hits, and Bandwidth",xlab="Hour",axes=FALSE,las=2) #,ylab="Proportion of Counts"
Axis(side=2, at=seq(0,max(hourgraph[,2]),length.out = 10),lwd=2,labels=round(seq(0,max(Hours[,2]),length.out = 10)),line=.5)
mtext(2,text="Percent Of Max Pages",line=2.5)
Axis(side=2,at=seq(0,max(hourgraph[,3]),length.out = 10),lwd=2,labels=round(seq(0,max(Hours[,3]),length.out = 10)),line=3.5)
mtext(2,text="Percent Of Max Hits",line=5.5)
Axis(side=2, at=seq(0,max(hourgraph[,4]),length.out = 10),lwd=2,labels=round(seq(0,max(Hours[,4]),length.out = 10)),line=6.5)
mtext(2,text="Percent Of Max Bandwidth",line=8.5)
legend("topright",inset=c(0,-.15),legend=c("% of Max Pages","% of Max Hits","% of Max Bandwidth"),fill=c("black","blue","red"),bty="n")

## remember that this is proportion so a miniscule bar can still be a high number that is just much lower than an outlier on the same graph.
