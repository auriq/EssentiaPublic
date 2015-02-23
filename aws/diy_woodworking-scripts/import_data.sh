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

# For master node only, uncomment the following and comment out the
# multinode setup
#ess instance local

# To spin up worker nodes, essentia looks for a file called ec2.conf in your
# current working directory.  This file is created by the Essentia UI
# and pushed to the ~/jobs directory.
# It also looks for your pem file, which was also pushed to the jobs directory.
# Copy both to your current working directory.
ess instance ec2 create --number=2
## ess instance ec2 existing # run if you already created the worker instances
ess udbd stop

ess datastore select s3://asi-public/diy_woodworking --credentials=../../asi-public.csv
ess datastore scan
ess datastore rule add "*purchase*gz" purchase "YYYYMMDD"
ess datastore probe purchase --apply
ess datastore category change purchase dateFormat "Y.m.d.H.M.S"
ess datastore category change purchase columnSpec "s:purchaseDate s:userID i:articleID f:price i:referrerID"
ess datastore category change purchase TZ GMT

# We can run a simple unix task on a set of files with the following:
ess task stream purchase 2014-09-01 2014-09-30 "wc -l"
# all the above does is stream files one by one to essentia and pipes it to
# the 'word count' unix command.
# This task is shared among workers, where files are split evenly between
# the number of worker nodes available

ess spec create database purchases
ess spec create table sales "s,hash:userID i:articleID f:price i:referrerID"
ess spec create vector usertotals "s,hash:userID i,+add:total"
ess spec commit
ess udbd start

ess task stream purchase 2014-09-01 2014-09-30 "TZ=%tz aq_pp -notitle -f,+1,eok - -d %cols -evlc i:total 1 -udb_imp purchases:sales -udb_imp purchases:usertotals"
ess task exec "aq_udb -exp purchases:sales -lim_rec 20; aq_udb -exp purchases:usertotals > profile.csv; aq_udb -cnt purchases:usertotals; wc -l profile.csv" --master

## run to output to an S3 bucket:  
# ess task exec "aq_udb -exp purchases:usertotals -local | gzip -3" --s3out=s3://*OutputBucket*/results/profile_%node_id_of_%num_nodes.csv
## Make sure to change the output bucket to whichever bucket you want the files to be stored in.

