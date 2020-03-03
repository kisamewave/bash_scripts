#!/usr/bin/bash
declare -a Unix=(pawel daga karola)
Unix=("${Unix[@]}" "Stachu")
for i in "${Unix[@]}"; 
do echo $i;
done

