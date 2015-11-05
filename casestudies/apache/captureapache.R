library("RESS")                     # load Essentia's R Integration package

# call capture.essentia to execute the essentia statements written in queryapache.sh and save them to R dataframes command1 through command4
capture.essentia("queryapache.sh")

# run the R commands written in analyzeapache.R to analyze the data in the dataframes we just created. Turn echo to TRUE to make the output less results-oriented and easier to debug.
source("analyzeapache.R", echo=FALSE)