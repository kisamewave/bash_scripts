#!/bin/bash
# Constants
ORACLE_BASE=/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/oracledb; export ORACLE_HOME
TNS_ADMIN=$ORACLE_HOME/network/admin; export TNS_ADMIN

PROGNAME=main_ptlog
BIN_DIR=/app/rmsprod/rms/oracle/proc/bin
. $BIN_DIR/log.lib
BATCH_START=$(date +"%Y%m%d")

PID=$$

ERRFILE=/app/rmsprod/rms/error/${PROGNAME}_${BATCH_START}_${PID}.err

# Nagios plugin return values
RET_OK=0
RET_WARNING=1
RET_CRITICAL=2
RET_UNKNOWN=3

ORACLE_CONNECT=''
echo "starting..${progname} with ${PID}"

counter=0

while getopts d:s: OPT $@; do
    case $OPT in
        d) # Oracle SID
           ORACLE_CONNECT="$OPTARG"
           ;;
        s) SPID="$OPTARG";;
    esac
done

while true; do

ret=`sqlplus -silent "${ORACLE_CONNECT}" <<END
SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD OFF TRIMS OFF
  SET VERIFY OFF
  SET PAUSE OFF
  SET LONG 32000000
  SET SERVEROUTPUT ON
declare 

Cursor C is select zmtp.rowid || ' ' || replace(zmtp.params,'^',' ') params 
from rmsprod.z_multi_thread_proc zmtp
where 1=1
and zmtp.status = 'N'
and rownum = 1 
and name = 'ptlog'
order by zmtp.order_seq
 FOR UPDATE skip locked;

  TYPE t_main IS RECORD(
    params z_multi_thread_proc.params%TYPE,
    rowid    UROWID);


 TYPE t_tab_main IS TABLE OF t_main;
  table_main t_tab_main;

L_n varchar2(255);

t_c c%rowtype;
begin


open c; 
fetch c into t_c;

if c%notfound then 
dbms_output.put_line('value_not_found');
end if;

dbms_output.put_line(t_c.params);

update rmsprod.z_multi_thread_proc
set status = 'I', pid = $PID
where 1=1
and rowid = regexp_substr(t_c.params,'[^ ]+',1,1);

close c;

end;

/
 EXIT;
END`

xxx=$ret

ret2=$(echo $xxx | cut -d ' ' -f 2-)

#echo $ret2

let counter=counter+1

IF_EXSISTS=$(echo $ret2 | awk -F " " '{print $2}' | sed '/^$/d' | wc -l)
MAX_COUNTER=200 

echo "iteration..${counter}"

#echo "hello x " $IF_EXSISTS
#|| $x -eq 0 

if [[ $ret2 == 'value_not_found' || counter -gt $MAX_COUNTER ]]; then
  echo $ret2
  break
fi


export NLS_LANG=AMERICAN_AMERICA.UTF8;
saimptlogi $ret2

if [ $? -eq 0 ]; then 


rid=$(echo $xxx | cut -d ' ' -f 1)

done=`sqlplus -silent "${ORACLE_CONNECT}" <<END
WHENEVER SQLERROR EXIT 1
DECLARE
begin
  update   rmsprod.z_multi_thread_proc 
set status = 'D', error_message = null
where 1 = 1
and rowid = '${rid}'
and pid = $PID;
END;

/
 EXIT;
END`
 
 echo $done

 log "pid ${PID} spid ${SPID} PL/SQL Procedure executed successfully."
  
  ARCH_FILE=$(echo $ret2 | awk -F " " '{print $2}')
  echo "moving to arch ${ARCH_FILE}" 
  #do testow
  #mv ${ARCH_FILE} /app/rmsprod/rms/lppidata/archived/fs04/
else


error=`sqlplus -silent "${ORACLE_CONNECT}" <<END
WHENEVER SQLERROR EXIT 1
DECLARE
begin
  update   rmsprod.z_multi_thread_proc 
set status = 'E', error_message = 'ERROR HAS OCCURED'
where 1=1
and rowid = '${rid}'
and pid = $PID;

END;

/
 EXIT;
END`

log "${PID} Error calling the PL/SQL procedure."
err "${PID} Error calling the PL/SQL procedure."
  echo "blad main_ptlog"
  #exit $?
fi 


done