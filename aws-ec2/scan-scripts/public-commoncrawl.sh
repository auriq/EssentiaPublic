ess instance local
ess datastore select s3://aws-publicdatasets/common-crawl/crawl-data/CC-MAIN-2013-20/ --credentials=../../asi-public.csv
ess datastore scan
ess datastore summary
ess datastore ls "*" | wc -l
ess datastore ls "*" | head -10
echo "broken pipe error message is expected since the ls command is still reading data when the head -10 finishes"
# can also run on CC-MAIN-2014-35 if using m3.medium
