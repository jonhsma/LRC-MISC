#!/bin/sh
sed '0,/OPTIMIZATION CONVERGED/d' $1|sed '/Z-matrix/q'|\
sed '1,4d;$d;/^$/d'|awk '{$1="";print$0}'

