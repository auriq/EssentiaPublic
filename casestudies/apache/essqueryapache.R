rscriptfile <- "analyzeapache.R"    # store analyzeapache.R as rscriptfile
library(RESS)                       # load Essentia's R Integration package

# This first query exports the data from a vector in the database that contains the counts over each month so that it can be read into R.
# We save the result in R as a dataframe called command1. However, you can use this output however you want for your own analysis,
# including piping the output directly into that analysis so that it never has to be saved.
command1 <- essQuery("aq_udb -exp logsapache3:vector3", "--debug")

# The next three statements export the day, day of the week, and hour vectors from their respective databases,
# ordering the output by the number of pages seen (in descending order). We send the output of each command directly into R and then save it into an R dataframe.
command2 <- essQuery("ess exec", "aq_udb -exp logsapache1:vector1 -sort,dec pagecount", "--debug")
command3 <- essQuery("ess exec", "aq_udb -exp logsapache4:vector4 -sort,dec pagecount", "--debug")
command4 <- essQuery("ess exec", "aq_udb -exp logsapache2:vector2 -sort,dec pagecount", "--debug")

source(rscriptfile, echo=FALSE)     # run the R commands written in analyzeapache.R to analyze the data in the dataframes we just created.
                                    # Turn echo to TRUE to make the output less results-oriented and easier to debug.
remove(rscriptfile)

