# -*- coding: UTF-8 -*-

import os

if __name__ == '__main__':
    files = [x for x in os.listdir('.') if x.startswith('chr') and x.endswith('.txt')]

    content = {}
    for file in files:
        with open(file) as f:
            for line in f:
                if line.startswith('#'):
                    headline = line
                else:
                    ll = line.strip().split('\t')
                    gene = ll[0]
                    level_counts = [int(x) for x in ll[1:]]
                    if gene not in content:
                        content[gene] = level_counts
                    else:
                        for i in range(len(level_counts)):
                            content[gene][i] += level_counts[i]

    ofile = open('gene_variants_num.txt', 'w')
    ofile.write(line)
    keys = list(content.keys())
    keys.sort()
    for key in keys:
        counts = [str(x) for x in content[key]]
        ofile.write(key + '\t' + '\t'.join(counts) + '\n')
