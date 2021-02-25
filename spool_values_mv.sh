#!/bin/bash

CONNECTION=system/pass@xe



variable1=`sqlplus -s "${CONNECTION}" <<EOF  	
set colsep; 
set headsep off;
set pagesize 0;
set trimspool on;
SET LINESIZE 100;
set linesize 32767 long 10000000 longchunksize 32767 trimout on trimspool on
spool test1234.txt
SELECT 1 from dual;
EXIT;
EOF`

#archieve 
file_count=0
for file in *.txt
do
	if [[ ! -f "$file" ]];then
		continue
	fi 
	mv "$file" move_test
	file_count=$((file_count+1))
done

