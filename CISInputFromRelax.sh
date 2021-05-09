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
!SCF SETTINGS
MAX_SCF_CYCLES		1024
SCF_CONVERGENCE		8
UNRESTRICTED 		TRUE
GUI			2
!CIS SETTINGS
MAX_CIS_CYCLES		400
CIS_N_ROOTS		40
CIS_SINGLETS		TRUE
CIS_TRIPLETS		FALSE
!MOMERY SETTINGS 
!-----FOR MPI (-np) DISTRIBUTED MEMORY ON 4 ETNA NODES-----
MEM_TOTAL		200000 ! 200 GB for 4 nodes (Only 64 GB on a single node)
MEM_STATIC 		2000
EOF

echo '$end'
