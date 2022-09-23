#!/bin/bash


#-------------------------------------------------------------------------------
# STEP: S01 minimap2 
#-------------------------------------------------------------------------------
minimap2 ${reference.fa} ${fastq_input} \
-t ${threads}  \
-a -z 600,200 \
-x map-ont \
--MD -c -Y   \
-o /dev/stdout \
-R ${read_group_str}  | \
samtools sort -m 3G -@ 18 \
  /dev/stdin \
  -T ${tmp} \
  -o ${out_bam} && \
samtools index -@ 18 ${out_bam} ${out_bam}.bai



#-------------------------------------------------------------------------------
# STEP: S02 NanoPlot 
#-------------------------------------------------------------------------------

NanoPlot \
--tsv_stats \
--info_in_report \
-f png \
--plots dot \
--legacy \
-t ${threads} \
-o ${output_dir} \
-p ${prefix}   \
--bam ${input_bam}



#-------------------------------------------------------------------------------
# STEP: S03 mosdepth 
#-------------------------------------------------------------------------------
mosdepth \
-T 500 \
-b ${gap.bed} \
-t ${threads} \
${output_dir} \
${input_bam}


