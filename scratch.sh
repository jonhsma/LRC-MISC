#!/bin/sh

for i in `seq 1 50`
do
	VAR_TEST="This is the prefix `printf '%7d' $i` and this is the suffix"
	echo 	$VAR_TEST
done
