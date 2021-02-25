#!/bin/bash

#shell variable
COUNTER=20


if [ "$#" -ne 1 ]; 
then
 echo "not enough value"
 exit 0
fi

until [  $COUNTER -lt 10 ]; do
sqlplus -s system/pass@xe << EOF
whenever sqlerror exit sql.sqlcode;
set echo off 
set heading off

update test123
set employee_id = 2 
where 1=1;

exit;
EOF

#Perform arithmetic on shell variables 
let COUNTER-=1
 sleep 5
done 