ess udbd stop

ess spec drop database totalwinnings
ess spec create database totalwinnings --ports=1

ess spec create vector myvector s,pkey:user i,+max:bet f,+add:winnings

ess udbd start

ess datastore select local

ess datastore category add casino "$HOME/*onlinecasino*" --dateformat none

ess datastore summary

ess task stream casino "*" "*" "aq_pp -f,+1,eok - -d s:user X i:bet f:winnings X -udb_imp totalwinnings:myvector" --debug

ess task exec "aq_udb -exp totalwinnings:myvector -o totalwinnings.csv" --debug
