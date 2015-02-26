#!/bin/bash

ess instance local
for i in {1..7}; do funzip ./diy_woodworking/browse_2014090${i}.gz | wc -l ; done
ess task stream browse 2014-09-01 2014-09-07 'wc -l'


mkdir bz2
ess task stream browse 2014-09-01 2014-09-30 "aq_pp -f,+1,eok - -d %cols -notitle | bzip2 - -c > ./bz2/%file.bz2"

ess task stream purchase 2014-09-01 2014-09-30 \
    "aq_pp -f,+1,eok,qui - -d %cols \
    -evlc is:t 'DateToTime(%date_col,\"%date_fmt\") - DateToTime(\"2014-09-15\",\"Y.m.d\")' \
    -if -filt 't>0' \
      -evlc articleID 'articleID+1' \
    -endif \
    -c purchaseDate userID articleID price refID \
    -notitle \
    | bzip2 - -c > ./bz2/%file.bz2"


