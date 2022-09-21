#!/bin/bash

#-------------------------------------------------------------------------------
# STEP: S01 sniffles 
#-------------------------------------------------------------------------------


sniffles \
--min_support 2 \
--min_length 30 \
--num_reads_report -1 \
--min_seq_size 500 \
--genotype  \
--report-seq \
-m ${input_bam} \
-v ${sniffles.vcf}


#-------------------------------------------------------------------------------
# STEP: S02 cuteSV 
#-------------------------------------------------------------------------------

cuteSV \
${input_bam} \
${reference.fa} \
${cutesv.vcf} \
${tmp}\
--max_cluster_bias_INS 100 \
--diff_ratio_merging_INS 0.3 \
--max_cluster_bias_DEL 100 \
--diff_ratio_merging_DEL 0.3 \
--threads 16 \
-s 2 \
--genotype




#-------------------------------------------------------------------------------
# STEP: S03 svim 
#-------------------------------------------------------------------------------

svim alignment \
${output_dir} \
${input_bam} \
${reference.fa} \
--read_names \
--min_sv_size 30  \
--minimum_depth 1


#-------------------------------------------------------------------------------
# STEP: S04 nanovar 
#-------------------------------------------------------------------------------

nanovar   \
-f hg38 \
-t ${threads}  \
--minlen 30 \
${input_bam} \
${reference.fa}   \
${output_dir}


#-------------------------------------------------------------------------------
# STEP: S05 filter variant 
#-------------------------------------------------------------------------------

python ${SCRIPTS}/filter_nano_mosdepth.py \
-m ${mosdepth_summary} \
-v ${input_vcf} \
-o ${output_vcf} \
-t ${type}


#-------------------------------------------------------------------------------
# STEP: S06 merge variants
#-------------------------------------------------------------------------------

SURVIVOR merge \
${merge_files} \
1000 2 1 1 0 30  \
${merged_vcf}


#-------------------------------------------------------------------------------
# STEP: S07 force calling
#-------------------------------------------------------------------------------

cuteSV \
${input_bam} \
${reference.fa} \
${output_forcecalled_vcf} \
${tmp} \
--max_cluster_bias_INS 100 \
--diff_ratio_merging_INS 0.3 \
--max_cluster_bias_DEL 100 \
--diff_ratio_merging_DEL 0.3 \
--threads ${threads} \
-s 2 \
--genotype \
-Ivcf ${input_vcf}





#-------------------------------------------------------------------------------
# STEP: S08 merge population variants
#-------------------------------------------------------------------------------

SURVIVOR merge \
${merge_files} \
1000 1 1 1 0 30  \
${merged_vcf}

