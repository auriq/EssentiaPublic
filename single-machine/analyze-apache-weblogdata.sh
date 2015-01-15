# This script pipes the apache log data through a log converter to get the logs into a csv format, into the Essentia preprocessor, and then into the udbd database.
# The preprocessor allows more efficient loading of data by ignoring the irrelevant columns in the web logs and creates a column to keep track of the number of records.
# Attributes are applied in the database and the number of records corresponding to each unique referrer is counted.
# Then the 25 referrers that corresponded to the most records in the web log data are output and the total number of unique referrers is displayed.

ess instance local

ess spec drop database apache
ess spec create database apache --ports=1
ess spec create vector vector1 s,pkey:referrer i,+add:pagecount
# Stores a vector in the database apache that aggregates the values in the pagecount column for each unique referrer. The pagecount column only contains the number ‘1’ so this serves to count the number of times any one referrer was seen in the web logs.

ess udbd start

ess datastore select $HOME/jobs/data  ## CHANGE to $HOME/samples/data
ess datastore scan
ess datastore rule add "*125-access_log*" "125accesslogs" "YYYYMMDD"
# Creates a new rule to take any files with ‘/2014’ followed by another ‘/2014' in their name and puts them in the 2014logs category.
ess datastore probe 125accesslogs --apply
ess datastore category change 125accesslogs compression none
ess datastore summary

ess task stream 125accesslogs "2014-11-30" "2014-12-07" "logcnv -f,eok - -d ip:ip sep:' ' s:rlog sep:' ' s:rusr sep:' [' i,tim:time sep:'] \"' s,clf,hl1:req_line1 sep:'\" ' i:res_status sep:' ' i:res_size \
sep:' \"' s,clf:referrer sep:'\" \"' s,clf:user_agent sep:'\"' X | aq_pp -f,qui,eok - -d X X X X X X X X X s:referrer X -evlc i:pagecount "1" -ddef -udb_imp apache:vector1" --debug
# Pipes the files in the category 2014logs that were created between April 1st and 5th, 2014 to the aq_pp command. In the aq_pp command, tells the preprocessor to take data from stdin, ignoring errors and not outputting any error messages. 
# Then defines the incoming data’s columns, skipping all of the columns except referrer, and creates a column called pagecount that always contains the value 1. Then imports the data to the vector in the apache database so the attributes listed there can be applied.

ess task exec "aq_udb -exp apache:vector1 -sort pagecount -dec -top 25; aq_udb -cnt apache:vector1" --debug
# Exports the aggregated data from the database, sorting by pagecount and limiting to the 25 most common referrers. Also exports the total number of unique referrers.

ess udbd stop
