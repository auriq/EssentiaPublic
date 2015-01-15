#!/bin/bash
# wiki simply uses more memory than a t1.micro has. To run wikiscript use a larger instance.

f () {
    command=`echo $BASH_COMMAND | cut -c1-60 | sed 's/$/ .../g'`
    echo "error on line ${BASH_LINENO[0]} : $command"
    exit 1
}
trap f ERR


# This script imports two hours of the publicly available Wikipedia Traffic Statistics V2 dataset into a database and sums the page counts and bytes for each unique value of the combination of page name and project code. 
# It also keeps track of the maximum and minimum page count value over the two hour period to return the range in page counts by unique page name and project code. 
# The full benchmark ran on two months of the data and could be run by modifying the rule below to categorize the two months of data instead of two hours and selecting a datastore that has the full two months of data.
 
ess instance local
ess udbd stop

#ess spec reset 
#ess spec drop database wikitwohouress2
ess spec create database wikitwohouress2 --ports=1
ess spec create table table1 s,pkey:name s,+key:code i,+add:count i,+add:bytes i,+max:maxcount i,+min:mincount
 
ess udbd start
 
ess datastore select s3://asi-public --credentials=/home/ec2-user/jobs/asi-public.csv
ess datastore scan
ess datastore rule add "*pagecounts*" wiki "YYYYMMDD-0"
ess datastore category change wiki compression gzip
ess datastore summary
 
ess task stream wiki "2009-01-01" "2009-01-01" "aq_pp -f,sep=' ',eok - -d s:code s:name i:count i:bytes -evlc i:maxcount 'count' -evlc i:mincount 'count' -ddef -udb_imp wikitwohouress2:table1" --debug
 
ess task exec "aq_udb -exp wikitwohouress2:table1 -pp table1 -pp_evlc maxcount 'maxcount - mincount' -o - -c name code count bytes maxcount" --debug ## add if you want to ouput to S3 ## --s3out=s3://*YourBucket*/streamwikitwohouress2.csv.gz 
# Be sure to change *YourBucket* to whichever bucket you want your results output to.
