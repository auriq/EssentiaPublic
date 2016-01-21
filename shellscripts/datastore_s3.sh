#!/bin/bash
trap "exit;" SIGINT
testnum=1
logfile="datastore_s3_tests"
version=essV`(ess -v 2>&1 | grep Essentia | cut -d ' ' -f3)`
echo $version

report ()
{
    rcode=$?
    if [ $# -lt 2 ] ; then
      echo "ERROR!!! 2 arguments needed for test." 
    fi

    if [ $rcode -eq $1 ] ; then
        printf "    %2d  PASS: %s\n" ${testnum} "$2"
    else
        printf "!!  %2d  FAIL: %s\n" ${testnum} "$2" 
    fi

    if [ $# -eq 4 ] ; then
        if [ $3 -ne $4 ] ; then
            printf "!!  %2d  FAIL: Expected %3d, got %3d\n" ${testnum} $3 $4 
        fi
    fi

    let "testnum +=1"
}


##
## SELECT
##

ess select s3://asi-essentiapublic --aws_access_key AKIAJJ2NEBGDF7I7FVZA --aws_secret_access_key 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

report 0 "datastore select with credential file"

##
## LS
##

ess ls  
report 0 "ls with no options"

ess ls "diy_woodworking/" -r 
report 0 "ls with recursion" 

ess ls "diy_woodworking/*2014090[1-9]*"    
report 0 "ls directory with * wildcard" 

##
## Categorization
##

ess category add browse   'diy_woodworking/*.csv.gz' 
report 0 "added gz files"

ess category add browse 'diy_woodworking/browse*.csv.gz' --overwrite
report 0 "overwrite category"

ess category add purchase 'diy_woodworking/purchase*.csv.gz' --usecache 
report 0 "add cat using cache" 

ess ls --cat=browse
report 0 "list files of a certain category" 


ess summary 
report 0 "Categories summary of datastore" 

ess category add gift "dateformat/gift_nodate.csv" 
report 0 "none date on the full path"                

ess category add climate "climate/105*-1940.op" --dateformat="none"  
ess category change dateformat climate '*-Y' 
report 0 "cat change dateformat" 

ess category add climate "climate/105*-1940.op" --dateformat="*-Y" --preprocess="logcnv  -f,+1,eok - -d s,n=7,trm:stn s,n=7,trm:wban s,n=4,trm:year s,n=6,trm:moda s,n=7,trm:temp s,n=4,trm:Tobs s,n=7,trm:dewp s,n=4,trm:Dobs s,n=7,trm:slp s,n=4,trm:Sobs s,n=7,trm:stp s,n=4,trm:Pobs s,n=6,trm:visib s,n=4,trm:Vobs s,n=6,trm:wdsp s,n=4,trm:Wobs s,n=7,trm:mxspd s,n=7,trm:gust s,n=6,trm:max s,n=2,trm:xf s,n=6,trm:min s,n=2,trm:nf s,n=5,trm:prcp s,n=2,trm:pf s,n=7,trm:sndp s,n=6,trm:frshtt" --overwrite 
report 0 "added cat with preprocess"          

ess category add DIYregex 'diy_woodworking/*.csv.gz' --dateregex='_[:%Y:][:%m:][:%d:]' 
report 0 "added cat with regex YYYYmmdd" 

#
# fileops commands
#

