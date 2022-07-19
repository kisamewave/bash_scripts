#!/bin/bash

n=0

funkcja()
{
 
 echo '%b' 'blad' >&2
 
} 

while true; do
	#statements
n=$((n+1))
printf "%b" "Hello $1 ${n} \n"
printf "%b" "Hello $1 ${n} \n"

if [[ n -eq 10 ]]; then
	break;
	#statements
fi

done