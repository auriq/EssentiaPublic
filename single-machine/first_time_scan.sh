#!/bin/bash
f () {
    command=`echo $BASH_COMMAND | cut -c1-60 | sed 's/$/ .../g'`
    echo "error on line ${BASH_LINENO[0]} : $command"
    exit 1
}
trap f ERR


# This is a test script that demonstrates how to scan and organize a directory containing log data.
# In this demo, we provide logs from a fictional DIY woodworking website.
# The website contains instructions for building a variety of items, and each article (web page) can refer
# to other plans on the site.  Full PDF documents with additional information are available for purchase for each article.
#
# One set of logs tracks purchases of woodworking plans, and the other tracks users browse history
# in the web site.

# For both logs, there is 1 file per day, and the file name contains the date from which the logs were collected.
# The browse logs have the following three columns:
# eventDate,userID,articleID
#
# userIDs and articleIDs are unique and correspond to people and webpages respectively.
#
# The purchase logs contain:
# purchaseDate,userID,articleID,price,referrerID
#
# Our fictional servers predict how much a user is willing to pay for an article, so the same article
# might have different prices depending.  The referrerID is the last article the user read before purchasing
# the plans in the current article.

# setup local instance and select our sample data directory
ess instance local
ess datastore select s3://asi-public/diy_woodworking --credentials=/home/ec2-user/jobs/asi-public.csv

# get a list of the files and generate the index.
# It will spit out a message indicating that no index file was found in the directory.  This is normal
# for first time use.  After you build your ruleset, you can push the index to the directory for
# use in future analysis runs
ess datastore scan  

# you note that it applied 2 rules.  These are the 'system' rules.  The first is 'default', which matches any file
# the second is 'ignore', which is used for files you don't wish to track.

# take a look at all the files
ess datastore ls
# the output lists the name of the file, its size in kb, and the 'lastmodified' time.

# There are 2 types of log files here. One tracks purchases and the other browsing history.
# We can use the ls command and unix globbing to list files from one of the categories
ess datastore ls "*browse*"


# Now we wish to categorize the files. In this case it should be simple since we have just the 2 types of logs.

ess datastore rule add "*browse*gz" "browse" "YYYYMMDD"
# The first argument is the file pattern (following the same glob convention as the ls command).
# The second is the category name.  Pick something simple and informative.
# Finally we need to tell essentia how to map the date in the filename to day, month, and year.

# We can get a summary of the data immediately
ess datastore summary

# At this point all we know about the files are the range of dates, which we extracted from the filename.
# Let's have essentia probe one of the files in an attempt to glean other information.

ess datastore probe browse --apply
# The --apply switch will take the information and update the database.  The default is to simply output the information
# to the screen.  Let's see the result:
ess datastore summary

# Essentia has successfully determined that the files belonging to this category are comma separated, have GZIP compression, and have three
# columns: eventDate, userID, and articleID.
# for logs without headers, essentia will just call the columns c1,c2.etc.
# More importantly, essentia has attempted to determine the TYPE of data in each column.  In this case it got it right but
# every log is different. Often things such as integers should be treated as strings for example.

# One piece of information essentia could not determine was the format of the date string within the data.  Inspecting one of the files,
# we see that the date is entered in the following format: "2014-09-30 00:00:37".  For the Essentia ETL, this corresponds to a pattern
# "Y.m.d.H.M.S"
# We can set that manually via the following command:
ess datastore category change browse dateFormat "Y.m.d.H.M.S"
# Also we can set the timezone, which was not encoded in the file but is something we independently know.
ess datastore category change browse TZ GMT

# Why is setting these date/time patterns important?  Later when we wish to do ETL, you can use simple commands to
# process logs with time resolutions as small as a second.  We'll comment more on that in the next demo.


# repeating this for the purchasing logs is similar, so we just present the commands here without comment
ess datastore rule add "*purchase*gz" purchase "YYYYMMDD"
ess datastore probe purchase --apply
ess datastore category change purchase dateFormat "Y.m.d.H.M.S"
ess datastore category change purchase TZ GMT

