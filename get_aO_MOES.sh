#!/bin/sh


if [ -z "$1" ] 
then
	echo 'Path input needed'
fi


# The actual loop
STRING_ARRAY=($1)


for i in "${STRING_ARRAY[@]}"
do
	get_alphaOcc.sh $i
done
