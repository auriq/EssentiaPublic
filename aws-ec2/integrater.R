#file <- "analyze-apache-weblogdata.sh"
#file <- "processyourdata.sh"
file <- "calculatesumandmaximum.sh"
rscriptfile <- "**YourScript**.R"

commandcount <- 0
lines <- readLines(file)
for (line in lines) {
    #print(line)
    if ((substr(line, 1, 13) == "ess task exec") && (substr(line, nchar(line) - 7, nchar(line)) != "#Rignore")) {
       commandcount <- commandcount + 1
       t1 <- pipe(line,open="r")
       t2 <- read.csv(t1,header=TRUE,sep=",",quote="\"'",comment.char = "#",blank.lines.skip=FALSE,allowEscapes=TRUE)
       assign(sprintf("command%i",commandcount), t2[1:(which(t2[,1] == 'RSTOPHERE')[[1]] - 1),])
       print(get(sprintf("command%i",commandcount)))
       remove(t1)
       remove(t2)
    }
    else {
       system(line)
    }
}
#print("THE FOLLOWING IS COMMAND 1")
#print(command1)
print(rscriptfile)
