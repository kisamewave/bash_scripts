#!/bin/bash
# Author: Pawel Piotr Wojtowicz
#
#/ Usage: SCRIPTNAME [OPTIONS]... [ARGUMENTS]...
#/
#/ 
#/ OPTIONS
#/   -h, --help
#/                Print this help message
#/
#/ EXAMPLES


PROGNAME=$(basename "${0}" .sh)

TS=$(date +'%Y-%m-%d')
LOGFILE="/app/rmsprod/rms/log/"${PROGNAME}"_$TS.log"
ERRFILE="/app/rmsprod/rms/error/"${PROGNAME}"_$TS.err"

#BATCH_START=$(date +"%Y%m%d")

ORACLE_CONNECT_SOURCE=$1

function logIt()
{
    local LOG_TS
    LOG_TS=$(date +'%Y-%m-%d %H:%M:%S')
    echo "$LOG_TS ${PROGNAME}: $*" >> $LOGFILE
    echo "$LOG_TS ${PROGNAME}: $*"
}

function errorLog {
    local LOG_TS
    LOG_TS=$(date +'%Y-%m-%d %H:%M:%S')
    echo "$LOG_TS ${PROGNAME} - Error: $*" >> $ERRFILE
    echo "$LOG_TS ${PROGNAME} - Error: $*"
    logIt "PID=$$: Error occured. Check error log [${ERRFILE}]"
}

# Test input params
function check_parameters ()
{
  if [[ $# -ne 1 ]]; then
    logIt "check_parameters failed"
    logIt "usage $PROGNAME <database>"
    declare -f | grep '()' | grep -v 'log' | grep -v 'err'
    exit 1; 
  fi
}

function check_connection()
{
  local ORACLE_CONNECT
  ORACLE_CONNECT=$1
  BASE=$(echo "${ORACLE_CONNECT}" | awk -F '/' '{print $NF}')
  TEMP_FILE=${BASE}_${PROGNAME}_$$.ora

  sqlplus -s "$ORACLE_CONNECT" <<-STOP > "${TEMP_FILE}"
    select * from v\$database;
    exit;
/
STOP


check_conn=$(cat "${TEMP_FILE}" | grep -Ei 'error|SP2' |wc -l )
oracle_num=$(expr "${check_conn}")


rm -f "${TEMP_FILE}"

if [[ $oracle_num -ne 0 ]]; then
  logIt "check_connection failed"
  exit 1
else
 logIt "check_connection succesed"
 return 0  
fi

  logIt "check base" $check_conn
}


function main() {

  logIt "${SPID} main started"

  check_connection "${ORACLE_CONNECT_SOURCE}"

  ret=$(sqlplus -s "${ORACLE_CONNECT_SOURCE}" <<-EOF
  WHENEVER SQLERROR EXIT SQL.SQLCODE
SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD OFF TRIMS OFF
  SET VERIFY OFF
  SET PAUSE OFF
  SET LONG 32000000
  SET SERVEROUTPUT ON
declare
  update_failed exception;
begin
  insert into pwojtowicz.pdm_rms_composition_status
    (model, composition_id, uda_value)
    WITH pdm AS
     (SELECT c.id composition_id, t.id model
        from MULE_MASTER_DATA_PUB_INFO@Pdm mmdpi
       inner join MOD_MODEL@Pdm t
          on mmdpi.model_id = t.id
        JOIN dict_composition@pdm c
          ON c.id = t.dict_composition_id
       where 1 = 1
         and mmdpi.created_date > sysdate - 31)
    SELECT distinct regexp_substr(im.short_desc, '[^-]+', 1, 1),
                    pdm.composition_id,
                    uil.uda_value
      FROM rmsprod.item_master im
      JOIN rmsprod.item_master imp
        ON im.item_parent = imp.item
       AND imp.status = 'A'
      JOIN rmsprod.uda_item_lov uil
        ON uil.item = im.item
       AND uil.uda_id = 22
      JOIN uda_item_lov uil_c
        ON uil_c.item = imp.item
       AND uil_c.uda_id = 1483
      JOIN pdm
        ON pdm.model = imp.short_desc
     WHERE 1 = 1
       AND pdm.composition_id <> uil.uda_value
       AND pdm.composition_id NOT IN (0, -1)
       and not exists
     (select 'x'
              from pwojtowicz.pdm_rms_composition_status prcs
             where prcs.model = regexp_substr(im.short_desc, '[^-]+', 1, 1));
  commit;

  for i in (select model, composition_id, uda_value
              from pwojtowicz.pdm_rms_composition_status
             where 1 = 1
               and status = 'N') loop
    begin
      update rmsprod.uda_item_lov uil
         set uil.uda_value = i.composition_id
       where 1 = 1
         and uda_id = 22
         and item in
             (select item
                from rmsprod.item_master im
               where regexp_substr(im.short_desc, '[^-]+', 1, 1) = i.model);
    
      update pwojtowicz.pdm_rms_composition_status
         set status    = 'P',
             update_at = sysdate,
             update_by = sys_context('USERENV', 'SESSION_USER')
       where model = i.model;
    
    exception
      when others then
        update pwojtowicz.pdm_rms_composition_status
           set status    = 'E',
               update_at = sysdate,
               update_by = sys_context('USERENV', 'SESSION_USER')
         where model = i.model;
    end;
  
    commit;
  
  end loop;
exception
  when others then
    rollback;
    RAISE_APPLICATION_ERROR(-20001, 'An error occurred: ' || SQLERRM);
end;
/
exit 
EOF
)

  SQLerror=$?

  if [[ $SQLerror -ne 0 ]]; then
  #statements
  logIt 'Blad 255'
  exit 255
else
  echo "${ret}"
  logIt 'OK 0'
fi

}

logIt "Start '${PROGNAME}'"
check_parameters "$@"
main "$@"