# -*- coding: UTF-8 -*-


import os


# path = '/home/user/liusiyuan/process/region_check/anno/split/'

# chroms = [str(x) for x in range(1, 23)]
# chroms.extend(['X'])
# chroms = ['chr'+x for x in chroms]
# files = [x for x in os.listdir(path) if x.endswith('_region_check.txt')]
files = [os.path.join('/home/user/liusiyuan/process/region_check/1kg_gnomad/top1000', x) for x in os.listdir('/home/user/liusiyuan/process/region_check/1kg_gnomad/top1000') if x.endswith('.txt')]
tmpfiles = [os.path.join('/home/user/liusiyuan/process/region_check/region_variants/top1000', x) for x in os.listdir('/home/user/liusiyuan/process/region_check/region_variants/top1000') if x.endswith('.txt')]
files.extend(tmpfiles)

for file in files:
    ofile = open(f'{os.path.basename(file)}.sh', 'w')
    ofile.write('#!/bin/sh\n')
    ofile.write(f'python3 /home/user/liusiyuan/process/region_check/anno/anno_top1000/anno_top1000.py -f ' + file)
    ofile.close()

    p = 'cu'
    mem = '10g'
    log = 'log'
    job_name = f'{file}'

    os.system('sbatch -p '+ p + ' --mem='+ mem +' --job-name='+ job_name +' -N 1 --ntasks-per-node=1 ' + f'{os.path.basename(file)}.sh')
