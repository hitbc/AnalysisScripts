#!/bin/bash
# Exit immediately on error
set -eu -o pipefail

#-------------------------------------------------------------------------------
# SNP_INDEL JointCall 
# Steps:
#   S01 gatk4_GenomicsDBImport
#   S02 gatk_DBImport_genotype
#   S03 gatk_gather_vcf
#   S04 gatk_vqsr
#   S05 cohort_vcf_normalize
#   S06 hwe_missing_rate
#   S07 shapeit4
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# STEP: S01 gatk4_GenomicsDBImport
#-------------------------------------------------------------------------------
${interval}
gatk --java-options "-Xmx3g -Xms3g -Djava.io.tmpdir=tmp/$PBS_JOBID -Xmx3G" GenomicsDBImport    -R ${ref_fa}  \
  --sample-name-map ${sample_name_map}    \
  -L ${interval}       --batch-size 50 --reader-threads 1 \
  --merge-input-intervals --consolidate --genomicsdb-shared-posixfs-optimizations true     \
  --genomicsdb-workspace-path ${db_dir}/${interval}      \
  --tmp-dir tmp/$PBS_JOBID

#-------------------------------------------------------------------------------
# STEP: S02 gatk_DBImport_genotype 
#-------------------------------------------------------------------------------
${interval}
${db_dir}
${genotype_vcf}
gatk --java-options "-XX:ParallelGCThreads=1 -Dsamjdk.buffer_size=4194304 -Djava.io.tmpdir=tmp/$PBS_JOBID -Xmx4G" GenotypeGVCFs  -R ${ref_fa} \
  -L ${interval}  \
  --variant ${db_dir}/${interval}    -O ${genotype_vcf} \
  -G StandardAnnotation -G AS_StandardAnnotation --allow-old-rms-mapping-quality-annotation-data --merge-input-intervals 

#-------------------------------------------------------------------------------
# STEP: S03 gatk_gather_vcf 
#-------------------------------------------------------------------------------
chr_list=chr{1..22,X,Y,M}
for chr_ in chr_list; do \
gatk  --java-options "-XX:ParallelGCThreads=1 -Dsamjdk.buffer_size=4194304 -Djava.io.tmpdir=tmp/$PBS_JOBID -Xmx20G" GatherVcfs\
  -I gatk_DBImport_genotype/1/${chr_}/1.${chr_}.*.HC.vcf \
  -O gatk_gather_vcf/1/${chr_}/1.${chr_}.vcf

#-------------------------------------------------------------------------------
# STEP: S04 gatk_vqsr 
#-------------------------------------------------------------------------------
${hapmap_3.3.hg38_vcf}
${1000G_omni2.5_hg38_vcf}
${1000G_phase1.snps.high_confidence.hg38_vcf}
${dbsnp.hg38_vcf}
${Mills_and_1000G_gold_standard.indels.hg38_vcf}
${indels.recal}
${snps.recal}
${snps.tranches}  
${indels.tranches}
{raw_indels_genotyped.vqsr.vcf}
gatk  --java-options "-XX:ParallelGCThreads=1 -Dsamjdk.buffer_size=4194304 -Djava.io.tmpdir=tmp/$PBS_JOBID -Xmx30G" \
VariantRecalibrator -R ${ref_fa} \
-V ${chr1_vcf} \
-V ${chr2_vcf} \
...
-V ${chr22_vcf} \
-V ${chrX_vcf} \
-V ${chrY_vcf} \
-V ${chrM_vcf} \
-resource:hapmap,known=false,training=true,truth=true,prior=15.0 ${hapmap_3.3.hg38_vcf} \
-resource:omini,known=false,training=true,truth=true,prior=12.0 ${1000G_omni2.5_hg38_vcf} \
-resource:1000G,known=false,training=true,truth=false,prior=10.0 ${1000G_phase1.snps.high_confidence.hg38_vcf} \
-resource:dbsnp,known=true,training=false,truth=false,prior=7.0 ${dbsnp.hg38_vcf} \
--trust-all-polymorphic -tranche 100.0 -tranche 99.99 -tranche 99.98 -tranche 99.97 -tranche 99.96  -tranche 99.95 -tranche 99.9 -tranche 99.0 -an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR -an DP -mode SNP --max-gaussians 8 \
-O ${snps.recal} \
--tranches-file ${snps.tranches}   && \
gatk  --java-options "-XX:ParallelGCThreads=1 -Dsamjdk.buffer_size=4194304 -Djava.io.tmpdir=tmp/$PBS_JOBID -Xmx30G" \
VariantRecalibrator -R ${ref_fa} \
-V ${chr1_vcf} \
-V ${chr2_vcf} \
...
-V ${chr22_vcf} \
-V ${chrX_vcf} \
-V ${chrY_vcf} \
-V ${chrM_vcf} \
--trust-all-polymorphic -tranche 100.0 -tranche 99.99 -tranche 99.98 -tranche 99.97 -tranche 99.96  -tranche 99.95 -tranche 99.9 -tranche 99.0 -an QD -an DP -an FS -an ReadPosRankSum -mode INDEL --max-gaussians 4 \
 -resource:mills,known=false,training=true,truth=true,prior=12.0 ${Mills_and_1000G_gold_standard.indels.hg38_vcf} \
 -resource:dbsnp,known=true,training=false,truth=false,prior=2.0 ${dbsnp.hg38_vcf} \
-O ${indels.recal} \
--tranches-file ${indels.tranches}


gatk --java-options "-XX:ParallelGCThreads=1 -Dsamjdk.buffer_size=4194304 -Djava.io.tmpdir=tmp1/$PBS_JOBID -Xmx4G" \
ApplyVQSR -R  ${ref_fa} -V ${interval_vcf} \
	-O ${raw_indels_genotyped.vqsr.vcf} \
    --tranches-file ${snps.tranches}  \
    --recal-file ${snps.recal} \
    --ts-filter-level 99.98 -mode SNP && \
gatk --java-options "-XX:ParallelGCThreads=1 -Dsamjdk.buffer_size=4194304 -Djava.io.tmpdir=tmp1/$PBS_JOBID -Xmx4G" \
ApplyVQSR -R  ${ref_fa}  -V ${raw_indels_genotyped.vqsr.vcf} \
	-O ${vqsr_out} \
    --tranches-file ${indels.tranches} \
    --recal-file ${indels.recal} \
    --ts-filter-level 99.9 -mode INDEL


#-------------------------------------------------------------------------------
# STEP: S05 cohort_vcf_normalize
#-------------------------------------------------------------------------------
${vqsr_out}  
${vqsr_out}  
bcftools norm -f  -R ${ref_fa}  -m -both ${vqsr_out}   -o ${norm_out}


#-------------------------------------------------------------------------------
# STEP: S06 hwe_missing_rate
#-------------------------------------------------------------------------------
${vcftools_out}
vcftools --recode --recode-INFO-all --gzvcf  ${norm_out}  \
--max-missing 0.95 --hwe 0.000001 \ 
--out  ${vcftools_out}



#-------------------------------------------------------------------------------
# STEP: S07 shapeit4
#-------------------------------------------------------------------------------
${b38.gmap} 
${shapeit4_out} 
shapeit4  --pbwt-mac 1   -T 8 -I ${vcftools_out} \
 -M  ${b38.gmap}  \
 -O ${shapeit4_out}  -R ${interval} \
 &&  tabix ${shapeit4_out} 
