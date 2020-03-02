#!/usr/bin/bash
loc=$(pwd)
function bf()
{
if [ -f $1 ]
then 
back="$loc/$(basename ${1}.$(date +%F).$$)"
echo "backing up to $1 to ${back}"
cp $1 $back
fi
}
bf $loc
if [ $? -eq 0 ]
then 
echo "back done"
fi