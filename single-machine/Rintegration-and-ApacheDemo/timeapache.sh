ess instance local
ess udbd stop

ess spec drop database logsapache2
ess spec create database logsapache2 --ports=1
ess spec create vector vector2 s,pkey:day i,+add:pagecount i,+add:hitcount i,+add:pagebytes

ess spec drop database logsapache3
ess spec create database logsapache3 --ports=1
ess spec create vector vector3 s,pkey:hour i,+add:pagecount i,+add:hitcount i,+add:pagebytes

ess spec drop database logsapache4
ess spec create database logsapache4 --ports=1
ess spec create vector vector4 s,pkey:monthsummary i,+add:pagecount i,+add:hitcount i,+add:pagebytes

ess spec drop database logsapache5
ess spec create database logsapache5 --ports=1
ess spec create vector vector5 s,pkey:dayoftheweek i,+add:pagecount i,+add:hitcount i,+add:pagebytes

ess udbd start

ess datastore select $HOME/samples/data
ess datastore scan
ess datastore rule add "*125-access_log*" "125accesslogs" "YYYYMMDD"
ess datastore probe 125accesslogs --apply
ess datastore category change 125accesslogs compression none
##ess datastore category change logs TZ 0700
#ess datastore push
ess datastore summary

ess task stream 125accesslogs "2014-12-07" "2014-12-07" "logcnv -f,eok - -d ip:ip sep:' ' s:rlog sep:' ' s:rusr sep:' [' i,tim:time sep:'] \"' s,clf,hl1:req_line1 sep:'\" ' i:res_status sep:' ' i:res_size sep:' \"' s,clf:referrer sep:'\" \"' s,clf:user_agent sep:'\"' X \
| aq_pp -emod rt -f,eok - -d ip:ip X X i:time X s:accessedfile X i:httpstatus i:pagebytes X X -filt 'httpstatus == 200 || httpstatus == 304' -evlc i:hitcount '1' -evlc s:ip2 'ToS(ip)' -evlc s:monthsummary 'ToS(1)' \
-if -filt 'accessedfile ~~~ \"*.html[?,#]?*\" || accessedfile ~~~ \"*.htm[?,#]?*\" || accessedfile ~~~ \"*.php[?,#]?*\" || accessedfile ~~~ \"*.asp[?,#]?*\" || accessedfile ~~~ \"*/\" || accessedfile ~~~ \"*.php\"' -evlc i:pagecount '1' -evlc s:pageurl 'accessedfile' \
-else -evlc pagecount '0' -endif -evlc s:day 'TimeToDate(time,\"%d\")' -evlc s:dayoftheweek 'TimeToDate(time,\"%a\")' -evlc s:hour 'TimeToDate(time,\"%H\")' \
-ddef -udb_imp logsapache2:vector2 -udb_imp logsapache3:vector3 -udb_imp logsapache4:vector4 -udb_imp logsapache5:vector5" --debug 

#ess task exec "aq_udb -exp rintapache:vector1 -o - | aq_pp -f,+1 - -d X X X i:pagecount i:hitcount i:pagebytes X -evlc s:monthsummary 'ToS(1)' -udb_imp logsapache4:vector4;" --debug #Rignore
#ess task exec "aq_udb -cnt rintapache:vector1; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp logsapache4:vector4; echo 'RSTOPHERE'" --debug 
#ess task exec "aq_udb -exp rintapache:vector1 -sort pagecount -dec | aq_pp -f,+1,eok - -d s:ip s:country s:region i:pagecount i:hitcount i:pagebytes s:time -evlc time 'TimeToDate(ToI(time),\"%d %b %Y - %X\")'; echo 'RSTOPHERE'" --debug 

ess task exec "aq_udb -exp logsapache2:vector2 -sort pagecount -dec; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp logsapache5:vector5 -sort pagecount -dec; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp logsapache3:vector3 -sort pagecount -dec; echo 'RSTOPHERE'" --debug 

ess udbd stop
