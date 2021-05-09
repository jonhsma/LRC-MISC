#!/bin/sh
# This script batch reads the ourput of relaxation calculations and exports the final geometry as .xyz files
# Separate folders are expected for separate molecules
if [ -z $1 ]
then 
	echo "A list of molecules and destination folder is needed"
	echo "A third optional variable specified the name of the relax output file"
	exit
fi

if [ -z $2 ]
then 
	echo "Destination folder needed"
	exit
fi


if [ -z $3 ]
then
	SOURCE_NAME="relax.out"
else 
	SOURCE_NAME=$3
fi


MOLECULE_LIST=(`cat $1`)
mkdir -p $2

for MOLECULE in "${MOLECULE_LIST[@]}"
do 
	# Get the relaxed coordinates
	get_Relaxed.sh $MOLECULE/$SOURCE_NAME > $2/$MOLECULE.xyz
	echo $2/$MOLECULE
	#echo "---"	
done
