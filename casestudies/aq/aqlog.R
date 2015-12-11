system("time bash aqlog.sh")
# Run the essentia statements written in aqlog.sh. 
# These statements load the aqlog data into four databases to get the total number of pages and 
# hits by day, hour, month, and day-of-the-week.

library(RESS)                          
# Load Essentia's R Integration package.

aqlogday <- read.essentia('aqlogday.sh')
# Call read.essentia to execute the essentia statement written in aqlogday.sh and save it's output into to an R dataframe.

aqloghour <- read.essentia('aqloghour.sh')
# Call read.essentia to execute the essentia statement written in aqloghour.sh and save it's output into to an R dataframe.

aqlogmonth <- read.essentia('aqlogmonth.sh')
# Call read.essentia to execute the essentia statement written in aqlogmonth.sh and save it's output into to an R dataframe.

aqlogdayoftheweek <- read.essentia('aqlogdayoftheweek.sh')
# Call read.essentia to execute the essentia statement written in aqlogdayoftheweek.sh and save it's output into to an R dataframe.

source("analyzeaqlog.R", echo=FALSE)  
# Run the R commands written in analyzeaqlog.R to analyze the data in the dataframes we just created.
# Turn echo to TRUE to make the output less results-oriented and easier to debug.