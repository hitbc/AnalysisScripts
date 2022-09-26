# -*- coding: UTF-8 -*-


import os


path = '/home/user/zhanganqi/test/ch100k_joint/workplace/prepare/Results.no_sample_filtered/XYOneAnno'

chroms = [str(x) for x in range(1, 23)]
chroms.extend(['X', 'Y'])
chroms = ['chr'+x for x in chroms]
files = []
for chrom in chroms:
    files.extend([os.path.join(path, chrom, x) for x in os.listdir(os.path.join(path, chrom)) if x.endswith('.txt')])
# files = files[:1]


for file in files:
    tag = os.path.basename(file).split('.')[0]
    ofile = open(f'gene_{tag}.sh', 'w')
    ofile.write('#!/bin/sh\n')
    ofile.write(f'python3 /home/user/liusiyuan/process/region_check/gene_region/split/fetch_split_gene_nums.py -f ' + file)
    ofile.close()

    p = 'nonfs'
    mem = '10g'
    log = 'log'
    job_name = f'gene_{tag}'

    os.system('sbatch -p '+ p + ' --mem='+ mem +' --job-name='+ job_name +' -N 1 --ntasks-per-node=1 ' + f'gene_{tag}.sh')
