#!/bin/bash


dirlist="Finished $(ls -d */)"

PS3='Dir to process?'
until [[ "$directory" == "Finished" ]]; do

	#printf "%b" "\a\n\nSelect a directory to process:\n" >&2
	select directory in $dirlist; do
	
	if [[ "$directory" = "Finished" ]]; then
		echo "break"
		break
		#statements
	elif [[ -n "$directory" ]]; then
		echo "chose number"
			#statements	
		break	
	fi
	#statements
done
done
