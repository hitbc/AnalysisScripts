#!/bin/bash

# This script peforms data preprocessing

# Program
#	filter minor allele frequency
#	filter missing rate of genotype
#	filter Hardwinberg equilibrium
#	filter linkage disequilibrium
#	reLD_chr.txt file must local in the input directory
#	heterozygosity_outlier_list.R must local in the input directory
#
# Input
#	We should make sure that the name of input file is <name>.<CHR[num]/CHRall>.vcf.gz
#	$1 is input name of the vcf.gz file
#	$2 is output directory
#	$3 determines whether to conduct WGS [yes/no]
#	Optianl parameter:
#		$4 minor allele frequency (--maf) filtering
#		$5 missing rate of genotype (--gen) filtering
#		$6 Hardweinberg equilibrium (--hwe) filtering
#		$7 Linkage disequilibrium (--idp) filtering with fixed window size of 50 and fixed step size of 10
#		$8 high linkage disequilibrium (--rLD) filtering with a input file
#		$9 determines how many threads to use
#
# Output
#	The output file is a SV file
#		file as <name [String]>.filter.<suffix[vcf/plink]>
#	The output file is a SNP file
#		file as <name [String]>.<chromosome [int]>.filter.<suffix[vcf/plink]>
#	Optional output file
#		
# Example
#	bash filter.sh input.vcf.gz out no --maf0.05 --gen0.01 --rLDreLD_chr.txt --hwe0.000001 --idp0.2 8
#	bash filter.sh input.vcf.gz out yes

# Check if help is requested
if [[ $1 = "-h" ]]; then
	echo -e "\n Usage: filter.sh <vcffile[.gz]> <output directory> <WGS[yes/no]>
			    [optional: <minor allele frequency, --maf[float]]>
				       <missing rate of genotype, --gen[float], default 0.1> 
				       <hardweinberg equilibrium, --hwe[float]> 
				       <linkage disequilibrium, --idp[float]>
  				       <high linkage disequilibrium, --rLD[float, default 0.1]>
				       <threads[int]>, default 1]\n"
	echo -e "Example:\n
	bash filter.sh input.vcf.gz out_1 no --maf0.05 --gen0.01 --rLDreLD_chr.txt --hwe0.000001 --idp0.2 8
	bash filter.sh input.vcf.gz out_2 yes\n"

	echo -e "input Format:\n
	P.S. CHN100K-SNP.CHR12.vcf.gz CHN100K-SV.CHRall.vcf.gz"
	
	exit 0
fi

# Read in the file name
file=$1
file=${file%.vcf.gz}

# set output directory
out_dir=$2

# Set default values
maf=""
geno="0.1"
hwe=""
reLD=""
cutoff=""
thresh="1"
	

# If the vcf file is zipped
gz1=""
gz2=""

if [[ $1 == *"vcf.gz" ]]; then
	gz1="gz"
	gz2=".gz"
	
fi

CHR=`echo $file | cut -d'.' -f2`
#block=`echo $file | cut -d'.' -f3`
prefile=`echo $file | cut -d'.' -f1`
suffile1=""
suffile2=""

# Check if the provided file exists and contains data
if [[ ! -s $file".vcf" ]] && [[ ! -s $file".vcf.gz" ]]
then
	echo -e "\n"$1" not found or empty. Please provide a vcf file with data"
	exit 1
fi

# Set program constant
step=1
tmp=""
value=""
key=""

# Check if more than one argument is provides which ones
if (( "$#" > 3 ))
then
	tmp=$4
	key=${tmp:2:3}
	value=${tmp#--???}
	case $key in
	  maf)
		maf=$value
		;;
	  gen)
		geno=$value
		;;
	  hwe)
		hwe=$value
		;;
	  idp)
		cutoff=$value
		;;
	  rLD)
		reLD=$value
		;;
	  *)
		thresh=$4
		;;
	esac
fi

if (( "$#" > 4 ))
then
	tmp=$5
	key=${tmp:2:3}
	value=${tmp#--???}
	case $key in
	  maf)
		maf=$value
		;;
	  gen)
		geno=$value
		;;
	  hwe)
		hwe=$value
		;;
	  idp)
		cutoff=$value
		;;
	  rLD)
		reLD=$value
		;;
	  *)
		thresh=$5
		;;
	esac
fi

if (( "$#" > 5 ))
then
	tmp=$6
	key=${tmp:2:3}
	value=${tmp#--???}
	case $key in
	  maf)
		maf=$value
		;;
	  gen)
		geno=$value
		;;
	  hwe)
		hwe=$value
		;;
	  idp)
		cutoff=$value
		;;
	  rLD)
		reLD=$value
		;;
	  *)
		thresh=$6
		;;
	esac
fi


if (( "$#" > 6 ))
then
	tmp=$7
	key=${tmp:2:3}
	value=${tmp#--???}
	case $key in
	  maf)
		maf=$value
		;;
	  gen)
		geno=$value
		;;
	  hwe)
		hwe=$value
		;;
	  idp)
		cutoff=$value
		;;
	  rLD)
		reLD=$value
		;;
	  *)
		thresh=$7
		;;
	esac
fi

if (( "$#" > 7 ))
then
	tmp=$8
	key=${tmp:2:3}
	value=${tmp#--???}
	case $key in
	  maf)
		maf=$value
		;;
	  gen)
		geno=$value
		;;
	  hwe)
		hwe=$value
		;;
	  idp)
		cutoff=$value
		;;
	  rLD)
		reLD=$value
		;;
	  *)
		thresh=$8
		;;
	esac
fi


if (( "$#" > 8 ))
then
	tmp=$9
	key=${tmp:2:3}
	value=${tmp#--???}
	case $key in
	  maf)
		maf=$value
		;;
	  gen)
		geno=$value
		;;
	  hwe)
		hwe=$value
		;;
	  idp)
		cutoff=$value
		;;
	  rLD)
		reLD=$value
		;;
	  *)
		thresh=$9
		;;
	esac
fi

if (( "$#" > 9 ))
then
	echo -e "Error: too many arguments provideed"
	echo -e "\n Usage: filter.sh <vcffile[.gz]> <output directory> <WGS[yes/no]>
			    [optional: <minor allele frequency, --maf[float]]>
				       <missing rate of genotype, --gen[float], default 0.1> 
				       <hardweinberg equilibrium, --hwe[float]> 
				       <linkage disequilibrium, --idp[float]>
  				       <high linkage disequilibrium, --rLD[input file]>
				       <threads[int], default 1>"
	exit 1
fi

# Main function
echo "working...."

# step one :filtering
if [ ! -d ${out_dir} ]; then
	mkdir ${out_dir}
fi
cd ${out_dir}

echo "step one: plink convert vcf file to ped file and filtering variants ......."
if [ "$maf" != "" ]
then
	if [ "$reLD" != "" ]
	then
		if [ "$hwe" != "" ]
		then
			plink --vcf ../$1 --maf ${maf} --geno ${geno} --hwe ${hwe} --exclude range ../${reLD} --const-fid --recode --out ${file}
		else
			plink --vcf ../$1 --maf ${maf} --geno ${geno} --exclude range ../${reLD} --const-fid --recode --out ${file}
		fi		
	else
		plink --vcf ../$1 --maf ${maf} --geno ${geno} --const-fid --recode --out ${file}
	fi
else
	plink --vcf ../$1 --const-fid --recode --out ${file}
fi

if [ "$cutoff" != "" ]
then
	plink --file ${file} --indep-pairwise 50 10 ${cutoff} --make-bed --out ${file}
	plink --bfile ${file} --extract ${file}.prune.in --make-bed --out ${file}.final
	
else
	plink --file ${file} --make-bed --out ${file}.final 	
fi
	
if [ "${3}" = "yes" ] 
then
	echo "doing heterozygisty outlier and relationship removing"
	plink --vcf ../$1 --const-fid --recode --out ${file}
	plink --file ${file} --make-bed --out ${file}

	plink --bfile ${file} -het --out R_check
	Rscript --no-save ../heterozygosity_outliers_list.R
	sed 's/"// g' fail-het-qc.txt | awk '{print$1, $2}'> het_fail_ind.txt
	plink --bfile ${file} --remove het_fail_ind.txt --make-bed --out tmp1

	plink --bfile tmp1 --filter-founders --make-bed --out tmp2
	plink --bfile tmp2 --genome --min 0.2 --out pihat_min0.2_in_founders
	cat pihat_min0.2_in_founders.genome |grep -v "FID1" |awk '{print $1 "\t" $2}'| sort -u > 0.2_low_call_rate_pihat.txt
	plink --bfile tmp2 --remove 0.2_low_call_rate_pihat.txt --make-bed --out result
	
	awk '{print $2}' result.fam > samples.id
	vcftools --gzvcf ../${file}.vcf.gz --keep samples.id --recode --recode-INFO-all --stdout |bgzip -c > ${file}.wgs.vcf.gz
else
	awk '{print $2}' ${file}.final.bim > ${file}.snpID
	vcftools --gzvcf ../$1 --snps ${file}.snpID --recode --recode-INFO-all --stdout |bgzip -c > ${file}.final.vcf.gz
fi

# Ending
echo -e "parameter 1:"$1""
echo -e "parameter 2:"$2""
echo -e "parameter 3:"$3""
echo -e "parameter 4:"$4""
echo -e "parameter 5:"$5""
echo -e "parameter 6:"$6""
echo -e "parameter 7:"$7""
echo -e "parameter 8:"$8""
echo -e "parameter 9:"$9""
echo -e "parameter 10:"${10}""
echo -e "parameter 11:"${11}""

echo -e "maf: "$maf"\ngeno: "$geno"\nhwe: "$hwe"\nidp: "$cutoff"\nhigh region: "$reLD"\ncryptic: "$related"\nheterozygosity: "$heter"\nthreads: "$thresh""
echo -e "File name is : "$file""

echo -e "\n *********************** Ending ****************************"





