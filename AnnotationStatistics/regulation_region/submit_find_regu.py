# -*- coding: UTF-8 -*-


import os


# path = '/home/user/xybio/data/test_data/1kg_gnomad/'

chroms = [str(x) for x in range(1, 23)]
chroms.extend(['X'])
chroms = ['chr'+x for x in chroms]
# files = [x for x in os.listdir(path) if x.endswith('.txt')]

for chrom in chroms:
    ofile = open(f'{chrom}_find_regu.sh', 'w')
    ofile.write('#!/bin/sh\n')
    ofile.write(f'python3 /home/user/liusiyuan/process/region_check/regulation_region/result/findout_regulator_variants.py -c ' + chrom)
    ofile.close()

    p = 'cu'
    mem = '20g'
    log = 'log'
    job_name = f'{chrom}_find_regu'

    os.system('sbatch -p '+ p + ' --mem='+ mem +' --job-name='+ job_name +' -N 1 --ntasks-per-node=1 ' + f'{chrom}_find_regu.sh')
