### MONTHSUMMARY TABLE ###
monthsummary <- command1[c(which(command1[,1] == "January"),which(command1[,1] == "February"),which(command1[,1] == "March"),which(command1[,1] == "April"),which(command1[,1] == "May"),which(command1[,1] == "June"),which(command1[,1] == "July"),which(command1[,1] == "August"),which(command1[,1] == "September"),which(command1[,1] == "October"),which(command1[,1] == "November"),which(command1[,1] == "December")),]
print(monthsummary)

### Days of Month Counts
domgraph <- command2[order(command2[,1]),]
print(domgraph)

### Days of Week Counts
dowgraph <- command3[c(which(command3[,1] == "Sun"),which(command3[,1] == "Mon"),which(command3[,1] == "Tue"),which(command3[,1] == "Wed"),which(command3[,1] == "Thu"),which(command3[,1] == "Fri"),which(command3[,1] == "Sat")),]
print(dowgraph)

### Hours Counts
hourgraph <- command4[order(command4[,1]),]
print(hourgraph)

### Graphing Each Count by Percent of Max Value ###
# Month Aggregates, we won't graph this since there are only two rows of data. Just view the data with print(monthsummary).

# Day of Month Graph
barplot(t(as.matrix(domgraph[,2])), names.arg=domgraph[,1], col=c("black"), beside=TRUE, main="DaysofMonth: # of Pages",xlab="DayofMonth",axes=TRUE,las=2) #,ylab="Proportion of Counts"
legend("topright",legend=c("Pages"),fill=c("black"),bty="n")
barplot(t(as.matrix(domgraph[,3])), names.arg=domgraph[,1], col=c("blue"), beside=TRUE, main="DaysofMonth: # of Hits",xlab="DayofMonth",axes=TRUE,las=2) #,ylab="Proportion of Counts"
legend("topright",legend=c("Hits"),fill=c("blue"),bty="n")
barplot(t(as.matrix(domgraph[,4])), names.arg=domgraph[,1], col=c("red"), beside=TRUE, main="DaysofMonth: Bandwidth",xlab="DayofMonth",axes=TRUE,las=2) #,ylab="Proportion of Counts"
legend("topright",legend=c("Bandwidth"),fill=c("red"),bty="n")

# Day of Week Graph
barplot(t(as.matrix(dowgraph[,2])), names.arg=dowgraph[,1], col=c("black"), beside=TRUE, main="DaysofWeek: # of Pages",xlab="DayofWeek",axes=TRUE,las=2) #,ylab="Proportion of Counts"
# Axis(side=2, at=seq(0,max(dowgraph[,2]),length.out = 10),lwd=2,labels=round(seq(0,max(DaysofWeek[,2]),length.out = 10)),line=.5)
legend("top",legend=c("Pages"),fill=c("black"),bty="n")
barplot(t(as.matrix(dowgraph[,3])), names.arg=dowgraph[,1], col=c("blue"), beside=TRUE, main="DaysofWeek: # of Hits",xlab="DayofWeek",axes=TRUE,las=2) #,ylab="Proportion of Counts"
# Axis(side=2,at=seq(0,max(dowgraph[,3]),length.out = 10),lwd=2,labels=round(seq(0,max(DaysofWeek[,3]),length.out = 10)),line=.5)
legend("top",legend=c("Hits"),fill=c("blue"),bty="n")
barplot(t(as.matrix(dowgraph[,4])), names.arg=dowgraph[,1], col=c("red"), beside=TRUE, main="DaysofWeek: Bandwidth",xlab="DayofWeek",axes=TRUE,las=2) #,ylab="Proportion of Counts"
legend("top",inset=c(0,-.08),legend=c("Bandwidth [Bytes]"),fill=c("red"),bty="n")

# Hour of Day Graph
barplot(t(as.matrix(hourgraph[,2])), names.arg=hourgraph[,1], col=c("black"), beside=TRUE, main="Hours: # of Pages",xlab="Hour",axes=TRUE,las=2) #,ylab="Proportion of Counts"
legend("topright",inset=c(0,-.15),legend=c("Pages"),fill=c("black"),bty="n")
barplot(t(as.matrix(hourgraph[,3])), names.arg=hourgraph[,1], col=c("blue"), beside=TRUE, main="Hours: # of Hits",xlab="Hour",axes=TRUE,las=2) #,ylab="Proportion of Counts"
legend("topright",inset=c(0,-.15),legend=c("Hits"),fill=c("blue"),bty="n")
barplot(t(as.matrix(hourgraph[,4])), names.arg=hourgraph[,1], col=c("red"), beside=TRUE, main="Hours: Bandwidth",xlab="Hour",axes=TRUE,las=2) #,ylab="Proportion of Counts"
legend("topright",inset=c(0,-.15),legend=c("Bandwidth [Bytes]"),fill=c("red"),bty="n")
