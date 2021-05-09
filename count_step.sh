#!/bin/sh


# The prefix
if [ -z "$1" ]
then
	#echo "No prodix specified, resroting to Iteration"
	PREFIX=Iteration
else
	PREFIX=$1
fi

# The output file
if [ -z "$2" ]
then
	#echo "Using default output filename output.out"
	OUT_FILENAME=output.out
else
	OUT_FILENAME=$2
fi

touch 	cache fileList
rm 	cache fileList

# Get the list of file
ls | grep "$PREFIX" > fileList
N_FILE=`wc -l fileList| awk '{print $1}'`
#echo $N_FILE

for i in `seq 1 $N_FILE`
do
	FILENAME=`sed -n $i'p' fileList`
	FILE_NAME=$FILENAME/$OUT_FILENAME

	#echo $FILE_NAME
	grep 'TIME STEP' $FILE_NAME > cache
	echo $FILE_NAME
	wc -l cache
done
rm cache
