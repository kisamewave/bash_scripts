#!/bin/bash 

PROGNAME=m_thread_init

err()
{
printf "%b" "FAILED.\n" ; exit 1
} 

if [[ $# -ne 1 ]]; then

	printf '%b' 'not enouch parameters \n'   >&2
	printf '%b' 'please define dbconnection' >&2
fi

for (( i = 0; i < 2; i++ )); do
	
	echo $i
	#sh main.sh 
done

#printf '%s' $?
RETVAL=$?

if [[ ${RETVAL} -eq 0 ]]; then
	#needed to be checked
	err > err.log 2>&1
fi 

exit 0
