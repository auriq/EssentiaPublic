
#!/bin/bash
f () {
    command=`echo $BASH_COMMAND | cut -c1-60 | sed 's/$/ .../g'`
    echo "error on line ${BASH_LINENO[0]} : $command"
    exit 1
}
trap f ERR

# In this demo, we'll use the categorized data to perform several
# analysis tasks.  you can run this on the master node only but
# we encourage you to spin up 2 low cost worker nodes (t1.micros) to
# get a better sense of how Essentia works.

# For single node only, uncomment the following and comment out the
# multinode setup
ess instance local

# To spin up worker nodes, essentia looks for a file called ec2.conf in your
# current working directory.  This file is created by the Essentia UI
# and pushed to the ~/jobs directory.
# It also looks for your pem file, which was also pushed to the jobs directory.
# Copy both to your current working directory.
# To use multiple nodes, uncomment the following and comment out the
# singlenode setup
# ess instance ec2 create --number=2
## ess instance ec2 existing # run if you already created the worker instances

ess datastore select s3://asi-public/diy_woodworking --credentials=/home/ec2-user/jobs/asi-public.csv
ess datastore scan
ess datastore rule add "*purchase*gz" purchase "YYYYMMDD"
ess datastore probe purchase --apply
ess datastore category change purchase dateFormat "Y.m.d.H.M.S"
ess datastore category change purchase TZ GMT

# We can run a simple unix task on a set of files with the following:
ess task stream purchase 2014-09-01 2014-09-30 "wc -l"
# all the above does is stream files one by one to essentia and pipes it to
# the 'word count' unix command.
# This task is shared among workers, where files are split evenly between
# the number of worker nodes available


ess spec create database purchases
ess spec create table sales s,hash:userID i,tkey:t i:articleID f:price i:referrerID
ess spec create vector usertotals s,hash:userID f,+add:total
ess spec commit
ess udbd start

ess task stream purchase 2014-09-01 2014-09-30 "TZ=%tz aq_pp -notitle -f,eok - -d %cols -evlc i:source 1 -evlc i:one 1 -ddef -udb_imp udb_weekly:CJ"
ess task exec "aq_udb -exp udb_weekly:Profile > profile.csv; aq_udb -cnt udb_weekly:Profile; wc -l profile.csv" ## --master # this master flag is
# only needed if you are using a multi-node setup.

## run to output to an S3 bucket:  
# ess task exec "aq_udb -exp udb_weekly:Profile -local | gzip -3" --s3out=s3://*OutputBucket*/results/profile_%node_id_of_%num_nodes.csv
## Make sure to change the output bucket to whichever bucket you want the files to be stored in.
## You can only run this command successfully if you have an AWS account and access keys to the bucket you want to output data to. 
## For the necessary information to create an AWS account and obtain access keys, go to http://www.auriq.net/getting-started/ 

