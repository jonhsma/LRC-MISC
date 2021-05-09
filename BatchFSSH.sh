#!/bin/sh

# If no architype folder is specified
if [ -z "$2" ]
then
	echo 	""
	echo	"---------------------------------"
	echo 	"No input specified. Help message:"
	echo 	"---------------------------------"
	echo 	""
	echo	"Syntax:"
	echo 	" batch_run [architype folder] [# of calclation] [# of node] [cluster] [MP/MPI argument]"
	echo 	""
	echo 	"-There should be two files in the architype folder"
	echo -e	"\t prototype.in"
	echo -e	"\t prototype.slm"
	echo 	" and they should have appropriate place holders for the substitution scripts to work"
	echo 	"-The default number of node is 1"
	echo 	"-Cluster/partition settings"
	echo -e	"\t If a cluster is specified, then the number of nodes and MP/MPI arguments are required"
	echo -e	"\t The default cluster is nano."
	echo -e	" \t\t If one node is used, OpenMP(shared memory) is used"
	echo -e	" \t\t If mltiple nodes are used, MPI(distributed memory) is used"
	echo -e " \t Defaults are used when there are less than 5 input parameters"
	exit -1
fi

# Number of nodes
if [ -z "$3" ]
then
	N_NODE=1
else
	N_NODE=$3
fi

# Cluster configuration
if [ -z "$5" ]
then
	echo "Using automatic cluster configurations"
	CLUSTER='nano1'
	if [ $N_NODE==1 ]
	then
		N_TASK=8		
	else
		N_TASK=`expr N_NODE\*8`
		MP_CONFIG="-np $NP"
	fi

	MP_CONFIG="-np $N_TASK"	

	echo "Resorting to defaults $CLUSTER $MP_CONFIG"
else	
	CLUSTER=$4

	NP1=`echo $5 | awk '{print $4}'`
	NP2=`echo $5 | awk '{print $2}'`

	# If it's OpenMP or MPI only
	if [ -z "$NP1" ]
	then
		NP1=1
	fi
	
	# Total number of tasks
	N_TASK=`expr $NP1 \* $NP2`

	MP_CONFIG=$5
fi

#The loop
for i in `seq 1 $2`
do
	DIR="Iteration-`printf '%05d' $i`"
	mkdir $DIR

	cp $1/prototype.in $DIR/input.in
	sed "s/\%CLUSTER\%/$CLUSTER/g; s/\%N_NODE\%/$N_NODE/g; s/\%MP_CONFIG\%/$MP_CONFIG/g; s/\%N_TASK\%/$N_TASK/g"\
	$1/prototype.slm > $DIR/traj.slm

	cd $DIR
	pwd
	sbatch traj.slm
	cd ../
done
