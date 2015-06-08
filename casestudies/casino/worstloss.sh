ess spec drop database worstloss
ess spec create database worstloss --ports=1

ess spec create table grouping s,pkey:country s,+key:user s,+first:time i,+last:bet f,+min:winnings

ess udbd start

ess datastore select local

ess datastore category add casino "$HOME/*onlinecasino*" --dateformat none

ess datastore summary

ess task stream casino "*" "*" "aq_pp -f,+1,eok - -d s:user s:time i:bet f:winnings s:country -udb_imp worstloss:grouping" --debug

ess task exec "aq_udb -db worstloss -ord grouping winnings" --debug
ess task exec "aq_udb -db worstloss -exp grouping -o worstloss.csv" --debug

ess udbd stop
