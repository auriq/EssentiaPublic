# This first query exports the data from a vector in the database that contains the counts over each month so that it can be read into an R dataframe.
ess exec "aq_udb -exp logsapache3:vector3"

# The next three statements export the day, day of the week, and hour vectors from their respective databases, ordering the output by the number of pages seen (in descending order). 
# R will capture the output of each command into an R dataframe.
ess exec "aq_udb -exp logsapache1:vector1 -sort,dec pagecount"
ess exec "aq_udb -exp logsapache4:vector4 -sort,dec pagecount"
ess exec "aq_udb -exp logsapache2:vector2 -sort,dec pagecount"
