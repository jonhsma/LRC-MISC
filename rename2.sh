#!/bin/sh

if [ -z $1 ]
then
	echo 'This is a batch rename script executor'
	echo 'The first argument is the pattern to be replaced
	echo 'The second argument is the replacing pattern
	echo 'The third  argument is the list of files to be renamed'
	exit
fi

if [ -z $3 ]
then
	echo 'All three arguments required'
	exit
fi


FILE_LIST=`ls "$3"`
#echo $FILE_LIST

for FILE_NAME in $FILE_LIST
do
	NEW_NAME=`cat << EOF | sed "s/$1/$2/g"
$FILE_NAME 
EOF`

	mv $FILE_NAME $NEW_NAME
done
