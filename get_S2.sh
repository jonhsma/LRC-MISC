#!/bin/sh
if [ -z "$1" ]
then
	echo "It needs the output of a calculation"
else

		awk '/<S\*\*2>/{print $3}' $1 | tr '\n' '\t' 
		printf '\n'
fi
