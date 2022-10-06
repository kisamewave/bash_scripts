#!/bin/bash


pid=$$

counter=0

echo "hello"

while true; do
	#statements

ret=$(sqlplus -s system/system@xe <<EOF


select params from test1 
where status = 'N'
and rownum = 1 
for update skip locked;
 


EOF
)


let counter=$counter+1

echo "counter" $counter
echo $ret

x=$(echo $ret | awk -F "." '{print $2}' | sed -r '/^\s*$/d' | wc -l) 

echo "czy false czy true" $x

if [[ $counter -gt 10 || $x -eq 0 ]]; then

	#statements
	break
fi

sh t2.sh $pid 


done