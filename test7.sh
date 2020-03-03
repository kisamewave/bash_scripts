#!/usr/bin/bash
my_array=(foo bar)
for i in "${!my_array[@]}";
do echo "$i";
done

Unix[0]='Pawel'
echo ${Unix[0]}
#deklaracja tablicu
declare -a Unix2=(Pawel Daga Dom);
#wysztkie elementy
echo ${Unix2[@]}
#ilosc elementow
echo ${#Unix2[@]}
#wyswietl 1 i 2 element
echo ${Unix2[@]:1:2}
#replace pawel -> paul
echo ${Unix2[@]/Pawel/Paul}
#dodaj obiekt do istniejacej tablicy
Unix2=("${Unix2[@]}" "Stachu")
echo "${Unix2[@]:3}"