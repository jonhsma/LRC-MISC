#!/bin/sh

# This function populates a qchem calculation from a template

if [ -z $3 ]
then
	echo "This function that populates a qchem calculation from a template"
	echo "The template should contatin a .slm file and a .footer file"
	echo "The slm should have the input and output file names replaced"
	echo "by %NAME%. Currently it will crash if thre are two .footer files."
	echo "A molecule.qchem file, which contains the \$molecule part of "
	echo "the input is expected in the target folder"
	echo "============================================================="
	echo " Input needed                                                "
	echo "-------------------------------------------------------------"
	echo " 1	template folder                                    "
	echo " 2	target folder                                      "
	echo " 3 	job name 					   "
	echo "============================================================="
	exit
fi

FOLDER_NAME=$2;

rm -f $FOLDER_NAME/*.in
rm -f $FOLDER_NAME/*.slm

cp $FOLDER_NAME/molecule.qchem $FOLDER_NAME'/'$3'.in'
cat $1/*footer >> $FOLDER_NAME'/'$3'.in'

sed "s/%NAME%/$3/g" $1/*slm > $FOLDER_NAME/$3'.slm'



