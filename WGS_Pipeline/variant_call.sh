#!/bin/bash
# Exit immediately on error

#-------------------------------------------------------------------------------
# AlignmentPipeline
# Steps:
#   S01 gatk4_haplotype_caller_family
#   S02 manta
#   S03 cnvnator
#   S04 smoove
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# STEP: S01 gatk4_haplotype_caller_family 
#-------------------------------------------------------------------------------
$chr_gvcf
chr_list=chr{1..22,X,Y,M}
for chr_ in chr_list; do \
gatk --java-options "-XX:ParallelGCThreads=1 -Dsamjdk.buffer_size=4194304 -Djava.io.tmpdir=tmp/$PBS_JOBID -Xmx10G" HaplotypeCaller \
  --reference  ${ref_fa} \
  --dbsnp ${dbsnp} \
  --input ${sample_recal_bam} \
  -contamination 0  -G StandardAnnotation -G StandardHCAnnotation -G AS_StandardAnnotation  -GQB 10 -GQB 20 -GQB 30 -GQB 40 -GQB 50 -GQB 60 -GQB 70 -GQB 80 -GQB 90 \
  --output ${chr_gvcf}  \
  --intervals ${chr_}  \
  --emit-ref-confidence GVCF ; done


 #-------------------------------------------------------------------------------
# STEP: S02 manta 
#-------------------------------------------------------------------------------
 ${manta_run_sh}
STEP=S02
configManta.py --bam  ${sample_recal_bam} --referenceFasta  ${ref_fa} --runDir ${manta_run_sh}  && \
runWorkflow.py -m local -j 10 


#-------------------------------------------------------------------------------
# STEP: S03 cnvnator 
#-------------------------------------------------------------------------------
cnvnator_d_dir
source $ROOTSYS/bin/thisroot.sh && \
cnvnator -genome ${ref_fa} -root final/E100023667_L01_77/cnv/cnvnator/out.root -chrom chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY chrM -tree  ${sample_recal_bam} && \
cnvnator -genome ${ref_fa} -root final/E100023667_L01_77/cnv/cnvnator/out.root -d ${ref_fa_dir} -his 100 && \
cnvnator -genome ${ref_fa} -root final/E100023667_L01_77/cnv/cnvnator/out.root -stat 100 && \
cnvnator -genome ${ref_fa} -root final/E100023667_L01_77/cnv/cnvnator/out.root -partition 100 && \
cnvnator -genome ${ref_fa} -root final/E100023667_L01_77/cnv/cnvnator/out.root -d ${cnvnator_d_dir} -call 100 >> ${cnvnator_out}

#-------------------------------------------------------------------------------
# STEP: S04 smoove 
#-------------------------------------------------------------------------------
$sample_name
$exclude_region_bed
$smoove_dir
smoove call \
  -outdir ${smoove_dir} \
  --name ${sample_name}   --exclude ${exclude_region_bed} \
  --fasta ${ref_fa} \
  --noextrafilters   --genotype  ${sample_recal_bam}