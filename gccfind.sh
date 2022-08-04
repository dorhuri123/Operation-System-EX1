#!/bin/bash
#Dor Huri 209409218

#if there are not enough parameters‬‬
if [ $# -lt 2 ]
then
	echo "‫‪Not‬‬ ‫‪enough‬‬ ‫‪parameters‬‬"
	exit
fi
#delete all files in current directory
find $1 -maxdepth 1 -type f -name "*.out" | xargs rm -f
#for all files that end in .c
for f in "$1/"*".c"
do
#compile file that contain the specific word
    grep -qiw $2 $f && gcc -w $f -o "${f%%.c}.out"
done
#if this is recursive
if [[ $3 == '-r' ]]

then
#iterate over all files
	for files in $1*/
	do
#if files is a directory
		if [[ -d $files ]]
	then
#call the function recursavly
		$($0 $files $2 "-r")
		fi
	done
fi
exit
