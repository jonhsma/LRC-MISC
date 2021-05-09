#!/bin/sh

# If no file is specified
if [ -z "$1" ]
then
	echo "No input file specified. Script will be terminated"
	echo "Usage:"
	echo "SpInputFromRealx.sh [opt output file] [method for scf] [basis for scf]"
	echo "To specify basis, the mothod has to be specified"
	exit -1
fi

# The calculation method
if [ -z "$2" ]
then
	echo "Method not specified. Default to pbe0"
	METHOD=pbe0
else
	METHOD=$2
fi

# The basis
if [ -z "$3" ]
then
	echo "Basis for SCF not specified, Defaulted to cc-pVTZ"
	BASIS=cc-pVTZ
else
	BASIS=$3
fi


#Creating the input file
echo '$molecule'
awk '/molecule/{getline; print$0}' $1|head -1
sed '0,/OPTIMIZATION CONVERGED/d' $1|sed '/Z-matrix/q'|\
sed '1,4d;$d;/^$/d'|awk '{$1="";print$0}'
echo '$end'
echo '$rem'
echo 'jobtype		sp'
echo "basis		$BASIS"
echo "METHOD		$METHOD"

cat <<EOF
MAX_SCF_CYCLES		100
SCF_CONVERGENCE		6
SCF_GUESS		read
MOM_START		1
EOF

sed -ne '/\$occupied/,$ p' $1|\
sed '/$end/q'
echo '$end'
