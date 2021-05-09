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

touch 	cache temp fileList temp2
rm 	cache temp fileList temp2
touch 	temp

# Get the list of file
ls | grep "$PREFIX" > fileList
N_FILE=`wc -l fileList| awk '{print $1}'`
#echo $N_FILE

for i in `seq 1 $N_FILE`
do
	FILENAME=`sed -n $i'p' fileList`
	FILE_NAME=$FILENAME/$OUT_FILENAME

	#echo $FILE_NAME
	awk '/dipole/ {getline; getline; getline; getline; getline; print$2}' $FILE_NAME > cache
	paste temp cache> temp2
	cat temp2 > temp

done

#Fill up the voids
for i in `seq 1 $N_FILE`
do
	sed -i 's/\t\t/\tNaN\t/g' temp
done


cat temp
rm temp cache temp2
