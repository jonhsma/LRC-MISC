#!/bin/sh

if [ -z $1 ]
then
	echo " Only argument: Path of output of relaxation calculation "
	exit
fi


# Get the charge and degeneracy
QZ=$(awk '/$molecule/ {getline;print$0}' $1)

TEXT=`tac $1| sed '/OPTIMIZATION CONVERGED/,$d' |tac|sed '1,4d;/Z-matrix/,$d'|\
 tac|sed '1,1d'|tac|\
 awk '{for(i=2;i<=5;i++) printf$i"\t";print ""}'`

# encode the number of atoms and source
echo "\$comment"

wc -l << EOF 
$TEXT

EOF
echo $(pwd)/$1

echo "\$end"

echo "\$molecule"
echo $QZ
printf "$TEXT\n"
echo "\$end"

