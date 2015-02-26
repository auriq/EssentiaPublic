#file <- "**Your_Essentia_Script**.sh"
#rscriptfile <- "**Your_R_Script**.R"

## For Apache Analysis Demonstration
file <- "querytimeapache.sh"
rscriptfile <- "timeapache.R"
#file <- "queryrintapache.sh"
#rscriptfile <- "rintapache.R"

source("integrater.R", echo=FALSE)
source(rscriptfile, echo=FALSE)
# Turn echo to TRUE to make the output less results-oriented and easier to debug.
remove(rscriptfile)

