ess udbd stop
ess server reset

ess create database logsapache1 --ports=1
# Create a vector to aggregate (count) the number of pages, hits, and bytes seen or used by day.
ess create vector vector1 s,pkey:day i,+add:pagecount i,+add:hitcount i,+add:pagebytes

ess create database logsapache2 --ports=1
# Create a vector to aggregate (count) the number of pages, hits, and bytes seen or used by hour.
ess create vector vector2 s,pkey:hour i,+add:pagecount i,+add:hitcount i,+add:pagebytes

ess create database logsapache3 --ports=1
# Create a vector to aggregate (count) the number of pages, hits, and bytes seen or used over each month of data.
ess create vector vector3 s,pkey:month i,+add:pagecount i,+add:hitcount i,+add:pagebytes

ess create database logsapache4 --ports=1
# Create a vector to aggregate (count) the number of pages, hits, and bytes seen or used by day of the week.
ess create vector vector4 s,pkey:dayoftheweek i,+add:pagecount i,+add:hitcount i,+add:pagebytes

ess udbd start

ess select local
# Create a category called 125accesslogs that matches any file with 125-access_log in its filename. 
# Tell essentia that these files have a date in their filenames and that this date has in sequence a 4 digit year, 2 digit month, and 2 digit day.
ess category add 125accesslogs "$HOME/*accesslog*125-access_log*"    

ess summary


# Stream your access logs from the startdate and enddate you specify into the following command. Use logcnv to specify the format of the records in the access log and convert them to .csv format. 
# Then pipe the data into our preprocessor (aq_pp) and specify which columns you want to keep. Filter on httpstatus so that you only include the 'good' http status codes that correspond to actual views. 
# Create a column that you can aggregate for each record to keep track of hits and another column to group the data by. Filter on accessedfile to eliminate any viewed files that dont have certain elements in their filename. 
# If this filter returns true, count that file as a page and save the file to a column called pageurl. If the filter returns false then the file is not counted as a page. 
# Convert the time column to a date and extract the month ("December"...), day ("01"...), dayoftheweek ("Sun"...), and hour ("00" to "23") into their respective columns. 
# Import the modified and reduced data into the four vectors in the databases you defined above so that the attributes defined there can be applied.    
        
ess stream 125accesslogs "2014-11-09" "2014-12-07" "logcnv -f,eok - -d ip:ip sep:' ' s:rlog sep:' ' s:rusr sep:' [' i,tim:time sep:'] \"' s,clf:req_line1 sep:' ' s,clf:req_line2 sep:' ' s,clf:req_line3 sep:'\" ' i:res_status sep:' ' i:res_size sep:' \"' s,clf:referrer sep:'\" \"' s,clf:user_agent sep:'\"' X \
| aq_pp -emod rt -f,eok - -d ip:ip X X i:time X s:accessedfile X i:httpstatus i:pagebytes X X -filt 'httpstatus == 200 || httpstatus == 304' -eval i:hitcount '1' \
-if -filt '(PatCmp(accessedfile, \"*.html[?,#]?*\", \"ncas\") || PatCmp(accessedfile, \"*.htm[?,#]?*\", \"ncas\") || PatCmp(accessedfile, \"*.php[?,#]?*\", \"ncas\") || PatCmp(accessedfile, \"*.asp[?,#]?*\", \"ncas\") || PatCmp(accessedfile, \"*/\", \"ncas\") || PatCmp(accessedfile, \"*.php\", \"ncas\"))' -eval i:pagecount '1' -eval s:pageurl 'accessedfile' \
-else -eval pagecount '0' -endif -eval s:month 'TimeToDate(time,\"%B\")' -eval s:day 'TimeToDate(time,\"%d\")' -eval s:dayoftheweek 'TimeToDate(time,\"%a\")' -eval s:hour 'TimeToDate(time,\"%H\")' \
-ddef -udb_imp logsapache1:vector1 -udb_imp logsapache2:vector2 -udb_imp logsapache3:vector3 -udb_imp logsapache4:vector4" --debug