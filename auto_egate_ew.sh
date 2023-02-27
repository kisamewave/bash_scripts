#!/bin/bash


declare -a errorList=(
"com.retek.platform.persistence.PersistenceException: SQL insert, update or delete failed"
"At least one resource manager failed to rollback"
"java.lang.NullPointerException"
"Unable to find RoutingInfo"
"dsds"
)

echo -e "DOWN ewHospitalRetryPDM\nDOWN ewRetryRMS" > t.tmp

downModule=$(grep -i down t.tmp | awk '{print $2}' FS=" " | tr -cd "[:alnum:]\n")

for module in ${downModule[@]}
do

	if [[ -f $module.log ]]; then
		echo "jest plik"
		#continue - przejdzie do kolejnej iteracji
		#continue
		#statements
	else
		echo -e 'StackTrace\ndsds' > $module.log	
	fi

	#find wherse the issue
	stackTraceLine=$(grep -n "StackTrace" $module.log | tail -1 | gawk '{print $1}' FS=":")

    echo $stackTraceLine
    #true is string is null
	if [[ -z $stackTraceLine ]]; then
		echo "xxx"
		#statements
	else
		err=$((stackTraceLine+1))
		
		errText=$(sed -n $err"p" $module.log)
		echo $errText
	fi

for err in "${errorList[@]}"
do
	if [[ ${errText} =~ ${err} ]]; then
		echo "tu jest"
		#statements
	fi
done

done	