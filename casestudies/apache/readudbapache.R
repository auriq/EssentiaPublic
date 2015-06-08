file <- "queryapache.sh"            # store queryapache.sh as file
rscriptfile <- "analyzeapache.R"    # store analyzeapache.R as rscriptfile
library("RESS")                     # load Essentia's R Integration package

read.udb(file)                      # call read.udb to execute the essentia statements written in queryapache.sh and save them to R dataframes command1 through command4

source(rscriptfile, echo=FALSE)     # run the R commands written in analyzeapache.R to analyze the data in the dataframes we just created.
                                    # Turn echo to TRUE to make the output less results-oriented and easier to debug.
remove(file, rscriptfile)

