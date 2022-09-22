#!/bin/bash

# This script performs admixture progranm
# Program
# 	admixture program
#
# Input
#	$1 is the input file name
#	$2 is the number of K
#	$3 is the the number of thread
#
# Output
# 	.Q file indicates the proportion of ancestors of individuals
#	.P file indicates the proportion of variations of individuals
# 
# Example
#	bash ADMXITURE.sh CHN100K-snp.wgs.bed 3 32
#	for i in $(seq 3 12); do bash ADMIXTURE.sh input.bed ${i} 32; done

file=$1
K=$2
threads=$3

echo -e "We need to create the output folder in advance and run ADMIXTURE.sh in this direcotory"

if [[ $1 = "-h" ]]
then
	echo -e "\n Usage: ADMIXTURE.sh <input.bed> <K> <threads>"
	echo -e "Example:\nbash ADMXITURE.sh CHN100K-snp.wgs.bed 3 32\n"
	exit 0
fi

admixture --cv -j${threads} ${file} ${K}| tee log${K}.out
echo END"" 

# END
