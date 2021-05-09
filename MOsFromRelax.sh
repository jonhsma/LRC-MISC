#!/bin/sh
if [ -z "$1" ]
then
	echo "It needs the output of a relaxation calculation"
else
	sed '1,/OPTIMIZATION/d' $1|sed '1,/Orbital/d'|sed '/Ground-State/,$d'
fi
