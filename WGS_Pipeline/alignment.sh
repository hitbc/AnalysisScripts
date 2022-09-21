#!/bin/bash
# Exit immediately on error

#-------------------------------------------------------------------------------
# AlignmentPipeline
# Steps:
#   S01 bwa_mem_pipe
#   S02 picard_merge_sam_files
#   S03 gatk4_recalibration_by_chr
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# STEP: S01 bwa_mem_pipe 
#-------------------------------------------------------------------------------
$ref_fa
$fq1
$fq2
$sample_name
$split_sam
$discordant_sam
$dup_sorted_bam
bwa mem -t 18  \
  -K 100000000 -Y \
  -R '@RG	ID:readset1	SM:${sample_name}	LB:wgs	CN:Nebula	PL:BGI' \
  ${ref_fa} \
  ${fq1} \
  ${fq2} | \
samblaster  \
  -s ${split_sam} \
  -d ${discordant_sam} \
  -i /dev/stdin \
  -o /dev/stdout | \
sambamba view -S -f bam -t 18 \
  /dev/stdin -o /dev/stdout | \
sambamba sort -m 50G -t 18  \
  --tmpdir tmp/$PBS_JOBID \
  /dev/stdin \
  -o ${dup_sorted_bam}

#-------------------------------------------------------------------------------
# STEP: S02 picard_merge_sam_files 
#-------------------------------------------------------------------------------
$readset1_bam
$discordant_bam
java -Djava.io.tmpdir=tmp/$PBS_JOBID -XX:ParallelGCThreads=1 -Dsamjdk.buffer_size=4194304 -Xmx10G -jar $PICARD_HOME/picard.jar MergeSamFiles \
  VALIDATION_STRINGENCY=SILENT SORT_ORDER=coordinate CREATE_INDEX=true \
  TMP_DIR=tmp/$PBS_JOBID \
  INPUT=${split_bam} \
  OUTPUT=${split_bam} \
  MAX_RECORDS_IN_RAM=250000 && \
java -Djava.io.tmpdir=tmp/$PBS_JOBID -XX:ParallelGCThreads=1 -Dsamjdk.buffer_size=4194304 -Xmx10G -jar $PICARD_HOME/picard.jar MergeSamFiles \
  VALIDATION_STRINGENCY=SILENT SORT_ORDER=coordinate CREATE_INDEX=true \
  TMP_DIR=tmp/$PBS_JOBID \
  INPUT= ${discordant_sam} \
  OUTPUT= ${discordant_bam} \
  MAX_RECORDS_IN_RAM=250000


#-------------------------------------------------------------------------------
# STEP: S03 gatk4_recalibration_by_chr 
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# JOB: gatk4_recalibration_by_chr: base_recalibration
#-------------------------------------------------------------------------------
$dbsnp
$recalibration_report_grp
gatk --java-options "-XX:ParallelGCThreads=1 -Dsamjdk.buffer_size=4194304 -Djava.io.tmpdir=tmp/$PBS_JOBID -Xmx5G" BaseRecalibrator \
 -R  ${ref_fa} \
 -I ${dup_sorted_bam} \
 --use-original-qualities \
 --known-sites ${dbsnp} \
 -O ${recalibration_report_grp}

#-------------------------------------------------------------------------------
# JOB: gatk4_recalibration_by_chr: apply_bqsr
#-------------------------------------------------------------------------------
chr_list=chr{1..22,X,Y,M}
for chr_ in chr_list; do
gatk --java-options "-XX:ParallelGCThreads=1 -Dsamjdk.buffer_size=4194304 -Djava.io.tmpdir=tmp/$PBS_JOBID -Xmx10G"  ApplyBQSR  \
  --intervals ${chr_} -R ${ref_fa} -I ${dup_sorted_bam} -O ${chr_recal_bam} \
      --bqsr-recal-file ${recalibration_report_grp} \
      --static-quantized-quals 10 --static-quantized-quals 20 --static-quantized-quals 30 --add-output-sam-program-record --use-original-qualities
; done



#-------------------------------------------------------------------------------
# JOB: gatk4_recalibration_by_chr: picard_merge_sam_files.bqsr
#-------------------------------------------------------------------------------
sample_recal_bam
java -Djava.io.tmpdir=tmp/$PBS_JOBID -XX:ParallelGCThreads=1 -Dsamjdk.buffer_size=4194304 -Xmx10G -jar $PICARD_HOME/picard.jar MergeSamFiles \
  VALIDATION_STRINGENCY=SILENT SORT_ORDER=coordinate CREATE_INDEX=true \
  TMP_DIR=tmp/$PBS_JOBID \
  INPUT=${chr1_recal_bam} \
  INPUT=${chr2_recal_bam} \
  INPUT=${chr3_recal_bam} \
  INPUT=${chr4_recal_bam} \
  INPUT=${chr5_recal_bam} \
  INPUT=${chr6_recal_bam} \
  INPUT=${chr7_recal_bam} \
  INPUT=${chr8_recal_bam} \
  INPUT=${chr9_recal_bam} \
  INPUT=${chr10_recal_bam} \
  INPUT=${chr11_recal_bam} \
  INPUT=${chr12_recal_bam} \
  INPUT=${chr13_recal_bam} \
  INPUT=${chr14_recal_bam} \
  INPUT=${chr15_recal_bam} \
  INPUT=${chr16_recal_bam} \
  INPUT=${chr17_recal_bam} \
  INPUT=${chr18_recal_bam} \
  INPUT=${chr19_recal_bam} \
  INPUT=${chr20_recal_bam} \
  INPUT=${chr21_recal_bam} \
  INPUT=${chr22_recal_bam} \
  INPUT=${chrX_recal_bam} \
  INPUT=${chrY_recal_bam} \
  INPUT=${chrM_recal_bam} \
  OUTPUT=${sample_recal_bam} \
  MAX_RECORDS_IN_RAM=250000 