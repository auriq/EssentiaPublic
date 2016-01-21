#!/bin/bash

testnum=1
logfile="task_tests"

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
            printf "!!  %2d  FAIL: Expected %3d lines of output, got %3d\n" ${testnum} $3 $4 
        fi
    fi

    let "testnum +=1"
}

##### s3 tests
ess select s3://asi-essentiapublic --aws_access_key AKIAJJ2NEBGDF7I7FVZA --aws_secret_access_key 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
report 0 "s3: Selected datastore"

ess category add purchase 'diy_woodworking/purchase*.csv.gz' \
--columnspec='S:purchaseDate S:userID I:articleID f:price I:referrerID' 
report 0 "s3: added gz based category"

ess stream purchase 2014-09-01 2014-09-02 
report 0 "s3: streamed 2 days of files" 

ess stream purchase 2014-09-01 2014-09-02 --bulk 
report 0 "s3: streamed 2 days of files with bulk" 

ess stream purchase 2014-09-01 2014-09-02 'wc -l' --bulk
report 0 "s3: streamed 2 days of files with bulk, count total lines" 

ess stream purchase '*' 2014-09-03 'wc -l' 
report 0 "s3: stream with lower limit, count total lines for each file" 

ess stream purchase 2014-09-29 '*'
report 0 "s3: stream with upper limit" 
