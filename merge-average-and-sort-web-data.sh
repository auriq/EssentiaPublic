ess instance local
ess udbd stop
 
ess spec create database amp1nodeess2 --ports=1 
ess spec create vector vector1 s,pkey:sourceIP f,+add:avgpageRank f,+add:adRevenue f,+add:row
 
ess udbd start
 
ess datastore select s3://big-data-benchmark --credentials=/home/ec2-user/jobs/asi-public.csv
#ess datastore purge
ess datastore scan
ess datastore rule add "*pavlo/text/1node/uservisits/part*" uservisits "YYYYMMDD-"
ess datastore rule add "*pavlo/text/1node/rankings/part*" rankings "YYYYMMDD-"
ess datastore category change uservisits compression none
ess datastore category change rankings compression none
ess datastore summary
 
ess task stream rankings "*" "*" "aq_pp -f,eok - -d s:pageURL s:pageRank X -o,app /home/ec2-user/jobs/lookuppagerank.csv" --debug --thread=10

ess task stream uservisits "*" "*" "aq_pp -f,eok - -d s:sourceIP s:destURL s:visitDate f:adRevenue X X X X X -evlc i:dt 'DateToTime(visitDate,\"Y.m.d\")' -filt '((dt >= 315532860) && (dt <= 788918460))' - \
sub,req destURL /home/ec2-user/jobs/lookuppagerank.csv -evlc f:avgpageRank 'ToF(destURL)' -evlc f:row '1' -udb_imp amp1nodeess2:vector1" --debug --thread=2

ess task exec "aq_udb -exp amp1nodeess2:vector1 -pp vector1 -pp_evlc avgpageRank 'avgpageRank / (row)' -c sourceIP avgpageRank adRevenue -o - | rw_csv -f+1 - -d s:sourceIP f:avgpageRank f:adRevenue -sort adRevenue > sortedtable.csv" --debug
 
ess udbd stop
