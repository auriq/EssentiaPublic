ess instance local
ess udbd stop
ess spec drop database rintapache
ess spec create database rintapache --ports=1
ess spec create vector vector1 s,pkey:ip2 s,+last:country s,+last:region i,+add:pagecount i,+add:hitcount i,+add:pagebytes i,+last:time
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
ess spec drop database logsapache6
ess spec create database logsapache6 --ports=1
ess spec create vector vector6 s,pkey:day i,+add:visitcount
ess spec drop database logsapache7
ess spec create database logsapache7 --ports=1
ess spec create vector vector7 s,pkey:monthsummary i,+add:visitcount
ess spec drop database logsapache8
ess spec create database logsapache8 --ports=1
ess spec create vector vector8 s,pkey:country i,+add:pagecount i,+add:hitcount i,+add:pagebytes
ess spec drop database logsapache9
ess spec create database logsapache9 --ports=1
ess spec create vector vector9 s,pkey:rusr i,+add:pagecount i,+add:hitcount i,+add:pagebytes
ess spec drop database logsapache10
ess spec create database logsapache10 --ports=1
ess spec create vector vector10 s,pkey:visitduration i,+add:visitcount
ess spec drop database logsapache11
ess spec create database logsapache11 --ports=1
ess spec create vector vector11 s,pkey:os i,+add:pagecount i,+add:hitcount
ess spec drop database logsapache12
ess spec create database logsapache12 --ports=1
ess spec create vector vector12 s,pkey:browser i,+add:pagecount i,+add:hitcount
ess spec drop database logsapache13
ess spec create database logsapache13 --ports=1
ess spec create vector vector13 s,pkey:searchkey i,+add:pagecount i,+add:hitcount
ess spec drop database logsapache14
ess spec create database logsapache14 --ports=1
ess spec create vector vector14 s,pkey:pageurl i,+add:pagecount i,+add:pagebytes
ess spec drop database logsapache15
ess spec create database logsapache15 --ports=1
ess spec create vector vector15 s,pkey:badstatus i,+add:pagecount i,+add:hitcount i,+add:pagebytes
ess spec drop database logsapache16
ess spec create database logsapache16 --ports=1
ess spec create vector vector16 s,pkey:monthsummary i,+add:pagecount i,+add:hitcount i,+add:pagebytes
ess udbd start
ess datastore select s3://asi-public --credentials=/home/ec2-user/jobs/asi-public.csv
ess datastore scan
ess datastore rule add "*125-access_log*" "125accesslogs" "YYYYMMDD"
ess datastore probe 125accesslogs --apply
ess datastore category change 125accesslogs compression none
##ess datastore category change logs TZ 0700
#ess datastore push
ess datastore summary
ess task stream 125accesslogs "2014-11-16" "2014-12-07" "logcnv -f,eok - -d ip:ip sep:' ' s:rlog sep:' ' s:rusr sep:' [' i,tim:time sep:'] \"' s,clf,hl1:req_line1 sep:'\" ' i:res_status sep:' ' i:res_size sep:' \"' s,clf:referrer sep:'\" \"' s,clf:user_agent sep:'\"' X | aq_pp -emod rt -f,eok - -d ip:ip X s:rusr i:time X s:accessedfile s:protocol i:httpstatus i:pagebytes s:referrer s:user_agent -filt 'httpstatus == 200 || httpstatus == 304' -evlc i:hitcount '1' -evlc s:ip2 'ToS(ip)' -if -filt 'accessedfile ~~~ \"*.html[?,#]?*\" || accessedfile ~~~ \"*.htm[?,#]?*\" || accessedfile ~~~ \"*.php[?,#]?*\" || accessedfile ~~~ \"*.asp[?,#]?*\" || accessedfile ~~~ \"*/\" || accessedfile ~~~ \"*.php\"' -evlc i:pagecount '1' -evlc s:pageurl 'accessedfile' -else -evlc pagecount '0' -endif -evlc s:day 'TimeToDate(time,\"%d\")' -evlc s:dayoftheweek 'TimeToDate(time,\"%a\")' -evlc s:hour 'TimeToDate(time,\"%H\")' -evlc s:country 'IpToCountry(ip)' -mapf country '%%m_1,:%%%%m_2%%' -mapc country '%%m_1%%' -mapc s:region '%%m_2%%' -mapf region ':%%m_3%%' -mapc region '%%m_3%%' -evlc s:browser 'AgentParse2(user_agent, ip)' -mapf browser '%%m_4,:%%%%m_5%%' -mapc browser '%%m_4%%' -mapc s:os '%%m_5%%' -mapf os ':%%m_6%%' -mapc os '%%m_6%%' -map referrer '%*//%%URL%%' '%%URL%%' -evlc s:searchkey 'SearchKey(referrer)' -ddef -udb_imp rintapache:vector1 -udb_imp logsapache2:vector2 -udb_imp logsapache3:vector3 -udb_imp logsapache5:vector5 -udb_imp logsapache8:vector8 -udb_imp logsapache9:vector9 -udb_imp logsapache11:vector11 -udb_imp logsapache12:vector12 -udb_imp logsapache13:vector13 -udb_imp logsapache14:vector14" --debug 
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
ess task stream 125accesslogs "2014-11-16" "2014-12-07" "logcnv -f,eok - -d ip:ip sep:' ' s:rlog sep:' ' s:rusr sep:' [' i,tim:time sep:'] \"' s,clf,hl1:req_line1 sep:'\" ' i:res_status sep:' ' i:res_size sep:' \"' s,clf:referrer sep:'\" \"' s,clf:user_agent sep:'\"' X | aq_pp -f,eok - -d ip:ip X s:rusr i:time X s:accessedfile s:protocol i:httpstatus i:pagebytes s:referrer s:user_agent -filt 'httpstatus == 200 || httpstatus == 304' -notitle -o aqsessoutput3.csv -o - | aq_ord -sort i:3 -o aqsessoutput2.csv -o - | aq_sess -f,eok - -d s:ip s:rusr i:time s:accessedfile s:protocol i:httpstatus i:pagebytes s:referrer s:user_agent -t time -k ip -tout 3600 -o - | aq_pp -f,eok - -d s:ip i:tbeg i:tend i:dt i:pv -evlc s:day 'TimeToDate(tbeg,\"%d\")' -evlc i:visitcount '1' -if -filt 'dt < 30' -evlc s:visitduration '\"0 - 30s\"' -elif  -filt 'dt >= 30 && dt < 120' -evlc visitduration '\"30s - 2min\"' -elif -filt 'dt >= 120 && dt < 300' -evlc visitduration '\"2min - 5min\"' -elif -filt 'dt >= 300 && dt < 900' -evlc visitduration '\"5min - 15min\"' -elif -filt 'dt >= 900 && dt < 1800' -evlc visitduration '\"15min - 30min\"' -elif -filt 'dt >= 1800 && dt < 3600' -evlc visitduration '\"30min - 1hr\"' -elif -filt 'dt >= 3600' -evlc visitduration '\"1hr+\"' -endif -ddef -udb_imp logsapache6:vector6 -udb_imp logsapache10:vector10" --debug # --bulk # try on actual apache logs
ess task exec "aq_udb -exp logsapache6:vector6; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp logsapache6:vector6 -o - | aq_pp -f,+1 - -d X i:visitcount -evlc s:monthsummary 'ToS(1)' -udb_imp logsapache7:vector7;" --debug #Rignore
ess task exec "aq_udb -exp logsapache7:vector7; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp logsapache10:vector10; echo 'RSTOPHERE'" --debug 
ess task stream 125accesslogs "2014-11-16" "2014-12-07" "logcnv -f,eok - -d ip:ip sep:' ' s:rlog sep:' ' s:rusr sep:' [' i,tim:time sep:'] \"' s,clf,hl1:req_line1 sep:'\" ' i:res_status sep:' ' i:res_size sep:' \"' s,clf:referrer sep:'\" \"' s,clf:user_agent sep:'\"' X | aq_pp -emod rt -f,eok - -d ip:ip X s:rusr i:time X s:accessedfile s:protocol i:httpstatus i:pagebytes s:referrer s:user_agent -filt 'httpstatus != 200 && httpstatus != 304' -evlc i:hitcount '1' -evlc s:badstatus 'ToS(httpstatus)' -if -filt 'accessedfile ~~~ \"*.html[?,#]?*\" || accessedfile ~~~ \"*.htm[?,#]?*\" || accessedfile ~~~ \"*.php[?,#]?*\" || accessedfile ~~~ \"*.asp[?,#]?*\" || accessedfile ~~~ \"*/\" || accessedfile ~~~ \"*.php\"' -evlc i:pagecount '1' -else -evlc pagecount '0' -endif -ddef -udb_imp logsapache15:vector15" --debug 
ess task exec "aq_udb -exp logsapache15:vector15 -sort pagecount -dec; echo 'RSTOPHERE'" --debug 
ess task exec "aq_udb -exp logsapache15:vector15 -o - | aq_pp -f,+1 - -d X i:pagecount i:hitcount i:pagebytes -evlc s:monthsummary 'ToS(1)' -udb_imp logsapache16:vector16;" --debug #Rignore
ess task exec "aq_udb -exp logsapache16:vector16; echo 'RSTOPHERE'" --debug 
#ess task stream 125accesslogs "2014-12-07" "2014-12-07" "head -32" --debug
# echo 'RSTOPHERE'
ess udbd stop
