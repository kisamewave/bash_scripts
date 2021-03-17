#!/usr/bin/bash

sqlplus -s <<-! > sql_results.out 2>&1
$1
select 1 from dual;
exit
!

### Check the output file for Oracle errors.
grep 'ORA-' sql_results.out > /dev/null 2>&1
if [ $? -eq 0 ] ; then
echo "`date` - Oracle error: Check sql_results.out" >> log_file.txt
exit 1
fi