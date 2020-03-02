#!/usr/bin/bash
function f() 
{
for i in $@
do
echo $i
done
}
f s a b 