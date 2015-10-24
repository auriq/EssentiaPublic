#!/bin/bash

# Simple essentia script to process Apache web logs
#

ess server reset
ess create database apache --ports=1
ess create vector vector1 s,pkey:referrer i,+add:pagecount
ess udbd restart

ess select local
ess category add 125accesslogs "$HOME/*accesslog*125-access_log*" 

ess stream 125accesslogs "2014-11-30" "2014-12-07" \
"logcnv -f,eok - -d ip:ip sep:' ' s:rlog sep:' ' s:rusr sep:' [' \
i,tim:time sep:'] \"' s,clf:req_line1 sep:' ' s,clf:req_line2 sep:' ' s,clf:req_line3 sep:'\" ' i:res_status sep:' ' \
i:res_size sep:' \"' s,clf:referrer \
sep:'\" \"' s,clf:user_agent sep:'\"' X | \
aq_pp -f,qui,eok - -d X X X X X X X X X s:referrer X \
-eval i:pagecount \"1\" -ddef -udb_imp apache:vector1"

ess exec "aq_udb -exp apache:vector1 -sort pagecount -dec -top 25; \
aq_udb -cnt apache:vector1"
