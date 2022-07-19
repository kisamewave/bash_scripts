#!/bin/bash

########
#Testowy skrypt
#Version: 1 
#Purpose: Load files
#


if [[ $# -ne 1 ]]; then
	#statements
	printf "%b" "Error. Not enouch paramater" >&2
	printf "%b" "usage: $0 <schema/password> <input dir> <archive dir> <working dir> <error dir>"
else
	#statements
	printf "%b" "booting...\n"
fi

#zmienne 

PROGNAME=${1}
WORK_DIR="/tmp"

echo $WORK_DIR

function start_log
{
	
	local LOG_TIME=$(date "+%Y-%m-%d %H:%M:%S %Z")
	echo "${LOG_TIME}" >> err.log
}


#main 

echo "--1--"

STORES=(1 2 3)

for i in "${STORES[@]}"; do

	find -name "POSU_${i}_*" -size -100c -type f -exec rm {} \; 
		#printf "%s\n" $i
	#statements
	#THREAD_COUNT=$((THREAD_COUNT + $i))
done

#echo "${THREAD_COUNT}"


echo "--2--"

ls 2>/dev/null | while read plik 
do 
   STORE=$(basename $plik | awk -F "_" '{print $2}')
   echo "${STORE}"
done 