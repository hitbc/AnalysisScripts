#!/bin/bash

# This script can standardize vcf file, thus reducing the storage consumption and improving the running speed.
# Program
#	Modify INFO threshold and FORMAT threshold
#	Eliminate multiple alleles
#	Delete indels with too long length
#
# Input
#	$1 is input name of the vcf.gz file
#	$2 is output directory
#	$3 standardized file format and adds a name to variants
#	$4 convert multiple alleles to bi-alleles
#	$5 retain indels with length less than 5bp
#	$6 is threads
#
# Output
#	Standardization file as <name [String]>.<chromosome [int]>.<block [int]>.<step [int]>.vcf.gz
#
# Example
#	bash standard.sh test.chr12.vcf.gz out_dir bia sta ind 8
#

# Read in the file name
file=$1

# set output directory
out_dir=$2

# Set default values
biallele="false"
standard="false"
indels="false"
threads=1
step=1

# If the vcf file is zipped
gz1=""
gz2=""
vcf1="vcf"
vcf2=".vcf"

if [[ $1 == *"vcf.gz" ]]; then
	gz1="gz"
	gz2=".gz"
	file=${file%.gz}
	file=${file%.vcf}
	
fi

if [[ $1 == *"vcf" ]]; then
	vcf1="vcf"
	vcf2=".vcf"
	file=${file%.vcf}
fi

CHR=`echo $file | cut -d'.' -f2`
block=`echo $file | cut -d'.' -f3`
prefile=`echo $file | cut -d'.' -f1`
suffile1=""
suffile2=""

# Check if the provided file exists and contains data
if [[ ! -s $file".vcf" ]] && [[ ! -s $file".vcf.gz" ]]
then
	echo -e "\n"$1" not found or empty. Please provide a vcf file with data"
	exit 1
fi

# Check if more than one argument is provides which ones
if (( "$#" > 5 ))
then
	case $6 in
	  bia)
		biallele="true"
		;;
	  sta)
		standard="true"
		;;
	  ind)
		indels="true"
		;;
	  *)
		thresh=$6
		;;
	esac
fi

if (( "$#" > 6 ))
then
	echo -e "Error: too many arguments provideed"
	echo -e "\n Usage: standard.sh <vcffile[.gz]> <output[.vcf.gz]>
			    [optional: <biallele bia, default false> 
				       <standard sta, default false>
  				       <indels ind, default false>
				       <threads[int]>, default false]"
	exit 1
fi

# Main function
echo "working...."

# step one :filtering
if [ ! -d ${out_dir} ]; then
	mkdir ${out_dir}
fi
cd ${out_dir}

if [ "$standard" = "true" ]
then
	input=$step
	((output=step+1))
	if [ "$step" = 1 ]
	then
		input_file=../${file}
		if [ "$gz1" = "gz" ]
		then
			suffile1=${vcf1}.${gz1}
			suffile2=${vcf2}.${gz2}
		else
			suffile1=$vcf1
			suffile2=$vcf2
			gz1="gz"
			gz2=".gz"
		fi
	else
		input_file=${file}.${input}
		suffile1=${vcf1}.${gz1}
		suffile2=${vcf2}.${gz2}
	fi
	
	
	echo -e "standarzing"
	bcftools annotate --set-id +'%CHROM\_%POS\_%REF\_%FIRST_ALT' -x ^INFO/AC,^INFO/AN,^FORMAT/GT ${input_file}.${suffile1} -Oz -o ${file}.${output}.vcf.gz --threads ${threads}
	step=${output}
	echo -e "input_file:${input_file}\tstep:${input}\toutput:${output}"
fi

if [ "$biallele" = "true" ]
then
	input=$step
	((output=step+1))
	if [ "$step" = 1 ]
	then
		input_file=../${file}
		if [ "$gz1" = "gz" ]
		then
			suffile1=${vcf1}.${gz1}
			suffile2=${vcf2}.${gz2}
		else
			suffile1=$vcf1
			suffile2=$vcf2
			gz1="gz"
			gz2=".gz"
		fi
	else
		input_file=${file}.${input}
		suffile1=${vcf1}.${gz1}
		suffile2=${vcf2}.${gz2}
	fi

	echo -e "transforming to biallele"
	bcftools view ${input_file}.${suffile1} -m2 -M2 -Oz -o ${file}.${output}.vcf.gz --threads ${threads}
	step=${output}
	echo -e "input_file:${input_file}\tstep:${input}\toutput:${output}"
fi

if [ "$indels" = "true" ]
then
	input=$step
	((output=step+1))
	if [ "$step" = 1 ]
	then
		input_file=../${file}
		if [ "$gz1" = "gz" ]
		then
			suffile1=${vcf1}.${gz1}
			suffile2=${vcf2}.${gz2}
		else
			suffile1=$vcf1
			suffile2=$vcf2
			gz1="gz"
			gz2=".gz"
		fi
	else
		input_file=${file}.${input}
		suffile1=${vcf1}.${gz1}
		suffile2=${vcf2}.${gz2}
	fi

	echo -e "remove indels with length more than 5bp"
	cat <(bcftools view -h ${input_file}.${suffile1}) <(bcftools view -H ${input_file}.${suffile1} |awk '{if(length($4)<5&&length($5)<5){print $0}}') | bgzip -c > ${file}.${output}.vcf.gz
	step=${output}
	echo -e "input_file:${input_file}\tstep:${input}\toutput:${output}"
fi

mv ${file}.${output}.vcf.gz ${prefile}.${CHR}.${block}.nor.vcf.gz

echo -e "\n Ending"


