#!/bin/bash

# This script can merge the VCF format files of chromosomes divided into blocks by region into a complete VCF file of chromosomes
# Program
# 	First, we record the name of block belonging to the same chromosome to a file
#	Last, we merge blocks belonging to the same chromosome
#
# Input
#	$1 is the prefix of input file name
#	$2 is the number of chromosome
#	$3 is the output file name
#	$4 is the output directory
#	$5 is the the number of thread
#
# Output
# 	Completed chromosome
# 
# Example
#	bash concat concat_single_chr.sh testfile-missing chr9 CHR9 CHROMOSOME 8 
#	for k in $(seq 1 22); do bash concat_single_chr.sh testfile-missing chr${k} CHR${k} test; done

file=$1
chr=$2
output=$3
directory=$4
threads=$5

### Step one
echo -e "Your need to make sure that the format of input file is right"
ls -lh ${file}.${chr}.* |cut -d" " -f9 |sort -t. -k3 -n > ${chr}.txt

### Step two
for i in $(cat ${chr}.txt)
do
	bcftools index -t ${i}
done

bcftools concat -a -D -f ${chr}.txt -Oz -o ${output}.vcf.gz --threads ${theads}

if [ ! -d ${directory} ]
then
        mkdir ${directory}
fi
mv ${output}.vcf.gz ./${directory}

