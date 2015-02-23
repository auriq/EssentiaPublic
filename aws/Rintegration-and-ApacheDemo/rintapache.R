# WARNING: Hardcoded some of the information in here. In particular, the commands' bandwidth 
# conversion must be entered for each command.



### MONTHSUMMARY TABLE (BOTH VIEWED AND NON-VIEWED)
uniquevisitors <- data.frame(monthsummary = I(c(1)), uniques = c(command1[,2][[2]]))
monthsummary <- merge(merge(uniquevisitors,command14,by="monthsummary"),command2,by="monthsummary")
command17["uniques"] <- NA
command17["visitcount"] <- NA
monthsummary <- rbind(monthsummary,command17)
monthsummary[,1] <- "CurrentMonth"
print(monthsummary)

### OS COUNTS AND PERCENTAGES
OScounts <- command9
OScounts[,1] <- sub(".*java.*","Java",OScounts[,1])
OScounts[,1] <- sub(".*win.*","Windows",ignore.case=TRUE,OScounts[,1])
OScounts[,1] <- sub(".*mac.*","Macintosh",ignore.case=TRUE,OScounts[,1])
OScounts[,1] <- sub(".*iphone.*","iOS",ignore.case=TRUE,OScounts[,1])
OScounts[,1] <- sub(".*iOS.*","iOS",ignore.case=FALSE,OScounts[,1])
OScounts[,1] <- sub(".*ipad.*","iOS",ignore.case=TRUE,OScounts[,1])
OScounts[,1] <- sub(".*android.*","Android",ignore.case=TRUE,OScounts[,1])
OScounts[,1] <- sub(".*linux.*","Linux",ignore.case=TRUE,OScounts[,1])
OScounts[,1] <- sub(".*unix.*","Other Unix System",ignore.case=TRUE,OScounts[,1])
OScounts[,1] <- sub("^$","Unknown",ignore.case=FALSE,fixed=FALSE,OScounts[,1])
OScounts[,1][(OScounts[,1]!="Java")&(OScounts[,1]!="Windows")&(OScounts[,1]!="Macintosh")&(OScounts[,1]!="iOS")&(OScounts[,1]!="Android")&(OScounts[,1]!="Linux")&(OScounts[,1]!="Other Unix System")&(OScounts[,1]!="Unknown")] <- "Other"
OScounts <- aggregate(OScounts[,2-3],by=list(OScounts[,1]),FUN=sum)
OScounts[,4] <- OScounts[,3] 
OScounts[,3] <- paste(prop.table(OScounts[,2])*100, "%", sep="")
OScounts[,5] <- paste(prop.table(OScounts[,4])*100, "%", sep="")
names(OScounts) <- c("OS","Pages","Percent","Hits","Percent")
print(OScounts)

### BROWSER COUNTS AND PERCENTAGES
Bcounts <- command10
Bcounts[,1] <- sub(".*chrome.*","Chrome",Bcounts[,1])
Bcounts[,1] <- sub(".*msie.*","Internet_Explorer",ignore.case=TRUE,Bcounts[,1])
Bcounts[,1] <- sub(".*internet explorer.*","Internet_Explorer",ignore.case=TRUE,Bcounts[,1])
Bcounts[,1] <- sub(".*firefox.*","Firefox",ignore.case=TRUE,Bcounts[,1])
Bcounts[,1] <- sub(".*opera.*","Opera",ignore.case=TRUE,Bcounts[,1])
Bcounts[,1] <- sub(".*safari.*","Safari",ignore.case=FALSE,Bcounts[,1])
Bcounts[,1] <- sub(".*mozilla.*","Mozilla",ignore.case=TRUE,Bcounts[,1])
Bcounts[,1] <- sub(".*android.*","Android",ignore.case=TRUE,Bcounts[,1])
Bcounts[,1] <- sub(".*netscape.*","Netscape",ignore.case=TRUE,Bcounts[,1])
Bcounts[,1] <- sub("^$","Unknown",ignore.case=FALSE,fixed=FALSE,Bcounts[,1])
Bcounts[,1][(Bcounts[,1]!="Mozilla")&(Bcounts[,1]!="Chrome")&(Bcounts[,1]!="Internet_Explorer")&(Bcounts[,1]!="Firefox")&(Bcounts[,1]!="Android")&(Bcounts[,1]!="Opera")&(Bcounts[,1]!="Safari")&(Bcounts[,1]!="Unknown")&(Bcounts[,1]!="Netscape")] <- "Other"
Bcounts <- aggregate(Bcounts[,2-3],by=list(Bcounts[,1]),FUN=sum)
Bcounts[,4] <- Bcounts[,3] 
Bcounts[,3] <- paste(prop.table(Bcounts[,2])*100, "%", sep="")
Bcounts[,5] <- paste(prop.table(Bcounts[,4])*100, "%", sep="")
names(Bcounts) <- c("Browser","Pages","Percent","Hits","Percent")
print(Bcounts)

### SEARCH KEY PHRASES COUNT AND PERCENT
SearchKeys <- command11 
SearchKeys[,1] <- sub("^$","NoSearchEngine",ignore.case=FALSE,fixed=FALSE,SearchKeys[,1])
SearchKeys[,1] <- sub("^-$","NoKey",ignore.case=FALSE,fixed=FALSE,SearchKeys[,1])
SearchKeys[,3] <- paste(prop.table(SearchKeys[,2])*100, "%", sep="")
names(SearchKeys) <- c("SearchKeys","Search","Percent")
print(SearchKeys)

### Bad HTTP Status Codes COUNTS AND PERCENTS
BadStatus <- command16
BadStatus[,5] <- BadStatus[,4] 
BadStatus[,6] <- BadStatus[,4]
BadStatus[,4] <- BadStatus[,3]
BadStatus[,3] <- paste(prop.table(BadStatus[,2])*100, "%", sep="")
BadStatus[,5] <- paste(prop.table(BadStatus[,4])*100, "%", sep="")
names(BadStatus) <- c("HTTP_Status_Code","Pages","Percent","Hits","Percent","Bandwidth")
print(BadStatus)

### Visit Duration Counts and Percents
Duration <- command15[c(which(command15[,1] == "0 - 30s"),which(command15[,1] == "30s - 2min"),which(command15[,1] == "2min - 5min"),which(command15[,1] == "5min - 15min"),which(command15[,1] == "15min - 30min"),which(command15[,1] == "30min - 1hr"),which(command15[,1] == "1hr+")),]
Duration[,3] <- paste(prop.table(Duration[,2])*100, "%", sep="")
names(Duration) <- c("Visit_Duration","Visit_Count","Percent")
print(Duration)

### Days of Month Visits and Counts
DayCounts <- command4[order(command5[,1]),]
DayVisits <- command13[order(command15[,1]),]
DaysofMonth <- merge(command13, command4, by="day")
print(DaysofMonth)

### Days of Week Visits and Counts
DaysofWeek <- command5[c(which(command5[,1] == "Sun"),which(command5[,1] == "Mon"),which(command5[,1] == "Tue"),which(command5[,1] == "Wed"),which(command5[,1] == "Thu"),which(command5[,1] == "Fri"),which(command5[,1] == "Sat")),]
print(DaysofWeek)

### Hours Visits and Counts
Hours <- command6[order(command6[,1]),]
print(Hours)



### Graphing Each Count by Percent of Max Value
# Month Aggregates
msgraph <- monthsummary[1,]
msgraph[,2] <- msgraph[,2]*100/max(msgraph[,2])
msgraph[,3] <- msgraph[,3]*100/max(msgraph[,3])
msgraph[,4] <- msgraph[,4]*100/max(msgraph[,4])
msgraph[,5] <- msgraph[,5]*100/max(msgraph[,5])
msgraph[,6] <- msgraph[,6]*100/max(msgraph[,6])

# By Day of the Month
domgraph <- DaysofMonth
domgraph[,2] <- domgraph[,2]*100/max(domgraph[,2])
domgraph[,3] <- domgraph[,3]*100/max(domgraph[,3])
domgraph[,4] <- domgraph[,4]*100/max(domgraph[,4])
domgraph[,5] <- domgraph[,5]*100/max(domgraph[,5])

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

# By Country ## Limited to countries representing at least 1% of traffic
countrygraph <- command7
countrygraph[,2] <- countrygraph[,2]*100/max(countrygraph[,2])
countrygraph[,3] <- countrygraph[,3]*100/max(countrygraph[,3])
countrygraph[,4] <- countrygraph[,4]*100/max(countrygraph[,4])
cgraph <- data.frame(Country = countrygraph[,1][countrygraph[,2]>=1|countrygraph[,3]>=1|countrygraph[,4]>=1], Pages = countrygraph[,2][countrygraph[,2]>=1|countrygraph[,3]>=1|countrygraph[,4]>=1], Hits = countrygraph[,3][countrygraph[,2]>=1|countrygraph[,3]>=1|countrygraph[,4]>=1], Pagebytes = countrygraph[,4][countrygraph[,2]>=1|countrygraph[,3]>=1|countrygraph[,4]>=1])

# By Page URL ## Limited to page urls representing at least 1% of traffic
pagegraph <- command12
pagegraph[,2] <- pagegraph[,2]*100/max(pagegraph[,2])
pagegraph[,3] <- pagegraph[,3]*100/max(pagegraph[,3])
pgraph <- data.frame(PageURL = pagegraph[,1][pagegraph[,2]>=1|pagegraph[,3]>=1], Pagecount = pagegraph[,2][pagegraph[,2]>=1|pagegraph[,3]>=1], Pagebytes = pagegraph[,3][pagegraph[,2]>=1|pagegraph[,3]>=1])



# Day of Month Graph
par(mar=c(5, 12.5, 6, 4) + 0.1)
barplot(t(as.matrix(domgraph[,2:5])), names.arg=domgraph[,1], col=c("black","blue","red","gray"), beside=TRUE, main="DaysofMonth: Visits, Pages, Hits, and Bandwidth",xlab="DayofMonth",axes=FALSE,las=2) #,ylab="Proportion of Counts"
Axis(side=2, at=seq(0,max(domgraph[,2]),length.out = 11),lwd=2,labels=round(seq(0,max(DaysofMonth[,2]),length.out = 11)),line=.5)
mtext(2,text="Percent Of Max Visits",line=2.5)
Axis(side=2,at=seq(0,max(domgraph[,3]),length.out = 11),lwd=2,labels=round(seq(0,max(DaysofMonth[,3]),length.out = 11)),line=3.5)
mtext(2,text="Percent Of Max Pages",line=5.5)
Axis(side=2, at=seq(0,max(domgraph[,4]),length.out = 11),lwd=2,labels=round(seq(0,max(DaysofMonth[,4]),length.out = 11)),line=6.5)
mtext(2,text="Percent Of Max Hits",line=8.5)
Axis(side=2, at=seq(0,max(domgraph[,5]),length.out = 11),lwd=2,labels=round(seq(0,max(DaysofMonth[,5]),length.out = 11)),line=9.5)
mtext(2,text="Percent Of Max Bandwidth",line=11.5)
legend("topright",inset=c(0,-.15),legend=c("% of Max Visits","% Of Max Pages","% Of Max Hits","% Of Max Bandwidth"),fill=c("black","blue","red","gray"),bty="n")

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

# Country Graph
par(mar=c(5, 9.5, 6, 4) + 0.1)
barplot(t(as.matrix(cgraph[,2:4])), names.arg=cgraph[,1], col=c("black","blue","red"), beside=TRUE, main="Country: Pages, Hits, and Bandwidth",xlab="Country",axes=FALSE,las=2) #,ylab="Proportion of Counts"
Axis(side=2, at=seq(0,max(cgraph[,2]),length.out = 10),lwd=2,labels=round(seq(0,max(command7[,2]),length.out = 10)),line=.5)
mtext(2,text="Percent Of Max Pages",line=2.5)
Axis(side=2,at=seq(0,max(cgraph[,3]),length.out = 10),lwd=2,labels=round(seq(0,max(command7[,3]),length.out = 10)),line=3.5)
mtext(2,text="Percent Of Max Hits",line=5.5)
Axis(side=2, at=seq(0,max(cgraph[,4]),length.out = 10),lwd=2,labels=round(seq(0,max(command7[,4]),length.out = 10)),line=6.5)
mtext(2,text="Percent Of Max Bandwidth",line=8.5)
legend("topright",inset=c(0,-.15),legend=c("% of Max Pages","% of Max Hits","% of Max Bandwidth"),fill=c("black","blue","red"),bty="n")

# Page URL Graph
par(mar=c(7.5, 12.5, 6, 4) + 0.1)
barplot(t(as.matrix(pgraph[,2:3])), names.arg=pgraph[,1], col=c("black","red"), beside=TRUE, main="PageURL: Pages and Bandwidth",axes=FALSE,las=2,cex.names=1,horiz=TRUE) #,ylab="Proportion of Counts"
Axis(side=1, at=seq(0,max(pgraph[,2]),length.out = 10),lwd=2,labels=round(seq(0,max(command12[,2]),length.out = 10)),line=.5)
mtext(1,text="Percent Of Max Pages",line=2.5)
Axis(side=1,at=seq(0,max(pgraph[,3]),length.out = 10),lwd=2,labels=round(seq(0,max(command12[,3]),length.out = 10)),line=3.5)
mtext(1,text="Percent Of Max Bandwidth",line=5.5)
legend("topright",inset=c(0,-.15),legend=c("% of Max Pages","% of Max Bandwidth"),fill=c("black","red"),bty="n")

## remember that this is proportion so a miniscule bar can still be a high number that is just much lower than an outlier on the same graph.
print(pgraph[,1])



### Statistics
cat("STATISTICS:")
cat("\n")
for (dfname in list("monthsummary","OScounts","Bcounts","SearchKeys","BadStatus","Duration","DaysofMonth","DaysofWeek","Hours","command4","command8","command9","command13")) {
  print(paste("-----------------",dfname,"-----------------",sep=" "))
  df <- get(dfname)
  print(summary(df[,2:ncol(df)]))
  # Standard Deviation:
  print(sapply(df[,2:ncol(df)], sd))
  #print(sapply(df, var, na.rm=FALSE))
  cat("\n")
}



######## The following is unecessary for the analysis. It simply makes it easier for the user to make use of the provided results.

### Make Pagebytes Readable...Turn into Bandwidth
## Installing and Using Packages
#install.packages("gdata")
#library(gdata)
#monthsummary[,"pagebytes"] <- humanReadable(monthsummary[,"pagebytes"],digits=2,width=NULL)
#command3[,"pagebytes"] <- humanReadable(command3[,"pagebytes"],digits=2,width=NULL)
#DaysofMonth[,"pagebytes"] <- humanReadable(DaysofMonth[,"pagebytes"],digits=2,width=NULL)
#DaysofWeek[,"pagebytes"] <- humanReadable(DaysofWeek[,"pagebytes"],digits=2,width=NULL)
#Hours[,"pagebytes"] <- humanReadable(Hours[,"pagebytes"],digits=2,width=NULL)
#command7[,"pagebytes"] <- humanReadable(command7[,"pagebytes"],digits=2,width=NULL)
#command8[,"pagebytes"] <- humanReadable(command8[,"pagebytes"],digits=2,width=NULL)
#BadStatus[,"Bandwidth"] <- humanReadable(BadStatus[,"Bandwidth"],digits=2,width=NULL)

### Checking that Bandwidth is Readable
#print(DaysofMonth)


### Run to save results to local files
## saving to directory /home/ec2-user/samples/
# write.csv(monthsummary, file = "/home/ec2-user/samples/monthsummary.csv",row.names=FALSE)
# write.csv(OScounts, file = "/home/ec2-user/samples/OScounts.csv",row.names=FALSE)
# write.csv(Bcounts, file = "/home/ec2-user/samples/Bcountsy.csv",row.names=FALSE)
# write.csv(SearchKeys, file = "/home/ec2-user/samples/SearchKeys.csv",row.names=FALSE)
# write.csv(BadStatus, file = "/home/ec2-user/samples/BadStatus.csv",row.names=FALSE)
# write.csv(Duration, file = "/home/ec2-user/samples/Duration.csv",row.names=FALSE)
# write.csv(DaysofMonth, file = "/home/ec2-user/samples/DaysofMonth.csv",row.names=FALSE)
# write.csv(DaysofWeek, file = "/home/ec2-user/samples/DaysofWeek.csv",row.names=FALSE)
# write.csv(Hours, file = "/home/ec2-user/samples/Hours.csv",row.names=FALSE)
# write.csv(command3, file = "/home/ec2-user/samples/Hosts.csv",row.names=FALSE)
# write.csv(command7, file = "/home/ec2-user/samples/Country.csv",row.names=FALSE)
# write.csv(command8, file = "/home/ec2-user/samples/AuthenticatedUsers.csv",row.names=FALSE)
# write.csv(command12, file = "/home/ec2-user/samples/Pages.csv",row.names=FALSE)