#!/bin/sh


if [ -z $2 ]
then
	PATTERN='*_*_*out'
else
	PATTERN=$2
fi

touch temp
printf " Folder, High-precision SCF energy (a.u.), ZPE (kcal/mol), Enthalpy (kcal/mol), Entropy (cal/mol/K)\n" > temp 

for ii in $(ls -d *_*_*); do printf "%s,%s,%s,%s,%s\n"\
 $ii\
 $(tac $ii/$PATTERN | sed '/Running Job/,$d' | tac | awk '/Total energy/ {print $9}')' '\
 $(awk '/Zero point/{print$5}' $ii/$PATTERN)' '\
 $(awk '/Total Enthalpy/{print $3}' $ii/$PATTERN)' '\
 $(awk '/Total Entropy/{print $3}' $ii/$PATTERN)' '\
 >> temp; 

 #tac $ii/$PATTERN | sed '/TZVPD/,$d' | tac 

done

sed -i '/sed/d' temp
sed -i '/awk/d' temp

cat temp

if [ -z $1 ] 
then
	rm temp
else 
	mv temp $1
fi
