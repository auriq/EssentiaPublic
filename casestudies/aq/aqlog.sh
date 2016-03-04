ess udbd stop
ess server reset

ess create database aqlogday --ports=1
ess create vector aqlogday s,pkey:day i,+add:pagecount i,+add:hitcount 
# Create a vector to aggregate (count) the number of pages and hits seen or used by day.

ess create database aqloghour --ports=1
ess create vector aqloghour s,pkey:hour i,+add:pagecount i,+add:hitcount 
# Create a vector to aggregate (count) the number of pages and hits seen or used by hour.

ess create database aqlogmonth --ports=1
ess create vector aqlogmonth s,pkey:month i,+add:pagecount i,+add:hitcount 
# Create a vector to aggregate (count) the number of pages and hits seen or used over each month of data.

ess create database aqlogdayoftheweek --ports=1
ess create vector aqlogdayoftheweek s,pkey:dayoftheweek i,+add:pagecount i,+add:hitcount 
# Create a vector to aggregate (count) the number of pages and hits seen or used by day of the week.

ess udbd start

ess select local

ess category add aqlogs "$HOME/*/casestudies/aq/aqlogs/*.gz" --dateregex ".*-d-[:%Y:][:%m:][:%d:]-.*" 

ess summary

# Check Essentia Version Number for Compatibility
EssVersion=`ess -v 2>&1 | aq_pp -f,eok,sep=':' - -d X s,trm:EssentiaVersion -filt '\$RowNum==1' \
-filt 'EssentiaVersion!="3.0.9.12"' -notitle 2>/dev/null`
if [ -z "$EssVersion" ]
then
        oldmod="-emod rt "
else
        oldmod=""
fi

ess stream aqlogs "2014-06-13" "2014-08-15" "aq_pp $oldmod -f,+1,eok - -d %cols -filt 'status == 200 || status == 304' -eval i:hitcount '1' \
-if -filt '(PatCmp(page, \"*.html[?,#]?*\", \"ncas\") || PatCmp(page, \"*.htm[?,#]?*\", \"ncas\") || PatCmp(page, \"*.php[?,#]?*\", \"ncas\") || PatCmp(page, \"*.asp[?,#]?*\", \"ncas\") || PatCmp(page, \"*/\", \"ncas\") || PatCmp(page, \"*.php\", \"ncas\"))' -eval i:pagecount '1' -eval s:pageurl 'page' \
-else -eval pagecount '0' -endif -eval s:month 'TimeToDate(t,\"%B\")' -eval s:day 'TimeToDate(t,\"%d\")' -eval s:dayoftheweek 'TimeToDate(t,\"%a\")' -eval s:hour 'TimeToDate(t,\"%H\")' \
-ddef -udb -imp aqlogday:aqlogday -imp aqloghour:aqloghour -imp aqlogmonth:aqlogmonth -imp aqlogdayoftheweek:aqlogdayoftheweek" --debug

# Stream your aq logs from the startdate and enddate you specify into the following command. 
# Then pipe the data into our preprocessor (aq_pp) and tell Essentia to use the column specification it determined. Filter on status so that you only include the 'good' http status codes that correspond to actual views.
# Create a column that you can aggregate for each record to keep track of hits and another column to group the data by. Filter on page to eliminate any viewed files that dont have certain elements in their filename.
# If this filter returns true, count that file as a page and save the file to a column called pageurl. If the filter returns false then the file is not counted as a page.
# Convert the t column to a date and extract the month ("December"...), day ("01"...), dayoftheweek ("Sun"...), and hour ("00" to "23") into their respective columns.
# Import the modified and reduced data into the four vectors in the databases you defined above so that the attributes defined there can be applied.

