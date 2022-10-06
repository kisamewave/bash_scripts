#!/bin/bash


pid=$$
spid=$1
progname=t2.sh
echo $progname

ret=$(sqlplus -s system/system@xe <<EOF

update test1
set status = 'D', pid=$spid
where id = (select min(id) from test1 where status ='N');

EOF
)

if [[ $? -eq 0 ]]; then
	echo "done"
else
	echo "error"
	exit $?
	#statements
fi


