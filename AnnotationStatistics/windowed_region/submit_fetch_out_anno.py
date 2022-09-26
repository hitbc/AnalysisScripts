# -*- coding: UTF-8 -*-


import os


path = '/home/user/liusiyuan/process/region_check/anno/split/'

# chroms = [str(x) for x in range(1, 23)]
# chroms.extend(['X'])
# chroms = ['chr'+x for x in chroms]
files = [x for x in os.listdir(path) if x.endswith('_region_check.txt')]

for file in files:
    ofile = open(f'{file}.sh', 'w')
    ofile.write('#!/bin/sh\n')
    ofile.write(f'python3 /home/user/liusiyuan/process/region_check/anno/anno_line/fetch_out_anno_line.py -f ' + os.path.join(path, file))
    ofile.close()

    p = 'cu'
    mem = '10g'
    log = 'log'
    job_name = f'{file}'

    os.system('sbatch -p '+ p + ' --mem='+ mem +' --job-name='+ job_name +' -N 1 --ntasks-per-node=1 ' + f'{file}.sh')
