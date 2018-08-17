#!/bin/bash

# Simple essentia script to process Apache web logs
#

ess cluster set local
ess purge local

ess server reset
ess create database apache --ports=1
ess create vector vector1 s,pkey:referrer i,+add:pagecount
ess udbd restart

ess select local
ess category add 125accesslogs "$HOME/EssentiaPublic/*accesslog*125-access_log*" 

ess stream 125accesslogs "2014-11-30" "2014-12-07" \
"aq_pp -f,qui,eok,div - -d X sep:' ' X sep:' ' X sep:' [' \
X sep:'] \"' X sep:' ' X sep:' ' X sep:'\" ' X sep:' ' \
X sep:' \"' s,clf:referrer \
sep:'\" \"' X sep:'\"' X \
-eval i:pagecount \"1\" -ddef -udb -imp apache:vector1"

ess exec "aq_udb -exp apache:vector1 -sort,dec pagecount -top 25; \
aq_udb -cnt apache:vector1"
