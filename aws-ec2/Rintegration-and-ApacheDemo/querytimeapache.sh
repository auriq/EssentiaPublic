# bash loadtimeapache.sh
# Run to load the data into the udbd database.


# QUERIES

ess task exec "aq_udb -exp logsapache3:vector3; echo 'RSTOPHERE'" --debug
# Export the data from your vector in the database that contains the counts over the entire month so that it can be read into an R dataframe.

ess task exec "aq_udb -exp logsapache1:vector1 -sort pagecount -dec; echo 'RSTOPHERE'" --debug
ess task exec "aq_udb -exp logsapache4:vector4 -sort pagecount -dec; echo 'RSTOPHERE'" --debug
ess task exec "aq_udb -exp logsapache2:vector2 -sort pagecount -dec; echo 'RSTOPHERE'" --debug
# Export the day, day of the week, and hour vectors from their respective databases, ordering the output by the number of pages seen (in descending order). R will capture the output of each command into an R dataframe.



# ess udbd stop
# Run to stop the udbd database when you no longer need it to store the data
