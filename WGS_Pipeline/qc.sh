#!/bin/bash
# Exit immediately on error

#-------------------------------------------------------------------------------
# AlignmentPipeline
# Steps:
#   S01 fastqc_qc
#   S02 qualimap_bamqc
#   S03 verify_bam_id
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# STEP: S04 fastqc_qc 
#-------------------------------------------------------------------------------
fastqc_out
fastqc -t 2 -k 7 ${fq1} ${fq2} -o ${fastqc_out}

#-------------------------------------------------------------------------------
# STEP: S02 qualimap_bamqc 
#-------------------------------------------------------------------------------
qualimap_out_dir
qualimap bamqc --java-mem-size=45g -nt 8  -bam ${dup_sorted_bam} -outdir ${qualimap_out_dir}


#-------------------------------------------------------------------------------
# STEP: S03 verify_bam_id 
#-------------------------------------------------------------------------------
${SVD_dir}
VerifyBamID --Reference  ${ref_fa}  --BamFile ${sample_recal_bam} --Output ${verify_bam_id_outdir} --NumThread 4 --SVDPrefix ${SVD_dir}/1000g.phase3.100k.b38.vcf.gz.dat  
