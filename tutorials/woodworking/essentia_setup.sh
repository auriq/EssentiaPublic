ess cluster set local
ess purge local

ess select local

currentdir=`pwd`
ess category add browse "$currentdir/diy_woodworking/*browse*gz"
#ess category change columnspec browse "S:eventDate S:userID I:articleID" 

ess category add purchase "$currentdir/diy_woodworking/*purchase*gz"
#ess category change columnspec purchase "S:purchaseDate S:userID I:articleID f:price I:refID"
