ess instance local    # Tell essentia to work on your local machine.
ess udbd stop
ess spec reset

ess spec create database logsapache1 --ports=1
ess spec create vector vector1 s,pkey:day i,+add:pagecount i,+add:hitcount i,+add:pagebytes
# Create a vector to aggregate (count) the number of pages, hits, and bytes seen or used by day.

ess spec create database logsapache2 --ports=1
ess spec create vector vector2 s,pkey:hour i,+add:pagecount i,+add:hitcount i,+add:pagebytes
# Create a vector to aggregate (count) the number of pages, hits, and bytes seen or used by hour.

ess spec create database logsapache3 --ports=1
ess spec create vector vector3 s,pkey:month i,+add:pagecount i,+add:hitcount i,+add:pagebytes
# Create a vector to aggregate (count) the number of pages, hits, and bytes seen or used over the entire month of data.

ess spec create database logsapache4 --ports=1
ess spec create vector vector4 s,pkey:dayoftheweek i,+add:pagecount i,+add:hitcount i,+add:pagebytes
# Create a vector to aggregate (count) the number of pages, hits, and bytes seen or used by day of the week.

ess udbd start

ess datastore select ./accesslogs
ess datastore scan
ess datastore rule add "*125-access_log*" "125accesslogs" "YYYYMMDD"
# Create a category called 125accesslogs that matches any file with 125-access_log in its filename. Tell essentia that these files have a date in their filenames and that this date has in sequence a 4 digit year, 2 digit month, and 2 digit day.

ess datastore probe 125accesslogs --apply
ess datastore category change 125accesslogs compression none     # Tell essentia that the accesslogs are not compressed
ess datastore summary



ess task stream 125accesslogs "2014-11-09" "2014-12-07" "logcnv -f,eok - -d ip:ip sep:' ' s:rlog sep:' ' s:rusr sep:' [' i,tim:time sep:'] \"' s,clf,hl1:req_line1 sep:'\" ' i:res_status sep:' ' i:res_size sep:' \"' s,clf:referrer sep:'\" \"' s,clf:user_agent sep:'\"' X \
| aq_pp -emod rt -f,eok - -d ip:ip X X i:time X s:accessedfile X i:httpstatus i:pagebytes X X -filt 'httpstatus == 200 || httpstatus == 304' -evlc i:hitcount '1' \
-if -filt 'accessedfile ~~~ \"*.html[?,#]?*\" || accessedfile ~~~ \"*.htm[?,#]?*\" || accessedfile ~~~ \"*.php[?,#]?*\" || accessedfile ~~~ \"*.asp[?,#]?*\" || accessedfile ~~~ \"*/\" || accessedfile ~~~ \"*.php\"' -evlc i:pagecount '1' -evlc s:pageurl 'accessedfile' \
-else -evlc pagecount '0' -endif -evlc s:month 'TimeToDate(time,\"%B\")' -evlc s:day 'TimeToDate(time,\"%d\")' -evlc s:dayoftheweek 'TimeToDate(time,\"%a\")' -evlc s:hour 'TimeToDate(time,\"%H\")' \
-ddef -udb_imp logsapache1:vector1 -udb_imp logsapache2:vector2 -udb_imp logsapache3:vector3 -udb_imp logsapache4:vector4" --debug 

# Stream your access logs from the startdate and enddate you specify into the following command. Use logcnv to specify the format of the records in the access log and convert them to .csv format. Then pipe the data into our preprocessor (aq_pp) and specify which 
# columns you want to keep. Filter on httpstatus so that you only include the 'good' http status codes that correspond to actual views. Create a column that you can aggregate for each record to keep track of hits and another column to group the data by. Filter on 
# accessedfile to eliminate any viewed files that dont have certain elements in their filename. If this filter returns true, count that file as a page and save the file to a column called pageurl. If the filter returns false then the file is not counted as 
# a page. Convert the time column to a date and extract the month ("December"...), day ("01"...), dayoftheweek ("Sun"...), and hour ("00" to "23") into their respective columns. Import the modified and reduced data into the four vectors in the databases you defined above so that the 
# attributes defined there can be applied.
