#file <- "**Your_Essentia_Script**.sh"
#rscriptfile <- "**Your_R_Script**.R"

## For Apache Analysis Demonstration
file <- "timeapache.sh"
rscriptfile <- "timeapache.R"
#file <- "rintapache.sh"
#rscriptfile <- "rintapache.R"

commandcount <- 1
lineold <- ""
lines <- readLines(file)
for (line in lines) {
#  print(line)
  line <- paste(lineold,line,sep="")
  if (substr(line,nchar(line),nchar(line)) == "\\") {
       lineold <- substr(line,1,nchar(line)-1)
       next
  }
  else {
       lineold <- ""
       print(line)
  }
  if (((substr(line, 1, 13) == "ess task exec") && (substr(line, nchar(line) - 7, nchar(line)) != "#Rignore")) || ((substr(line, 1, 15) == "ess task stream") && (substr(line, nchar(line) - 8, nchar(line)) == "#Rinclude"))) {
    colspec <- TRUE
    if (grepl("-notitle", line)) {
       colspec <- FALSE
    }
    varname <- ''
    if (grepl("#R#",line)) {
       titleindex <- grepRaw("#R#",line,all=TRUE)
       varname <- substr(line, titleindex[[1]]+3, titleindex[[2]]-1)
    }
    t1 <- pipe(line,open="r")
    t2 <- read.csv(t1,header=colspec,sep=",",quote="\"'",comment.char = "#",blank.lines.skip=FALSE,allowEscapes=TRUE,skip=0)
    index <- 1
    t3 <- NULL
    separate <- grepl(" #Rseparate", line)
    for (file in seq(1,length(which(t2[,1] == 'RSTOPHERE')),1)) {
        if (separate) {
           assign(sprintf("command%i",commandcount), t2[index:(which(t2[,1] == 'RSTOPHERE')[[file]] - 1),1:ncol(t2)])
           index <- which(t2[,1] == 'RSTOPHERE')[[file]] + 1
           print(get(sprintf("command%i",commandcount)))
#           print(commandcount)
           commandcount <- commandcount + 1
        }
        else {
           t3 <- rbind(t3, t2[index:(which(t2[,1] == 'RSTOPHERE')[[file]] - 1),1:ncol(t2)])
           index <- which(t2[,1] == 'RSTOPHERE')[[file]] + 1
           if (file == length(which(t2[,1] == 'RSTOPHERE'))) {
              if (varname == '') {
                 assign(sprintf("command%i",commandcount), t3)
                 print(get(sprintf("command%i",commandcount)))
                 print(sprintf("---------------- Output Stored in command%i ----------------", commandcount))
              }
              else {
                 assign(sprintf("%s",varname), t3)
                 print(get(sprintf("%s",varname)))
                 print(sprintf("---------------- Output Stored in %s ----------------", varname))
              }
              commandcount <- commandcount + 1
           }
        }
    }
    if ((file > 1) && (grepl(" #Rseparate", line))) {
        print(sprintf("---------------- Stream Completed: %i files stored in %i commands: command%i to command%i ----------------",file, file, commandcount - file, commandcount - 1))
        close(t1)
        remove(t1)
        remove(t2)
        linepart1 <- unlist(strsplit(line,split=" "))
        t1 <- pipe(paste(linepart1[[1]],linepart1[[2]],linepart1[[3]],linepart1[[4]],linepart1[[5]],linepart1[[6]],"\"aq_pp -f,eok - -d %cols 2> /dev/null | echo %file \"", sep=" "),open="r")
        t2 <- read.csv(t1,header=FALSE,sep=",",quote="\"'",comment.char = "#",blank.lines.skip=FALSE,allowEscapes=TRUE,skip=0)
        assign(sprintf("command%i",commandcount), t2[1:file,1:ncol(t2)])
        print(get(sprintf("command%i",commandcount)))
#        print(commandcount)
        print(sprintf("---------------- Filenames stored in command%i ----------------", commandcount))
        commandcount <- commandcount + 1
    }
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

print(sprintf("---------------- There are a total of %i commands ----------------", commandcount - 1))

remove(colspec,commandcount,file,index,line,lineold,lines,separate,t3,varname)

source(rscriptfile, echo=TRUE)
# Turn echo to FALSE to make the output on your screen more results-oriented

remove(rscriptfile)
