#!/bin/bash

#-------------------------------------------------------------------------------
# STEP: S01 minimap2 
#-------------------------------------------------------------------------------
# filter the read score greater or equal than 7
guppy_basecaller_supervisor \
--input_path ${fast5_input} \
-r \
--num_clients 20 \
--config ${prom.cfg} \
--min_qscore 7 \
--save_path ${output_dir} \
--disable_events \
--port 5556 \
--disable_pings \
-q 100000  \
--barcode_kits ${kit_serials} \
--trim_barcodes \
--compress_fastq

