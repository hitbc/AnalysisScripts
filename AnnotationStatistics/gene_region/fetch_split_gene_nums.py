# -*- coding: UTF-8 -*-

import argparse
import os

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-f", "--file", action="store", type=str,
        dest="file", help="The process file.")

    args = parser.parse_args()

    if args.file:
        file = args.file

    return file


def process(file):

    levels = ['total','w1','w2','w3','w4','w5','w6','w7','w8','w9','q1','q2','q3','q4','q5','q6','q7','q8','q9','b1','b2','b3','b4','b5','b6','b7','b8','b9','s1','s2','s3','s4','s5','s6','s7','s8','s9','g1']

    if 'chrY' in file:
        tag = 'chrY_1'
    else:
        tag = os.path.basename(file).split('.')[0]
    ofile = open(f'/home/user/liusiyuan/process/region_check/gene_region/split/{tag}.txt', 'w')
    hl = ['#Gene']
    hl.extend(levels)
    ofile.write('\t'.join(hl) + '\n')
    gene_counts = {}
    with open(file) as f:
        for line in f:
            if line.startswith('#'):
                continue
            else:
                ll = line.strip().split('\t')
                info = ll[12]
                af = [float(x.split('=')[1]) for x in info.split(';') if x.startswith('AF=')][0]
                func = ll[387]
                gene = ll[388]
                allow = ['exonic', 'splicing', 'ncRNA', 'UTR5', 'UTR3', 'intronic']
                if func in allow:

                    if gene not in gene_counts:
                        gene_counts[gene] = {x:0 for x in levels}

                    if af >= 0.9:
                        level_index = 37
                    elif af/0.1 >= 1:
                        v = int(af/0.1)
                        level_index = 28 + v
                    elif af/0.01 >= 1:
                        v = int(af/0.01)
                        level_index = 19 + v
                    elif af/0.001 >= 1:
                        v = int(af/0.001)
                        level_index = 10 + v
                    elif af/0.0001 >= 1:
                        v = int(af/0.0001)
                        level_index = 1 + v
                    else:
                        level_index = 1

                    af_level = levels[level_index]
                    gene_counts[gene]['total'] += 1
                    gene_counts[gene][af_level] += 1

    for gene in gene_counts:
        ol = [gene]
        for level in levels:
            ol.append(str(gene_counts[gene][level]))
        ofile.write('\t'.join(ol) + '\n')


if __name__ == '__main__':
    file = parse_args()
    process(file)