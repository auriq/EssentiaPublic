#!/bin/bash

# this script categorizes the data used in the Essentia 'woodworking'
# example.  Change the 'select' command to point to where you
# stored the data

ess instance local
ess datastore select ./diy_woodworking
# OR if you want to try reading from an S3 bucket:
# ess datastore select s3://asi-public/diy_woodworking --credentials=~/mycredentials.csv

# scan the bucket to get the list of file names.
ess datastore scan

# Setup the 'browse' category
ess datastore rule add "*browse*" browse YYYYMMDD
ess datastore probe browse --apply
ess datastore category change browse columnSpec "S:eventDate S:userID I:articleID"
ess datastore category change browse dateFormat "Y.m.d.H.M.S"
ess datastore category change browse TZ "GMT"

# Setup the 'purchase' category
ess datastore rule add "*purchase*" purchase YYYYMMDD
ess datastore probe purchase --apply
ess datastore category change purchase columnSpec "S:purchaseDate S:userID I:articleID f:price I:refID"
ess datastore category change purchase dateFormat "Y.m.d.H.M.S"
ess datastore category change purchase TZ "GMT"
