#!/bin/sh

if [ -z $1 ]
then
	echo " Only argument: Path of output of relaxation calculation "
	exit
fi


TEXT=`tac $1| sed '/OPTIMIZATION CONVERGED/,$d' |tac|sed '1,4d;/Z-matrix/,$d'|\
 tac|sed '1,1d'|tac|\
 awk '{for(i=2;i<=5;i++) printf$i"\t";print ""}'`

wc -l << EOF 
$TEXT
EOF

echo $(pwd)/$1
printf "$TEXT\n"

