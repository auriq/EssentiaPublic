#file <- "**Your_Essentia_Script**.sh"
#rscriptfile <- "**Your_R_Script**.R"

## For Apache Analysis Demonstration
file <- "rintapache.sh"
rscriptfile <- "rintapache.R"

commandcount <- 0
lines <- readLines(file)
for (line in lines) {
  #print(line)
  if (((substr(line, 1, 13) == "ess task exec") && (substr(line, nchar(line) - 7, nchar(line)) != "#Rignore")) || ((substr(line, 1, 15) == "ess task stream") && (substr(line, nchar(line) - 8, nchar(line)) == "#Rinclude"))) {
    commandcount <- commandcount + 1
    skiplines <- 0
    if ((substr(line, 1, 15) == "ess task stream") && (substr(line, nchar(line) - 8, nchar(line)) == "#Rinclude")) {
      skiplines <- 1
    }
    t1 <- pipe(line,open="r")
    t2 <- read.csv(t1,header=TRUE,sep=",",quote="\"'",comment.char = "#",blank.lines.skip=FALSE,allowEscapes=TRUE,skip=skiplines)
    assign(sprintf("command%i",commandcount), t2[1:(which(t2[,1] == 'RSTOPHERE')[[1]] - 1),1:ncol(t2)])
    #print(get(sprintf("command%i",commandcount)))
    close(t1)
    remove(t1)
    remove(t2)
  }
  else {
    if (line != "") {
      system(line)
    }
  }
}

source(rscriptfile, echo=TRUE)
# Turn echo to FALSE to make the output on your screen more results-oriented
