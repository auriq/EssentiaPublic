#!/bin/bash

# this script categorizes the data used in the Essentia 'woodworking'
# example.  Change the 'category add' command to point to where you
# stored the data

ess select local

# Setup the 'browse' category
ess category add browse "$HOME/*tutorials/woodworking/diy_woodworking/*browse*"
ess category change columnspec browse "S:eventDate S:userID I:articleID"

# Setup the 'purchase' category
ess category add purchase "$HOME/*tutorials/woodworking/diy_woodworking/*purchase*"
ess category change columnspec purchase "S:purchaseDate S:userID I:articleID f:price I:refID"
