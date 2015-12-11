### MONTHSUMMARY TABLE ###
monthsummary <- aqlogmonth[c(which(substr(aqlogmonth[,1],1,3) == "Jan"),which(substr(aqlogmonth[,1],1,3) == "Feb"),which(substr(aqlogmonth[,1],1,3) == "Mar"),which(substr(aqlogmonth[,1],1,3) == "Apr"),which(substr(aqlogmonth[,1],1,3) == "May"),which(substr(aqlogmonth[,1],1,3) == "Jun"),which(substr(aqlogmonth[,1],1,3) == "Jul"),which(substr(aqlogmonth[,1],1,3) == "Aug"),which(substr(aqlogmonth[,1],1,3) == "Sep"),which(substr(aqlogmonth[,1],1,3) == "Oct"),which(substr(aqlogmonth[,1],1,3) == "Nov"),which(substr(aqlogmonth[,1],1,3) == "Dec")),]
print(monthsummary)

### Days of Month Counts
domgraph <- aqlogday[order(aqlogday[,1]),]
print(domgraph)

### Days of Week Counts
dowgraph <- aqlogdayoftheweek[c(which(aqlogdayoftheweek[,1] == "Sun"),which(aqlogdayoftheweek[,1] == "Mon"),which(aqlogdayoftheweek[,1] == "Tue"),which(aqlogdayoftheweek[,1] == "Wed"),which(aqlogdayoftheweek[,1] == "Thu"),which(aqlogdayoftheweek[,1] == "Fri"),which(aqlogdayoftheweek[,1] == "Sat")),]
print(dowgraph)

### Hours Counts
hourgraph <- aqloghour[order(aqloghour[,1]),]
print(hourgraph)

### Graphing Each Count by Percent of Max Value ###
# Month Aggregates, we won't graph this since there are only three rows of data. Just view the data with print(monthsummary).
barplot(t(as.matrix(monthsummary[,2])), names.arg=monthsummary[,1], col=c("black"), beside=TRUE, main="Month: # of Pages",xlab="Month",axes=TRUE,las=2) #,ylab="Proportion of Counts"
legend("topright",legend=c("Pages"),fill=c("black"),bty="n")
barplot(t(as.matrix(monthsummary[,3])), names.arg=monthsummary[,1], col=c("blue"), beside=TRUE, main="Month: # of Hits",xlab="Month",axes=TRUE,las=2) #,ylab="Proportion of Counts"
legend("topright",legend=c("Hits"),fill=c("blue"),bty="n")

# Day of Month Graph
barplot(t(as.matrix(domgraph[,2])), names.arg=domgraph[,1], col=c("black"), beside=TRUE, main="DaysofMonth: # of Pages",xlab="DayofMonth",axes=TRUE,las=2) #,ylab="Proportion of Counts"
legend("topright",legend=c("Pages"),fill=c("black"),bty="n")
barplot(t(as.matrix(domgraph[,3])), names.arg=domgraph[,1], col=c("blue"), beside=TRUE, main="DaysofMonth: # of Hits",xlab="DayofMonth",axes=TRUE,las=2) #,ylab="Proportion of Counts"
legend("topright",legend=c("Hits"),fill=c("blue"),bty="n")

# Day of Week Graph
barplot(t(as.matrix(dowgraph[,2])), names.arg=dowgraph[,1], col=c("black"), beside=TRUE, main="DaysofWeek: # of Pages",xlab="DayofWeek",axes=TRUE,las=2) #,ylab="Proportion of Counts"
# Axis(side=2, at=seq(0,max(dowgraph[,2]),length.out = 10),lwd=2,labels=round(seq(0,max(DaysofWeek[,2]),length.out = 10)),line=.5)
legend("top",legend=c("Pages"),fill=c("black"),bty="n")
barplot(t(as.matrix(dowgraph[,3])), names.arg=dowgraph[,1], col=c("blue"), beside=TRUE, main="DaysofWeek: # of Hits",xlab="DayofWeek",axes=TRUE,las=2) #,ylab="Proportion of Counts"
# Axis(side=2,at=seq(0,max(dowgraph[,3]),length.out = 10),lwd=2,labels=round(seq(0,max(DaysofWeek[,3]),length.out = 10)),line=.5)
legend("top",legend=c("Hits"),fill=c("blue"),bty="n")

# Hour of Day Graph
barplot(t(as.matrix(hourgraph[,2])), names.arg=hourgraph[,1], col=c("black"), beside=TRUE, main="Hours: # of Pages",xlab="Hour",axes=TRUE,las=2) #,ylab="Proportion of Counts"
legend("topright",inset=c(0,-.15),legend=c("Pages"),fill=c("black"),bty="n")
barplot(t(as.matrix(hourgraph[,3])), names.arg=hourgraph[,1], col=c("blue"), beside=TRUE, main="Hours: # of Hits",xlab="Hour",axes=TRUE,las=2) #,ylab="Proportion of Counts"
legend("topright",inset=c(0,-.15),legend=c("Hits"),fill=c("blue"),bty="n")
