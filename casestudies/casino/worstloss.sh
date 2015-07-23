ess drop database worstloss
ess create database worstloss --ports=1

ess create table grouping s,pkey:country s,+key:user s,+first:time i,+last:bet f,+min:winnings

ess udbd start

ess select local

ess category add casino "$HOME/*onlinecasino*" --dateformat none

ess summary

ess stream casino "*" "*" "aq_pp -f,+1,eok - -d s:user s:time i:bet f:winnings s:country -udb_imp worstloss:grouping" --debug

ess exec "aq_udb -db worstloss -ord grouping winnings" --debug
ess exec "aq_udb -db worstloss -exp grouping -o worstloss.csv" --debug

ess udbd stop
