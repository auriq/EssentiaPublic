#!/bin/bash

testnum=1
logfile="query_tests"
version=essV`(ess -v 2>&1 | grep Essentia | cut -d ' ' -f3)`
echo $version

report ()
{
    rcode=$?
    if [ $# -lt 2 ] ; then
      echo "ERROR!!! 2 arguments needed for test." 
      exit
    fi

    if [ $rcode -eq $1 ] ; then
        printf "    %2d  PASS: %s\n" ${testnum} "$2"
    else
        printf "!!  %2d  FAIL: %s\n" ${testnum} "$2" 
    fi

    if [ $# -eq 4 ] ; then
        if [ $3 -ne $4 ] ; then
            printf "!!  %2d  FAIL: Expected %3d as output, got %3d\n" ${testnum} $3 $4 
        fi
    fi
    let "testnum +=1"
}


ess select s3://asi-essentiapublic --aws_access_key AKIAJJ2NEBGDF7I7FVZA --aws_secret_access_key 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
report 0 "Selected datastore"

ess category add purchase 'diy_woodworking/purchase*.csv.gz' \
--columnspec='S:purchaseDate S:userID I:articleID f:price I:referrerID' --overwrite  
report 0 "added gz based category"

ess query "select * from purchase:2014-09-01:2014-09-02" 
report 0 "SELECT from 2 days of logs" 

ess query "select count(articleID) from purchase:2014-09-01:2014-09-01 group by userID" 
report 0 "COUNT from 1 days of logs" 

ess query "select * from purchase:2014-09-01:2014-09-01 order by price" 
report 0 "select with order" 

ess query "select count(distinct userID) from purchase:2014-09-01:2014-09-01"
report 0 "COUNT DISTINCT" 

ess query "select count(userID),articleID from purchase:2014-09-01:2014-09-01 group by articleID"
report 0 "GROUP BY"

ess query "select count(distinct articleID) from purchase:2014-09-01:2014-09-10 WHERE price > 5" 
report 0 "WHERE" 

ess query 'select count(distinct referrerID) from purchase:*:* WHERE PatCmp(userID,"66")' 
report 0 "WHERE"