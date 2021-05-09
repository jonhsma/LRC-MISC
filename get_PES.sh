#!/bin/sh

if [ -z "$1" ]
then 
	echo "No file specified"
	exit
fi	

touch cache temp temp2

rm cache temp temp2

# Ground state 
sed '1,/[cC][iI][sS]_[nN]_[rR]/d' $1 |awk '/Total energy in the final basis set/{print $9}'> temp



# Excited states
x=1
while [ TRUE ]
do
	awk "/Excited state * $x:/{getline;print \$6}" $1>cache
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
