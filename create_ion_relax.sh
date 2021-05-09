#!/bin/sh

SPECIES=('Br2' 'CH3Br' 'CF3Br')
HOLE3D=(19 11 14)
OTOTAL=(35 22 34)

if [ -z "$1"]
then
	echo "No method specified. Use pbe by default"
 	METHOD=pbe
else
	METHOD=$1
fi

# create a temporary file
touch temp
rm temp

for i in `seq 0 2`
do

j=`expr ${HOLE3D[$i]} - 1`
k=`expr ${HOLE3D[$i]} + 1`
l=`expr ${OTOTAL[$i]}`

sed "s/sp/opt/I; s/METHOD.*/METHOD\t\t$METHOD/I; s/0 1/+1 2/; s/MAX_CIS_CYCLES/MAX_SCF_CYCLES/; /DIRECT_SCF/d" neu${SPECIES[$i]}.relax.pbe0-ccpVDZ.in > temp
cat>> temp  <<EOF

\$occupied
1:$l
1:$j $k:$l
\$end
EOF

cat temp
mv temp 3d${SPECIES[$i]}.relax.$METHOD-ccpVDZ.in
done
