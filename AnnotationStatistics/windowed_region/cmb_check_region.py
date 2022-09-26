# -*- coding: UTF-8 -*-

import os

if __name__ == '__main__':

    ofile = open('check_regions.txt', 'w')

    files = [os.path.join('/home/user/liusiyuan/process/region_check/region_variants/top1000', x) for x in os.listdir('/home/user/liusiyuan/process/region_check/region_variants/top1000') if x.endswith('.txt')]

    for file in files:
        with open(file) as f:
            for line in f:
                chrom, start, end = line.strip().split('\t')[:3]
                ofile.write('\t'.join([chrom, start, end]) + '\n')

    regulation_files = [
        '/home/user/liusiyuan/process/region_check/regulation_region/enhancer_variants.txt',
        '/home/user/liusiyuan/process/region_check/regulation_region/promoter_variants.txt',
    ]

    for file in regulation_files:
        with open(file) as f:
            for line in f:
                if line.startswith('#'):
                    continue
                else:
                    chrom, start, end = line.strip().split('\t')[:3]
                    ofile.write('\t'.join([chrom, start, end]) + '\n')
