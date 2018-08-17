ess cluster set local
ess purge local

ess udbd stop
ess server reset

ess create database logsapache1 --ports=1
ess create vector vector1 s,pkey:timeseg i,+add:pagecount i,+add:hitcount i,+add:pagebytes
# Create a vector to aggregate (count) the number of pages, hits, and bytes seen or used by the user-specified time segment.

ess udbd start

ess select local

currentdir=`pwd`
echo "My current directory: " $currentdir
ess category add 125accesslogs "$currentdir/../../casestudies/apache/*accesslog*125-access_log*"

ess summary

ess stream 125accesslogs $1 ${2} "aq_pp $oldmod -f,qui,eok,div - -d ip:ip sep:' ' X sep:' ' X sep:' [' \
s:time_s sep:'] \"' X sep:' ' s,clf:accessedfile sep:' ' X sep:'\" ' i:httpstatus sep:' ' i:pagebytes sep:' \"' X \
sep:'\" \"' X sep:'\"' X -eval i:time 'DateToTime(time_s, \"d.b.Y.H.M.S.z\")' -filt '$5' -eval i:hitcount '1' \
-if -filt '(PatCmp(accessedfile, \"$4\", \"ncas\") || PatCmp(accessedfile, \"*.htm[?,#]?*\", \"ncas\") || PatCmp(accessedfile, \"*.php[?,#]?*\", \"ncas\") || PatCmp(accessedfile, \"*.asp[?,#]?*\", \"ncas\") || PatCmp(accessedfile, \"*/\", \"ncas\") || PatCmp(accessedfile, \"*.php\", \"ncas\"))' -eval i:pagecount '1' -eval s:pageurl 'accessedfile' \
-else -eval pagecount '0' -endif -eval s:timeseg 'TimeToDate(time,\"${3}\")' -ddef -udb -imp logsapache1:vector1" --debug

# Stream your access logs from the startdate and enddate you specify into the following command. Use logcnv to specify the format of the records in the access log and convert them to .csv format.
# Then pipe the data into our preprocessor (aq_pp) and specify which columns you want to keep. Filter on httpstatus so that you only include the 'good' http status codes that correspond to actual views.
# Create a column that you can aggregate for each record to keep track of hits and another column to group the data by. Filter on accessedfile to eliminate any viewed files that dont have certain elements in their filename.
# If this filter returns true, count that file as a page and save the file to a column called pageurl. If the filter returns false then the file is not counted as a page.
# Convert the time column to a date and extract the desired time segment. Import the modified and reduced data into the vector in the database you defined above so that the attributes defined there can be applied.
