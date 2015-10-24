ess stream browse '*' '*' "aq_pp -f,+1,eok - -d %cols -notitle" #Rinclude #R#browsedata#R#
ess stream purchase '*' '*' "aq_pp -f,+1,eok - -d %cols -notitle" #Rinclude #R#purchasedata#R#
ess query "select * from browse:*:*" #-notitle #Rinclude #R#querybrowse#R#
ess query "select * from purchase:*:*" #-notitle #Rinclude #R#querypurchase#R#