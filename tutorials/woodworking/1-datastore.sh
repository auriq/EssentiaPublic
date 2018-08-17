#!/bin/bash

# this script categorizes the data used in the Essentia 'woodworking'
# example.  Change the 'category add' command to point to where you
# stored the data

ess cluster set local
ess purge local

ess select local

currentdir=`pwd`

# Setup the 'browse' category
ess category add browse "$currentdir/diy_woodworking/*browse_*"
ess category change columnspec browse "S:eventDate S:userID I:articleID"

# Setup the 'purchase' category
ess category add purchase "$currentdir/diy_woodworking/*purchase_*"
ess category change columnspec purchase "S:purchaseDate S:userID I:articleID f:price I:refID"
