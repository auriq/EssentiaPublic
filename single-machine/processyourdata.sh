ess instance local      # Starts a local instance since no workers are needed. Tells essentia to work on your machine.
ess udbd stop            # Checks that the nothing in stored in memory from previous essentia runs.
 
ess datastore select s3://asi-public --credentials=/home/ec2-user/jobs/asi-public.csv
#ess datastore purge
ess datastore scan
 
ess datastore rule add "*MOCK_DATA*" "mockdata"
ess datastore probe mockdata --apply
ess datastore summary
 
ess spec drop database etl-ess2working
ess spec create database etl-ess2working --ports=1
ess spec create vector vector1 s,pkey:my_string_column_to_group_by f,+add:float_column_to_import f,+last:rowcount f,+last:rowcount2
 
ess udbd start            # Starts communication with worker nodes (or master by default if running a local instance). Starts the database so you can import data into it.
 
ess task stream mockdata "*" "*" "aq_pp -f,+1,eok - -d s:column_to_import -evlc f:float_column_to_import '(ToF(column_to_import))' -filt '(float_column_to_import >= 1 && float_column_to_import <= 8)' -evlc s:my_string_column_to_group_by 'ToS(1)' \
-evlc f:rowcount '\$RowNum' -ddef -udb_imp etl-ess2working:vector1" --debug
 
ess task exec "aq_udb -exp etl-ess2working:vector1 -pp vector1 -pp_evlc rowcount2 'rowcount' -pp_evlc rowcount 'float_column_to_import / rowcount' -o /home/ec2-user/jobs/etl-ess2working.csv -o -; aq_udb -cnt etl-ess2working:vector1" --debug
