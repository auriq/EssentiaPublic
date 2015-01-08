ess instance local
ess datastore select s3://datasets.elasticmapreduce/ngrams/books/ --credentials=/home/ec2-user/jobs/asi-public.csv
ess datastore scan
ess datastore summary
ess datastore ls "*" | wc -l                     
ess datastore ls "*" | head -10
echo "broken pipe error message is expected since the ls command is still reading data when the head -10 finishes"
