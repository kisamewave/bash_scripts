#!/usr/bin/bash
current_date=$(date +%F)
retval=`sqlplus -s $1 << EOF >> log_$current_date.log
whenever sqlerror exit sql.sqlcode;
set echo off 
set heading off

select * from test11;

exit;
EOF`
if [ -z "$retval"]; then
echo "No rows returned from database"
exit 0
else 
echo $retval
fi