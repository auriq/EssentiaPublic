ess instance local
ess spec drop database apache
ess spec create database apache --ports=1
ess spec create vector vector1 s,pkey:referrer i,+add:pagecount
ess udbd start
ess datastore select s3://asi-public --credentials=/home/ec2-user/jobs/asi-public.csv  ## CHANGE
ess datastore scan
ess datastore rule add "*125-access_log*" "125accesslogs" "YYYYMMDD"
ess datastore probe 125accesslogs --apply
ess datastore category change 125accesslogs compression none
ess datastore summary
ess task stream 125accesslogs "2014-11-30" "2014-12-07" "logcnv -f,eok - -d ip:ip sep:' ' s:rlog sep:' ' s:rusr sep:' [' i,tim:time sep:'] \"' s,clf,hl1:req_line1 sep:'\" ' i:res_status sep:' ' i:res_size \
sep:' \"' s,clf:referrer sep:'\" \"' s,clf:user_agent sep:'\"' X | aq_pp -f,qui,eok - -d X X X X X X X X X s:referrer X -evlc i:pagecount "1" -ddef -udb_imp apache:vector1" --debug
ess task exec "aq_udb -exp apache:vector1 -sort pagecount -dec -top 25; aq_udb -cnt apache:vector1" --debug
ess udbd stop
