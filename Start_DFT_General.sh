#!/bin/sh

# This is a general DFT subtraction base EA calculation script generator
# build the input file

if [ -z $4 ]
then
	printf "===========================================================\n"
	printf "= This is a genearic batch DFT calculations initiator     =\n"
	printf "= All 4 arguments must be present and in order            =\n"
	printf "= 1 | path of the .xyz file                               =\n"
	printf "= 2 | functional                                          =\n"
	printf "= 3 | basis                                               =\n"
	printf "= 4 | output directory                                    =\n"
	printf "= 5 | Optional: the name of the footer,                   =\n"
	printf "=   | defaulted to in.footer                              =\n" 
	printf "===========================================================\n"
	printf "= Also, prototype.slm                                     =\n"
	printf "= is required for this script to function properly        =\n"
	printf "===========================================================\n"
	exit
fi


# Check if footer exists. If not assume that arg 5 is an instruction to not start the calculation
if [ -z $5 ]
then
	QC_INIT=1
	FOOTER='in.footer'
else
	TEMP=`ls $5`
	if [ -z $TEMP ]
	then
		QC_INIT=0;
		FOOTER='in.footer'
	else
		FOOTER=$5
		if [ -z $6 ]
		then
			QC_INIT=1
		else
			QC_INIT=0
		fi
	fi
fi



mkdir -p $4

FILE_NAME=$2.$3
FULL_FILE_PATH=$4/$2.$3
MOLECULE_PATH=$1

printf "\$molecule \n 0 1\n" > "$FULL_FILE_PATH.in"
sed '1,2d' $MOLECULE_PATH >> "$FULL_FILE_PATH.in"
printf "\$end\n" >> "$FULL_FILE_PATH.in"
sed "s/_FUNCTIONAL_/$2/;s/_BASIS_/$3/" $FOOTER >> "$FULL_FILE_PATH.in"

# build the batch file
sed "s/_NAME_IN_/$FILE_NAME.in/;s/_NAME_OUT_/$FILE_NAME.out/;" prototype.slm > "$4/$2.$3.slm"


# run the calculation
if [ $QC_INIT == 1 ]
then
	cd $4
	sbatch $2.$3.slm
	cd ..
fi
