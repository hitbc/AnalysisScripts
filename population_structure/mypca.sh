#!/bin/bash

# This script performs pca progranm
# Program
# 	pca program
#
# Input
#	$1 is the prefix of input file
#	$2 is the name of parameter file
#
# Output
#	pca.evec is eigenvector
#	pca.eval is eigenvalues 
# Example
#	bash pca.sh convert.par/pca.par 

file=$1

echo -e "Your should make sure that the input file locate in the same direcroty and your need mkdir a new file"
if [[ $1 = "-h" ]]
then
	echo -e "Second beta"
	echo -e "You should put the convert.par in the current direcotry and put the pca.par in the current directory of pca"
	echo -e "\n Usage: pca.sh CHN100K-SNP <convert.par/pca.par>"
	echo -e "Example:\nbash pca.sh convert.par/pca.par"
	exit 0
fi

# Prepare the map file 
if [ ! -f ${file}.map ]
then
	echo "${file}.map not exit"
	cat ${file}.bim |awk '{print $1"\t"$2"\t"$3"\t"$4}' > ${file}.map
fi

# Perform convert or pca
if [ $2 = "convert.par" ]
then
	convertf -p $2
	cd pca
	test -f pca.par && smartpca -p pca.par || exit 0
else
	smartpca -p $2
fi

echo END"" 

# END
