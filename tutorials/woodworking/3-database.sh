#!/bin/bash

# This script demonstrates how to integrate aq_pp with the UDB database
# system.
#
#
ess server reset
ess create database wood
ess create table allsales s,pkey:userid i,tkey:ptime i:articleid f:price i:refid
ess create vector usersales s,pkey:userid i,+last:articleid f,+add:total

ess udbd restart

ess stream purchase 2014-09-01 2014-09-30 \
"aq_pp -f,+1,eok,qui - -d %cols \
-eval i:ptime 'DateToTime(purchaseDate,\"Y.m.d.H.M.S\")' \
-eval is:t 'ptime - DateToTime(\"2014-09-15\",\"Y.m.d\")' \
-if -filt 't>0' \
  -eval articleID 'articleID+1' \
-endif \
-imp wood:allsales"


ess exec "aq_udb -exp wood:allsales"
ess exec "aq_udb -ord wood:allsales"

ess exec "aq_udb -exp wood:allsales -notitle | \
               aq_pp -f - -d s:userid X i:articleid f:total X -imp wood:usersales"

ess exec "aq_udb -exp wood:usersales -sort total -dec -top 10"

ess exec "aq_udb -clr wood:usersales"
ess exec "aq_udb -clr_all -db wood"




