#!/usr/bin/bash
MY_SHELL=$(ls *jpg)
WD=$(ps -ef)
DATE=$(date +%F)
var1=1

read -p USER
echo "exec script: $1"
echo $USER
for i in $MY_SHELL
do
echo "${var1}: $i"	
echo $DATE
done
echo $WD
sleep 5

for i in $1 $2 $3 
do 
echo $i
done
