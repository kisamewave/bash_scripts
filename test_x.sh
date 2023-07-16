#!/bin/bash

echo "Arguments passed to the script:"

# Loop through each argument and display it
for arg in "$@"
do
    echo "$arg"
done

echo $?