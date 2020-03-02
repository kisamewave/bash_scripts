#!/usr/bin/bash
variable="TEST"
echo "Hello $variableing"
echo "Hello ${variable}ing"
server_name=${hostname}
echo $server_name
[ -e /etc/passwd ]
arg1="1"
arg2="1"
echo $arg1
if [ arg1 -eq arg2]
then 
sleep 10
fi