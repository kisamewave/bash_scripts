#!/bin/bash

 while IFS= read -r line
do 
	cat > $line.sql << EOF
add grant select on $line
EOF
done < t.txt