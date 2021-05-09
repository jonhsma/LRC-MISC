#!/bin/sh
if [ -z "$1" ]
then
	echo "It needs the output of a relaxation calculation"
else

# It's kinda dirty to assume that the energy is always negative but it usually is
		sed '1,/Orbital/d' $1 | sed '1,/Occupied/d' |sed '/Virtual/,$d' | tr '\n' ' '  
		printf '\n'
fi
