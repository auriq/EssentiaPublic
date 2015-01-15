# This script imports four datasets, adds a few lines to them to ensure the query will output a result, calculates the increase in store sales from 1999 to 2000 by customer_id, calculates the increase in web sales from 1999 to 2000 by customer_id, 
# and returns the customer_id’s that saw a greater increase in web sales than in store sales.

ess instance local
ess udbd stop
 
ess spec create database bigbenchess2 --ports=1 
ess spec create vector vector1 s,pkey:customer_id s:customer_first_name s:customer_last_name s,+add:year f,+add:ss1999 f,+add:ss2000
# Stores a vector in the database bigbenchess2 that gets the first and last name, adds the store sales from 1999, and adds the store sales from 2000 for each unique customer_id.
ess spec create vector vector2 s,pkey:customer_id s:customer_first_name s:customer_last_name s,+add:year f,+add:ws1999 f,+add:ws2000
# Stores a vector in the database bigbenchess2 that gets the first and last name, adds the web sales from 1999, and adds the web sales from 2000 for each unique customer_id.

ess udbd start
 
ess datastore select s3://asi-public --credentials=/home/ec2-user/jobs/asi-public.csv
#ess datastore purge
ess datastore scan
ess datastore rule add "*date_dim*" date "YYYYMMDD-"
ess datastore rule add "*store_sales*" storesales "YYYYMMDD-"
ess datastore rule add "*web_sales*" websales "YYYYMMDD-"
ess datastore rule add "*customer*" customer "YYYYMMDD-"
# Creates categories date, store sales, web sales, and customer containing files matching the equivalent pattern.

ess datastore category change date compression none
ess datastore category change storesales compression none
ess datastore category change websales compression none
ess datastore category change customer compression none
# Tells essentia that the files in these categories are not compressed.
ess datastore summary

ess task stream date "*" "*" "aq_pp -f,sep='|',eok - -d i:date_sk X X X X X s:year X X X X X X X X X X X X X X X X X X X X X X -o /home/ec2-user/jobs/date2_bigbench_query13_ec2.csv -notitle" --debug 
ess task stream storesales "*" "*" "aq_pp -f,sep='|',eok - -d i:date_sk X X i:customer_sk X X X X X X X X X X X X X X X X f:ss_net_paid X X X -o /home/ec2-user/jobs/store2_bigbench_query13_ec2.csv -notitle" --debug
ess task stream websales "*" "*" "aq_pp -f,sep='|',eok - -d X i:date_sk X X X i:customer_sk X X X X X X X X X X X X X X X X X X X X X X X X f:ws_net_paid X X X X -o /home/ec2-user/jobs/web2_bigbench_query13_ec2.csv -notitle" --debug
ess task stream customer "*" "*" "aq_pp -f,sep='|',eok - -d i:customer_sk s:customer_id X X X X X X s:customer_first_name s:customer_last_name X X X X X X X X X -o /home/ec2-user/jobs/customer2_bigbench_query13_ec2.csv -notitle" --debug
# Pipes the files from these categories into aq_pp, tells it that they are ‘|’ delimited, and ignores some of their columns. Then saves them to a file on your local machine.


# Adding a few lines to each dataset to ensure at least one result in the final dataset. The rules set in the benchmark did not return any results when run on the original dataset.
ess task exec "echo -e '2488070,AAAAAAAAHAHPFCAA,1999-01-01,1,1,1,1999,4,1,1,1,2100,801,10436,Thursday,210001,Y,N,N,2488070,2488069,2487705,2487978,N,N,N,N,N,\n2488071,AAAAAAAAHAHPFCAA,1999-01-02,1,1,1,1999,4,1,1,1,2100,801,10436,Thursday,210001,Y,N,N,2488070,2488069,2487705,2487978,N,N,N,N,N,\n2488072,AAAAAAAAHAHPFCAA,1999-01-03,1,1,1,1999,4,1,1,1,2100,801,10436,Thursday,210001,Y,N,N,2488070,2488069,2487705,2487978,N,N,N,N,N,\n2488073,AAAAAAAAHAHPFCAA,2000-01-01,1,1,1,2000,4,1,1,1,2100,801,10436,Thursday,210001,Y,N,N,2488070,2488069,2487705,2487978,N,N,N,N,N,\n2488074,AAAAAAAAHAHPFCAA,2000-01-02,1,1,1,2000,4,1,1,1,2100,801,10436,Thursday,210001,Y,N,N,2488070,2488069,2487705,2487978,N,N,N,N,N,\n2488075,AAAAAAAAHAHPFCAA,2000-01-03,1,1,1,2000,4,1,1,1,2100,801,10436,Thursday,210001,Y,N,N,2488070,2488069,2487705,2487978,N,N,N,N,N,' | aq_pp -f,eok - -d i:date_sk X X X X X s:year X X X X X X X X X X X X X X X X X X X X X X -o,app /home/ec2-user/jobs/date2_bigbench_query13_ec2.csv -notitle" --debug
ess task exec "echo -e '2488070,47181,5684,100001,1873544,2153,1962,10,59,240000,68,81.95,105.71,1.05,0.00,71.40,5572.60,7188.28,1.42,0.00,70.40,70.82,-5501.20,\n2488071,47181,5684,100002,1873544,2153,1962,10,59,240000,68,81.95,105.71,1.05,0.00,71.40,5572.60,7188.28,1.42,0.00,70.40,70.82,-5501.20,\n2488072,47181,5684,100003,1873544,2153,1962,10,59,240000,68,81.95,105.71,1.05,0.00,71.40,5572.60,7188.28,1.42,0.00,70.40,70.82,-5501.20,\n2488073,47181,5684,100004,1873544,2153,1962,10,59,240000,68,81.95,105.71,1.05,0.00,71.40,5572.60,7188.28,1.42,0.00,71.40,72.82,-5501.20,\n2488074,47181,5684,100005,1873544,2153,1962,10,59,240000,68,81.95,105.71,1.05,0.00,71.40,5572.60,7188.28,1.42,0.00,71.40,72.82,-5501.20,\n2488075,47181,5684,100006,1873544,2153,1962,10,59,240000,68,81.95,105.71,1.05,0.00,71.40,5572.60,7188.28,1.42,0.00,71.40,72.82,-5501.20,' | aq_pp -f,eok - -d i:date_sk X X i:customer_sk X X X X X X X X X X X X X X X X f:ss_net_paid X X X -o,app /home/ec2-user/jobs/store2_bigbench_query13_ec2.csv -notitle" --debug
ess task exec "echo -e '2452230,2488070,2452263,8233,13205,100001,6813,14417,13205,1642409,6813,14417,45,25,13,3,283,60000,72,91.85,155.22,57.43,7040.88,4134.96,6613.20,11175.84,0.00,0.00,2458.08,4134.96,4000.00,6593.04,6593.04,-2478.24,\n2452230,2488071,2452263,8233,13205,100002,6813,14417,13205,1642409,6813,14417,45,25,13,3,283,60000,72,91.85,155.22,57.43,7040.88,4134.96,6613.20,11175.84,0.00,0.00,2458.08,4134.96,4000.00,6593.04,6593.04,-2478.24,\n2452230,2488072,2452263,8233,13205,100003,6813,14417,13205,1642409,6813,14417,45,25,13,3,283,60000,72,91.85,155.22,57.43,7040.88,4134.96,6613.20,11175.84,0.00,0.00,2458.08,4134.96,4000.00,6593.04,6593.04,-2478.24,\n2452230,2488073,2452263,8233,13205,100004,6813,14417,13205,1642409,6813,14417,45,25,13,3,283,60000,72,91.85,155.22,57.43,7040.88,4134.96,6613.20,11175.84,0.00,0.00,2458.08,4134.96,8000.00,6593.04,6593.04,-2478.24,\n2452230,2488074,2452263,8233,13205,100005,6813,14417,13205,1642409,6813,14417,45,25,13,3,283,60000,72,91.85,155.22,57.43,7040.88,4134.96,6613.20,11175.84,0.00,0.00,2458.08,4134.96,8000.00,6593.04,6593.04,-2478.24,\n2452230,2488075,2452263,8233,13205,100006,6813,14417,13205,1642409,6813,14417,45,25,13,3,283,60000,72,91.85,155.22,57.43,7040.88,4134.96,6613.20,11175.84,0.00,0.00,2458.08,4134.96,8000.00,6593.04,6593.04,-2478.24,' | aq_pp -f,eok - -d X i:date_sk X X X i:customer_sk X X X X X X X X X X X X X X X X X X X X X X X X f:ws_net_paid X X X X -o,app /home/ec2-user/jobs/web2_bigbench_query13_ec2.csv -notitle" --debug
ess task exec "echo -e '100001,AAAAAAAABKGIBAAA,441077,4582,8487,2449763,2449733,Mrs.,Erica,Parrott,Y,16,7,1939,BELGIUM,1,Erica.Parrott@9pnE.com,2452621,\n100002,AAAAAAAABKGIBAAA,441077,4582,8487,2449763,2449733,Mrs.,Erica,Parrott,Y,16,7,1939,BELGIUM,1,Erica.Parrott@9pnE.com,2452621,\n100003,AAAAAAAABKGIBAAA,441077,4582,8487,2449763,2449733,Mrs.,Erica,Parrott,Y,16,7,1939,BELGIUM,1,Erica.Parrott@9pnE.com,2452621,\n100004,AAAAAAAABKGIBAAA,441077,4582,8487,2449763,2449733,Mrs.,Erica,Parrott,Y,16,7,1939,BELGIUM,1,Erica.Parrott@9pnE.com,2452621,\n100005,AAAAAAAABKGIBAAA,441077,4582,8487,2449763,2449733,Mrs.,Erica,Parrott,Y,16,7,1939,BELGIUM,1,Erica.Parrott@9pnE.com,2452621,\n100006,AAAAAAAABKGIBAAA,441077,4582,8487,2449763,2449733,Mrs.,Erica,Parrott,Y,16,7,1939,BELGIUM,1,Erica.Parrott@9pnE.com,2452621,' | aq_pp -f,eok - -d i:customer_sk s:customer_id X X X X X X s:customer_first_name s:customer_last_name X X X X X X X X X -o,app /home/ec2-user/jobs/customer2_bigbench_query13_ec2.csv -notitle" --debug
# Adds the stated lines to each of the created files. This was necessary to ensure that the query returned a result.


ess task exec "aq_pp -f,eok /home/ec2-user/jobs/date2_bigbench_query13_ec2.csv -d i:date_sk s:year -filt '(year == \"1999\" || year == \"2000\")' -cmb,req /home/ec2-user/jobs/store2_bigbench_query13_ec2.csv i:date_sk i:customer_sk f:ss_net_paid -cmb,req /home/ec2-user/jobs/customer2_bigbench_query13_ec2.csv i:customer_sk s:customer_id s:customer_first_name s:customer_last_name -if -filt '(year == \"1999\")' -evlc f:ss1999 'ss_net_paid' -elif -filt '(year == \"2000\")' -evlc f:ss2000 'ss_net_paid' -endif -udb_imp bigbenchess2:vector1" --debug
# Combines the files in the date, store sales, and customer categories; filters to dates between 1999 and 2000, creating a column for the net profit from store sales in 1999 and one for the profit in 2000; 
# and imports the modified data into the first vector in the database.
ess task exec "aq_pp -f,eok /home/ec2-user/jobs/date2_bigbench_query13_ec2.csv -d i:date_sk s:year -filt '(year == \"1999\" || year == \"2000\")' -cmb,req /home/ec2-user/jobs/ess2testresults/web2_bigbench_query13_ec2.csv i:date_sk i:customer_sk f:ws_net_paid -cmb,req /home/ec2-user/jobs/customer2_bigbench_query13_ec2.csv i:customer_sk s:customer_id s:customer_first_name s:customer_last_name -if -filt '(year == \"1999\")' -evlc f:ws1999 'ws_net_paid' -elif -filt '(year == \"2000\")' -evlc f:ws2000 'ws_net_paid' -endif -udb_imp bigbenchess2:vector2" --debug
# Combines the files in the date, web sales, and customer categories; filters to dates between 1999 and 2000, creating a column for the net profit from web sales in 1999 and one for the profit in 2000; 
# and imports the modified data into the second vector in the database.
ess task exec "aq_udb -exp bigbenchess2:vector1 -pp vector1 -pp_filt 'ss1999 > 0' -pp_evlc ss2000 '(ToF(ss2000) / ToF(ss1999))' -o - | aq_pp -f - -d s:customer_id s:customer_first_name s:customer_last_name X X s:ss2000 -ddef -o /home/ec2-user/jobs/cmbstore_bigbench.csv -notitle; aq_udb -exp bigbenchess2:vector2 -pp vector2 -pp_filt 'ws1999 > 0' -pp_evlc ws2000 '(ToF(ws2000) / ToF(ws1999))' -o - | aq_pp -f,+1 - -d s:customer_id s:customer_first_name s:customer_last_name X X s:ws2000 -cmb /home/ec2-user/jobs/cmbstore_bigbench.csv s:customer_id s:customer_first_name s:customer_last_name s:ss2000 -evlc f:greater_ws_net_pay '(ToF(ws2000) - ToF(ss2000))' -filt 'greater_ws_net_pay > 0' -o /home/ec2-user/jobs/bigbenchess2.csv -c customer_id customer_first_name customer_last_name greater_ws_net_pay" --debug
# Exports the aggregated data from the two vectors in the database, calculating the ratio of store sales in 2000 and 1999 and web sales in 2000 and 1999, and outputs the results to files on the local machine. 
# Then combines the two files, calculate the difference between the web sales ratio and store sales ratio, and outputs the records where the web sales ratio was larger than the store sales ratio.

ess udbd stop
