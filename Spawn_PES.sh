#!/bin/sh

# Create the headers
mkdir geom
module load python
python headerGen.py

LENGTH=`ls geom| wc -l`

for ((i=1; i<=$LENGTH; i++))
do
	CURR_FOLDER="STEP_`printf '%04d' $i`"
	mkdir $CURR_FOLDER
	cat "`printf 'geom/iter%04d.xyz' $i`" >> $CURR_FOLDER/qchem.in
	cat prototype.footer >> $CURR_FOLDER/qchem.in
	cp prototype.slm $CURR_FOLDER/PES.slm
	cd $CURR_FOLDER
	sbatch PES.slm
	cd ..
done
