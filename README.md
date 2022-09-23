# AnalysisScripts

The repository was created to present the workflow for the large scale whole genome sequencing data analysis including software, command and in-house scripts, which were eaxctly used in "A comprehensive genetic variant reference for the Chinese population from the whole-genome sequencing of 25,734 individuals". For more advising, and help requiring, please contact tjiang@hit.edu.cn.

## Alignment 
Alignment  Pipeline scripts  are available in the WGS_Pipeline directory.
+ 1. alignment.sh
   - S01 bwa_mem_pipe
      * BWA_MEM : Mapping DNA sequences against ref_grch38; Sambamba for sort and processing of NGS alignment formats;  Samblaster for duplicate marking.
   - S02 picard_merge_sam_files
      * Picard : Merging multiple SAM and/or BAM files into a single file. If there is only one readset, skip this step.
   - S03 gatk4_recalibration_by_chr
      * GATK4-BaseRecalibrator: Base quality score recalibration.
+ 2. qc.sh
    - S01 fastqc_qc
      * FastQC: Quality control checks on raw sequence data coming from high throughput sequencing pipelines.
    - S02 qualimap_bamqc
      * Qualimap :Quality control of alignment sequencing data.
    - S03 verify_bam_id
      * VerifyBamID2 : Detecting and estimating inter-sample DNA contamination.

Long-reads Alignment Pipeline scripts ara available in ONT_Pipeline directory
+ 1. QC.sh
  - S01 Base calling using guppy
    * Guppy: Basecalling,filtering of low quality reads and clippiing of Oxford Nanopore adapters.
+ 2. Mmosdepth: Fast BAM/CRAM depth calculation tools for types of sequencing. 
  - S01 mapping reads to reference genome usign minimap2
    * minimap2: Sequence alignment program that aligns DNA or mRNA sequences against a large reference database. 
  - S02 evaluation of mapping quality using nanoplot
    * NanoPlot: Plotting tool for long read sequencing data and alignment.
  - S03 Calculating the depth per chromosome using mosdepth
    * 



## Variant Calling based on short-reads
Variant Calling  Pipeline scripts  are available in the WGS_Pipeline directory.
+ 1. variant_call.sh
    - S01 gatk4_haplotype_caller_family
      * GATK4-HaplotypeCaller: Call germline SNPs and indels. 
    - S02 manta
      * Manta : Call Structural variation.
    - S03 cnvnator
      * Cnvnator : CNV discovery and genotyping from depth-of-coverage by mapped reads.
    - S04 smoove
      * Smoove : Calling and genotyping SVs for short reads. It also improves specificity by removing many spurious alignment signals that are indicative of low-level noise and often contribute to spurious calls.
+ 2. snp_indel_joint_call.sh
    - S01 gatk4_GenomicsDBImport
      * GATK4-GenomicsDBImport : Import single-sample GVCFs into GenomicsDB before joint genotyping. 
    - S02 gatk_DBImport_genotype
      * GATK4-GenotypeGVCFs : Perform joint genotyping on one or more samples pre-called.
    - S03 gatk_gather_vcf
      * GATK4-GatherVcfs : Gathers multiple VCF files from a scatter operation into a single VCF file.
    - S04 gatk_vqsr
      * GATK4-VariantRecalibrator : Build a recalibration model to score variant quality for filtering purposes; GATK4-ApplyVQSR : Apply a score cutoff to filter variants based on a recalibration table.
    - S05 cohort_vcf_normalize
      * bcftools-norm : Left-align and normalize indels, check if REF alleles match the reference, split multiallelic sites into multiple rows; recover multiallelics from multiple rows.
    - S06 hwe_missing_rate
      * vcftools filter: --hwe option: Assesses sites for Hardy-Weinberg Equilibrium using an exact test; --max-missing : Exclude sites on the basis of the proportion of missing data.
    - S07 shapeit4
      * shapeit: estimation of haplotypes from genotype or sequencing data.
+ 3.sv_joint_call: Follow <https://github.com/hall-lab/sv-pipeline>


## Variant Calling based on long-reads
Variant Calling Pipeline scripts are available in the ONT_Pipeline directory.
+ VariantCalling.sh
  - S01 variant call using sniffles
    * Sniffles: A fast structural variant caller for long-read sequencing.
  - S02 variant call using cuteSV
    * cuteSV: A sensitive, fast and scalable long-read-based SV detection approach.
  - S03 variant call using svim
    * SVIM: A structural variant caller for third-generation sequencing reads.
  - S04 variant call using nanovar
    * NanoVar: A genomic structural variant caller that utilizes low-depth long-read sequencing.
  - S05 self defined script for filter variants
    * Self definded script: Filtering variants based on depth.
  - S06 vcf merging by SURVIOR
    * SURVIVOR: A tool set for merging and comparing SVs.
  - S07 force calling using cuteSV
    * cuteSV: In this step, cuteSV is used for forcecalling.
  - S08 merge the force called varians using SURVIVOR
    * SURVIVOR: Merging the SV vcfs.



## Functional Annotation

### Download Dataset
#### 1. AnnoVar Datasets
Some datasets we need for annotation are already included in AnnoVar, we can download them via its download script provided by AnnoVar.
Example: `perl annotate_variation.pl -downdb -webfrom annovar -buildver hg38 refGene humandb/`  
Datasets downloaded by this way: refGene, exac03, dbnsfp41c, intervar_20180118, 1000g2015aug, avsnp150, etc.
#### 2. CADD Datasets
CADD datasets can be downloaded via its download page at https://cadd.gs.washington.edu/download.  
It should be noted that the dataset files for different genome builds with the same release version have different annotaion items.  
We used both GRCh37 and GRCh38 datasets of release v1.6.
#### 3. UCSC Datasets
UCSC datasets could be downloaded via its FTP site at <ftp://hgdownload.soe.ucsc.edu/goldenPath>.  
Datasets downloaded by this way: phastCons20way, phastCons100way, phyloP20way, phyloP100way, etc.
#### 4. Ensembl Dataset
Ensembl dataset could be found and downloaded via its FTP site at <ftp://ftp.ensembl.org/pub>.

### LiftOver
Some datasets in build GRCh37 need to be converted into build GRCh38 via liftover.  
Usage: `liftOver oldFile map.chain newFile unMapped`

### Convert datasets into avinput format
Avinput format file is the standard input file for AnnoVar, datasets downloaded via AnnoVar all in this format. Insertion and deletion variants were specially processed in this format which cannot be reconverted. In this case, we need to convert all datasets into avinput format via the convert script provided by AnnoVar.  
Example: `perl convert2annovar.pl -format vcf4 variantfile > variant.avinput`

### Indexing datasets for VarNote annotation
All datasets besides gene-based datasets(e.g. refGene) will be used in VarNote annotation procedure, which means that they need to be properly indexed.
Example:
```
bgzip hg38_exac03.txt  
java -jar VarNote-1.1.0.jar Index -I:tab,c=1,b=2,e=3,ref=4,alt=5 hg38_exac03.txt.gz
```

### Annotation
#### 1. Convert Format
All datasets have been processed into avinput format. For consistency, we need to convert input vcf file into avinput format for further annotation as well. This can also be done through the AnnoVar script.  
Example: `perl convert2annovar.pl -format vcf4 example.vcf > example.avinput`
#### 2. AnnoVar Annotation
We use AnnoVar for gene-based annotation, typically refGene.  
Example: `perl table_annovar.pl example.avinput humandb/ -buildver hg38 -out example -protocol refGene -operation g -nastring . -remove`
#### 3. VarNote Annotation
We use VarNote for filter-based and region-based annotation. Considering the large number of datasets involved, we use the configuration file to specify the name of the annotation item.  
Example: `java -jar VarNote-1.1.0.jar Annotation -Q:tab,c=1,b=2,e=3,ref=4,alt=5 example.avinput -D:db,tag=exac03,mode=1 hg38_exac03.txt.gz -D:db,tag=cage_enhancers,mode=0 hg38_cage_enhancers.bed.gz -O example -OF BED -T 16 -A example.cfg -Z False -loj True -MVL 500`
#### 4. AnnotSV Annotation
We use AnnotSV for structural variant annotation, the dependent datasets should be downloaded during the installation.  
Example:`AnnotSV -SVinputFile example.vcf  -genomeBuild GRCh38 -outputFile example.annotsv.out  -SVminSize 30`



## Population genetic analysis
For detailed information, please refer [here](https://github.com/hitbc/AnalysisScripts/blob/main/population_structure/README.md).



## Statistical Analysis
For detailed information, please refer [here](https://github.com/hitbc/AnalysisScripts/blob/main/AnnotationStatistics/README.md). 



## Reference panel construction and imputation performing
### Population-based VCF quality control and filtering
We first removed all the variants and samples with a missing call rate over 5% , and the variants with Hardy-Weinberg equilibrium (HWE) p < 10-6 using Plink.

```
plink --vcf Original.vcf.gz --geno 0.05 --hwe 1e-6 --const-fid --recode --out ptest
```

Second, we reserved all the variants with AC > 1 and singletons included in commonly used genetype arrays.

Third, we recalculated the allele frequence for variants using `bcftools +fill-tags` and extracted all SNPs using `bcftools view` to generate the final callset for the construction of reference panel.

### Chinese reference panel construction using Minimac3
We used the final callset to establish the reference panel, and Minimac3 was adopted to convert the reference panel into M3VCF format file. Each chromosome was constructed separately as following (chr2 for example)"

```
Minimac3 --refHaps Chinese.final.vcf.gz --processReference --prefix chn.panel --cpus 30 --chr chr2
```

### Construction of combined (Our and 1KGP3) reference panel
We combined our panel and 1KGP3 reference panels by employing the reciprocal imputation approach with Minimac4. In detail, we first imputed 1KGP variants using our reference panel and imputed our variants using 1KGP reference panel respectively. And then merge the two imputed VCF files into the combined VCF file and convert to M3VCF format file after removing incompatible alleles. The commands we used as follows.

```
minimac4 --refHaps chn.panel.m3vcf.gz --haps 1KGP3.vcf.gz --prefix our_impute_1KGP3 --format GT,DS,GP --mapFile $geneticMAP –ignoreDuplicates
minimac4 --refHaps 1KGP3.m3vcf.gz --haps chn.final.vcf.gz --prefix 1KGP3_impute_our --format GT,DS,GP --mapFile $geneticMAP –ignoreDuplicates
bcftools merge our_impute_1KGP3.dose.vcf.gz 1KGP3_impute_our.dose.vcf.gz -Oz -o $combined.vcf.gz
Minimac3 --refHap combined.vcf.gz --processReference --prefix combined.panel
```

### Genotype imputation using different reference panels
#### Pseudo-GWAS dataset generation for impuation
We used the genotype data from 143 individuals from 16 Chinese populations included in the Human Genome Diversity Project (HGDP) as prebuilt pseudo-GWAS dataset([HGDP samples](https://www.internationalgenome.org/data-portal/data-collection/hgdp)). We extracted all variants with consistent alleles in the pseudo-GWAS dataset and all compared panels. Then we randomly masked one-tenth of the SNVs, and these masked SNVs were used to evaluate imputation accuracy. (We take Our panel and 1KGP3 panel as example)

```
bcftools isec -w 1 -n =2 -p isec chn.final.vcf.gz 1KGP3.vcf.gz --threads 8
cat <(cat isec/0000.vcf | grep "^#") <(cat isec/0000.vcf | grep -vE "^#" | awk '{if(NR % 10 != 1) print $0}') | bgzip -c > isec/target.vcf.gz
tabix isec/target.vcf.gz
cat <(cat isec/0000.vcf | grep "^#") <(cat isec/0000.vcf | grep -vE "^#" | awk '{if(NR % 10 == 1) print $0}') | bgzip -c > isec/masked.vcf.gz
tabix isec/masked.vcf.gz
```
#### Imputation on the target genotype data
Before imputaion, we pre-phased the target genotype data using different panels respectively as following (Our panel for example):

```
eagle --noImpMissing --vcfRef chn.final.vcf.gz --vcfTarget target.vcf.gz --geneticMapFile $geneticMAP --allowRefAltSwap --vcfOutFormat z --outputUnphased --outPrefix target.chn.phase --numThreads 8
```

We run our panel using the following command:

```
minimac4 --refHaps chn.panel.m3vcf.gz --haps target.chn.phase.vcf.gz --prefix chn.impute --cpus 8 --format GT,DS,GP --ignoreDuplicates --minRatio 0.000001 --noPhoneHome --allTypedSites
```

We run the imputation of 1KGP1, 1KGP3, GAsP and HRC panel on the [Michigan Imputation Server](https://imputationserver.sph.umich.edu), [ChinaMAP](www.mbiobank.com) and [WBBC](https://imputationserver.westlake.edu.cn/) respectively. 
