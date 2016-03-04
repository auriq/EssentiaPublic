ess udbd stop
ess server reset

ess drop database totalwinnings
ess create database totalwinnings

ess create vector myvector s,pkey:user i,+max:bet f,+add:winnings

ess udbd start

ess select local

ess category add casino "$HOME/*onlinecasino*" --dateregex none

ess summary

ess stream casino "*" "*" "aq_pp -f,+1,eok - -d s:user X i:bet f:winnings X -udb_imp totalwinnings:myvector" --debug

ess exec "aq_udb -exp totalwinnings:myvector -o totalwinnings.csv" --debug
