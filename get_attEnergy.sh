#!/bin/sh

awk '/Total energy in/ {prinnt $8}; /Total energy for/ {print $6}' $1
