# bash loadrintapache.sh
# Run to load the data into the udbd database.

ess task exec "aq_udb -exp rintapache:vector1 -o - | aq_pp -f,+1 - -d X X X i:pagecount i:hitcount i:pagebytes X -evlc s:monthsummary 'ToS(1)' -udb_imp logsapache4:vector4;" --debug #Rignore
ess task exec "aq_udb -cnt rintapache:vector1; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp logsapache4:vector4; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp rintapache:vector1 -sort pagecount -dec | aq_pp -f,+1,eok - -d s:ip s:country s:region i:pagecount i:hitcount i:pagebytes s:time -evlc time 'TimeToDate(ToI(time),\"%d %b %Y - %X\")'; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp logsapache2:vector2 -sort pagecount -dec; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp logsapache5:vector5 -sort pagecount -dec; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp logsapache3:vector3 -sort pagecount -dec; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp logsapache8:vector8 -sort pagecount -dec; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp logsapache9:vector9 -sort pagecount -dec; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp logsapache11:vector11 -sort pagecount -dec; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp logsapache12:vector12 -sort pagecount -dec; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp logsapache13:vector13 -sort pagecount -dec; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp logsapache14:vector14 -pp vector14 -pp_evlc pagebytes \ 'ToF(pagebytes)/ToF(pagecount)' -sort pagecount -dec; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp logsapache6:vector6; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp logsapache6:vector6 -o - | aq_pp -f,+1 - -d X i:visitcount -evlc s:monthsummary 'ToS(1)' -udb_imp logsapache7:vector7;" --debug #Rignore
ess task exec "aq_udb -exp logsapache7:vector7; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp logsapache10:vector10; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp logsapache15:vector15 -sort pagecount -dec; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp logsapache15:vector15 -o - | aq_pp -f,+1 - -d X i:pagecount i:hitcount i:pagebytes -evlc s:monthsummary 'ToS(1)' -udb_imp logsapache16:vector16;" --debug #Rignore
ess task exec "aq_udb -exp logsapache16:vector16; echo 'RSTOPHERE'" --debug 
# echo 'RSTOPHERE'

# ess udbd stop
# Run to stop the udbd database when you no longer need it to store the data.
