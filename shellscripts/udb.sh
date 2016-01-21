#!/bin/sh

testnum=1
logfile="server_tests"

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
            printf "!!  %2d  FAIL: Expected %3d lines of output, got %3d\n" ${testnum} $3 $4 
        fi
    fi

    let "testnum +=1"
}


ess server reset 
report 0 "spec reset"

ess create database t1  
report 0 "create database"

ess create table cj s,hash:UserID 
ess create table cj2 s,hash:UserID 

ess server commit 
report 0 "upload spec files and bring up UDB daemons"

ess drop table CJ
report 0 "Drop table using case insensitive name"

ess drop table cj2 
report 0 "Drop table"

ess create vector p s,hash:UserID 
ess create vector p2 s,hash:UserID 

ess drop vector p2 
report 0 "Drop vector"

ess create variable i:count 
ess drop variable 
report 0 "Drop variable"

ess drop database t1 
report 0 "Drop database"
