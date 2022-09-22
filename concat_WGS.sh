#!/bin/bash

# This script concat 1-22 chromosome to a whole genome sequence
# Program
# 	First, we record the name of 1-22 chromosome in the same directory
#	Last, we merge all chromosomes to a wgs
#
# Input
#	$1 is the prefix of input file name
#	$2 is the output directory
#	$3 is the the number of thread
#
# Output
# 	The output vcf file is a wgs
# 
# Example
#	bash concat concat_wgs.sh CHN100K.missingtoref out_1 8 

file=$1
directory=$2
threads=$3
mergefile=wgs.concat.txt

echo -e "Your need to make sure that the format of input file is right"

if [ ! -d ${directory} ]
then
        mkdir ${directory}
fi

if [ -f ${mergefile} ] ;then rm ${mergefile} ;fi

for i in $(seq 1 22) ;do echo "${file}.chr${i}.final.vcf.gz" >> ${mergefile} ;done

bcftools concat -a -D -f ${mergefile} -Oz -o ./${directory}/${file}.chrall.final.vcf.gz --threads ${threads} 

mv ${mergefile} ./${directory}

# END
