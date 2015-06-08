#!/bin/bash

# this script categorizes the data used in the Essentia 'woodworking'
# example.  Change the 'select' command to point to where you
# stored the data

ess datastore select local
# OR if you want to try reading from an S3 bucket:
# ess datastore select s3://asi-public --credentials=~/mycredentials.csv

# Setup the 'browse' category
ess datastore category add browse "$HOME/*tutorials/woodworking/diy_woodworking/*browse*"
ess datastore category change columnspec browse "S:eventDate S:userID I:articleID"

# Setup the 'purchase' category
ess datastore category add purchase "$HOME/*tutorials/woodworking/diy_woodworking/*purchase*"
ess datastore category change columnspec purchase "S:purchaseDate S:userID I:articleID f:price I:refID"
