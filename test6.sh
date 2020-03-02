#!/usr/bin/bash

sqlplus -s <<-! > sql_results.csv 2>&1
system/nightfall1@xe

select * from test11;

exit
!

### Check the output file for Oracle errors.
grep 'ORA-' sql_results.out > /dev/null 2>&1
if [ $? -eq 0 ] ; then
echo "`date` - Oracle error: Check sql_results.out" >> log_file.txt
exit 1
fi
