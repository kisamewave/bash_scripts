#!/usr/bin/bash
MY_SHELL="bash"

arg1="1"
arg2="2"

if [ "$MY_SHELL" = "bash" ]
then echo "ok"
fi

if   [ $arg1 -eq $arg2 ]
then echo "rowne"
elif [ $arg1 -eq $arg2 ]
then echo "nie"
else
echo "err"
fi

for i in $arg1 $arg2
do 
echo ":i $i"
done