ess instance local
ess spec drop database fivecoltutorial
ess spec create database fivecoltutorial --ports=1 
ess spec create vector vector1 s,pkey:country s,+last:first_name s,+first:last_name i,+add:integer_col f,+min:float_col
ess udbd start
ess datastore select s3://asi-public --credentials=/home/ec2-user/jobs/asi-public.csv
ess datastore scan
ess datastore rule add "*fivecoltutorial*" "tutorialdata" "YYMMDD"
ess datastore probe tutorialdata --apply
ess datastore summary
ess task stream tutorialdata "*" "*" "aq_pp -f,+1,eok - -d f:float_col i:integer_col s:last_name s:first_name s:country -ddef -udb_imp fivecoltutorial:vector1" --debug 
ess task exec "aq_udb -exp fivecoltutorial:vector1 -o /home/ec2-user/jobs/countrytutorialresults.csv" --debug 
ess udbd stop
