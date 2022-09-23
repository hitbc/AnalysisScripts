# Population structure

### concat_single_chr.sh
	This script can merge the VCF format files of chromosomes divided into blocks by region into a complete VCF file of chromosomes.
	
	Example: for k in $(seq 1 22); do bash concat_single_chr.sh testfile-missing chr${k} CHR${k} test; done

### standard.sh
	This script can standardize vcf file, thus reducing the storage consumption and improving the running speed. It mainly implements the follow opeartions:
	1) modify INFO threshold and FORMAT threashold
	2) eliminate multiple alleles
	3) delete indels with too long length
	
	Example: bash standard.sh test.chr12.vcf.gz out_dir bia sta ind 8

### filter.sh
	This script peforms data preprocessing. It can do following functions:
	1) filter minor allele frequency 
	2) filter missing rate of genotype
	3) filter Hardwinberg equilibrium
	4) filter linkage disequilibrium
	5) Eliminate relatives and high heterozygosity individuals
	
	Example: bash filter.sh input.vcf.gz out no --maf0.05 --gen0.01 --rLDreLD_chr.txt --hwe0.000001 --idp0.2 8
      		 bash filter.sh input.vcf.gz out yes

### concat_WGS.sh
	This script concat 1-22 chromosome to a whole genome sequence.
	
	Example: bash concat concat_wgs.sh CHN100K.missingtoref out_1 8
### ADMIXTURE.sh
	We use the admixture software to conduct hypothetical ancestral analysis of the population. This can be done by ADMIXTURE.sh.
	
	Example: for i in $(seq 3 12); do bash ADMIXTURE.sh input.bed ${i} 8; done
### mypca.sh
	We use the Eigensoft software to conduct principal component analysis. This can be done by mypca.sh with tow configuration files convert.par and pca.par.
	
	Example: bash pca.sh convert.par/pca.pa

### effective_pop.sh
	To comprehend the demographic history, we inferred the effective population size of the populations distributed in three major regions of China: North, South, and Tibet with SMC++. After preprocessing the data, for each population, we used SMC++ (v 1.15.3) to convert the format of the VCF files, and estimate the history of effective population size as recommended by the authors of SMC++. Finally, we plot the results with the plot function within SMC++.
