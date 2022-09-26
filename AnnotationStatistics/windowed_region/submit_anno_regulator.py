# -*- coding: UTF-8 -*-


import os


path = '/home/user/liusiyuan/process/region_check/regulation_region/result'

# chroms = [str(x) for x in range(9, 23)]
# chroms = ['17', '18', '19', '20', '21', '22']
# chroms = ['11', '12', '13', '14', '15', '16']
# chroms.extend(['X'])
# chroms = ['chr'+x for x in chroms]
# files = [x for x in os.listdir(path) if x.endswith('_region_check.txt')]
files = [x for x in os.listdir('/home/user/liusiyuan/process/region_check/regulation_region/result') if x.startswith('chr')]

for file in files:
    ofile = open(f'{file}.sh', 'w')
    ofile.write('#!/bin/sh\n')
    ofile.write(f'python3 /home/user/liusiyuan/process/region_check/regulation_region/anno_regulator.py -f ' + os.path.join(path, file))
    ofile.close()

    p = 'cu'
    mem = '10g'
    log = 'log'
    job_name = f'{file}'

    os.system('sbatch -p '+ p + ' --mem='+ mem +' --job-name='+ job_name +' -N 1 --ntasks-per-node=1 ' + f'{file}.sh')
