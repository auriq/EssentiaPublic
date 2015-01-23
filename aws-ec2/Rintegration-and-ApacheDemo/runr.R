#file <- "**Your_Essentia_Script**.sh"
#rscriptfile <- "**Your_R_Script**.R"

## For Apache Analysis Demonstration
file <- "querytimeapache.sh"
rscriptfile <- "timeapache.R"
#file <- "rintapache.sh"
#rscriptfile <- "rintapache.R"

source("integrater.R", echo=FALSE)
source(rscriptfile, echo=FALSE)
# Turn echo to FALSE to make the output on your screen more results-oriented
remove(rscriptfile)

