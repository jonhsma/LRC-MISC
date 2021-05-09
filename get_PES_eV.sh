#!/bin/sh

if [ -z "$1" ]
then 
	echo "No file specified"
	exit
fi	

touch cache temp temp2

rm cache temp temp2

# Ground state 
GS=$(sed '1,/[cC][iI][sS]_[nN]_[rR]/d' $1 |awk '/Total energy in the final basis set/{print $9}')

echo "scale = 10; $GS*27.2114" | bc > temp



# Excited states
x=1
while [ TRUE ]
do
	XE=$(awk "/Excited state * $x:/{getline;print \$6}" $1)
	echo "scale = 10; $XE*27.2114" | bc > cache
	y=($(wc -l cache))
	if [ $y -le  0 ]
	then
		break
	fi
	x=`expr $x + 1`
	paste  	temp cache > temp2
	cat 	temp2 > temp
done

rm temp2 cache
cat temp
rm temp
