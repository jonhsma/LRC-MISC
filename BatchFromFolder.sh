#!/bin/sh

# Get the list of files
# Those files have to be in standard .xyz format
if [ -z "$1" ]
then 	
	echo '======================================'
	echo '=      Usage                         ='
	echo '======================================'
	echo '1 | Fodler path                       '
	echo '2 | footer path           input.footer'
	echo '3 | charge and degen.             0 1 '
	echo '4 | name                        qchem '
	exit
else
	MOLECULE_PATH=$1
fi

if [ -z "$2" ]
then
	FOOTER_PATH=input.footer
else
	FOOTER_PATH=$2
fi

if [ -z "$3" ]
then
	FL_GS='0 1'
else
	FL_GS=$3
fi


if [ -z "$4" ]
then
	CALCNAME='qchem'
	SLMSUFFIC='';
else
	CALCNAME=$4
	SLMSUFFIX=$4
fi

FILES_ARRAY=(`ls $MOLECULE_PATH`)

for FILE in "${FILES_ARRAY[@]}"
do
	GEOM=`sed '1,2d' $MOLECULE_PATH/$FILE`

	# Create the melecule specific folder
	FOLDER_NAME=`echo $FILE | sed "s/.xyz//"`'_'`echo $FL_GS | sed "s/ /_/g"`
	 mkdir -p $FOLDER_NAME
	
	# Put the slm file in place
	SLM_NAME=$SLMSUFFIX'.slm'
	sed 	"s/%NAME%/$CALCNAME/g" 	prototype.slm 	>	$FOLDER_NAME/$SLM_NAME
	
	FILE_NAME=$CALCNAME'.in'

	mkdir -p $FOLDER_NAME

	###################################################
	### Modify as appropriate
	###################################################
	#FL_GS='0 1'

	printf "\$molecule\n $FL_GS \n" > $FILE_NAME
	printf "$GEOM" >> $FILE_NAME
	printf "\n\$end\n" >> $FILE_NAME
	cat $FOOTER_PATH >> $FILE_NAME

	mv $FILE_NAME $FOLDER_NAME

	# Run the calculation
	cd $FOLDER_NAME
	sbatch $SLM_NAME
	#cat $SLM_NAME
	cd ..
done
