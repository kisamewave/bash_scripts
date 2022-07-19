#!/bin/bash

l_user='scott'
l_psw='tiger'
l_conn_string='//YourHost:1521/orcl'
# first parameter passed to this shell script
l_empno=$1
start=`date +%s.%N`

sql_error=`sqlplus -silent $l_user/$l_pws@$l_conn_string  <<END
WHENEVER SQLERROR EXIT 1
declare 

cursor c is select parameter from parameter_test
where status = 'N'
order by id
for update skip locked;


type t is table of parameter_test.parameter%type;
tt t;
begin 
open c;
--sys.dbms_lock.sleep(10);

loop
fetch c bulk collect into tt limit 10000;
forall i in 1 .. tt.count 
update parameter_test
set status = 'D', start_time=${start}
where parameter = tt(i);
exit when tt.count <> 10000;
end loop;
exception 
 when others then
  raise;
end;
/
 EXIT;
END`

Result=$?

echo $Result

if [[ $Result -ne 0 ]]
then
  echo "${sql_error}"
  echo "Error calling the PL/SQL procedure."
  exit $Result
else
  echo "PL/SQL Procedure executed successfully."
  exit 0
fi
