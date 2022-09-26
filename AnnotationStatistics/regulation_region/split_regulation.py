# -*- coding: UTF-8 -*-

import gzip
import os

if __name__ == '__main__':
    enhancer_file = '/home/user/xybio/software/VarNote/humandb/hg38_cage_enhancers.sort.bed.gz'
    promoter_file = '/home/user/xybio/software/VarNote/humandb/hg38_cage_promoters.sort.bed.gz'

    files = [enhancer_file, promoter_file]

    for file in files:
        content = {}
        with gzip.open(file) as f:
            for line in f:
                line = line.decode()
                if line.startswith('#'):
                    continue
                else:
                    chrom, start, end, tmp = line.strip().split('\t')
                    if chrom not in content:
                        content[chrom] = []
                    content[chrom].append((start, end))
        for chrom in content:
            ofile = open(f'{chrom}_{tmp}.txt', 'w')
            for one in content[chrom]:
                start, end = one
                ofile.write('\t'.join([chrom, start, end, f'{chrom}_{start}_{end}_{tmp}']) + '\n')
