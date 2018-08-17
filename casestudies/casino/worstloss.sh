ess cluster set local

ess udbd stop
ess server reset

ess drop database worstloss
ess create database worstloss

ess create table grouping s,pkey:country s,+key:user s,+first:time i,+last:bet f,+min:winnings

ess udbd start

ess select local

ess category add casino "$HOME/EssentiaPublic/*onlinecasino*" --dateregex none

ess summary

ess stream casino "*" "*" "aq_pp -f,+1,eok - -d s:user s:time i:bet f:winnings s:country -udb -imp worstloss:grouping" --debug

ess exec "aq_udb -ord worstloss:grouping winnings" --debug
ess exec "aq_udb -exp worstloss:grouping -o worstloss.csv" --debug
