# -*- coding: UTF-8 -*-

import argparse
import os

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--chrom", action="store", type=str,
        dest="chrom", help="The process chrom.")

    args = parser.parse_args()

    if args.chrom:
        chrom = args.chrom

    return chrom


def process(chrom):

    chunk_500_file = open(f'/home/user/liusiyuan/process/region_check/region_variants/{chrom}_region_500_variants.txt', 'w')
    chunk_1000_file = open(f'/home/user/liusiyuan/process/region_check/region_variants/{chrom}_region_1000_variants.txt', 'w')
    chunk_10000_file = open(f'/home/user/liusiyuan/process/region_check/region_variants/{chrom}_region_10000_variants.txt', 'w')
    chunk_100000_file = open(f'/home/user/liusiyuan/process/region_check/region_variants/{chrom}_region_100000_variants.txt', 'w')

    indexs = [int(x.split('.')[0].split('_')[1]) for x in os.listdir(f'/home/user/zhanganqi/test/ch100k_joint/workplace/prepare/Results.no_sample_filtered/XYOneAnno/{chrom}/') if x.endswith('.txt')]
    indexs.sort()
    levels = ['total','w1','w2','w3','w4','w5','w6','w7','w8','w9','q1','q2','q3','q4','q5','q6','q7','q8','q9','b1','b2','b3','b4','b5','b6','b7','b8','b9','s1','s2','s3','s4','s5','s6','s7','s8','s9','g1']
    header = ['#Chrom', 'Start', 'End']
    header.extend(levels)
    chunk_500_file.write('\t'.join(header) + '\n')
    chunk_1000_file.write('\t'.join(header) + '\n')
    chunk_10000_file.write('\t'.join(header) + '\n')
    chunk_100000_file.write('\t'.join(header) + '\n')

    chunk_500_variants = {x:0 for x in levels}
    chunk_1000_variants = {x:0 for x in levels}
    chunk_10000_variants = {x:0 for x in levels}
    chunk_100000_variants = {x:0 for x in levels}
    chunk_500 = (0,0)
    chunk_1000 = (0,0)
    chunk_10000 = (0,0)
    chunk_100000 = (0,0)

    for index in indexs:
        print(f'Processing {chrom}-{index}')
        file = f'/home/user/zhanganqi/test/ch100k_joint/workplace/prepare/Results.no_sample_filtered/XYOneAnno/{chrom}/{chrom}_{index}.{chrom}.{index}.core.integrated.txt'
        with open(file) as f:
            for line in f:
                if line.startswith('#'):
                    continue
                else:
                    ll = line.split('\t')
                    vcf_pos = int(ll[6])
                    vcf_info = ll[12]
                    af = [float(x.split('=')[1]) for x in vcf_info.split(';') if x.startswith('AF=')][0]

                    if vcf_pos > chunk_500[1]:
                        if chunk_500 == (0,0):
                            chunk_500 = (vcf_pos, vcf_pos+500-1)
                        else:
                            ol = [chrom, str(chunk_500[0]), str(chunk_500[1])]
                            ol.extend([str(chunk_500_variants[x]) for x in levels])
                            chunk_500_file.write('\t'.join(ol) + '\n')

                            while vcf_pos > chunk_500[1]:
                                last_end = chunk_500[1]
                                chunk_500 = (last_end+1, last_end+1+500-1)
                                chunk_500_variants = {x:0 for x in levels}

                    if vcf_pos > chunk_1000[1]:
                        if chunk_1000 == (0,0):
                            chunk_1000 = (vcf_pos, vcf_pos+1000-1)
                        else:
                            ol = [chrom, str(chunk_1000[0]), str(chunk_1000[1])]
                            ol.extend([str(chunk_1000_variants[x]) for x in levels])
                            chunk_1000_file.write('\t'.join(ol) + '\n')

                            while vcf_pos > chunk_1000[1]:
                                last_end = chunk_1000[1]
                                chunk_1000 = (last_end+1, last_end+1+1000-1)
                                chunk_1000_variants = {x:0 for x in levels}

                    if vcf_pos > chunk_10000[1]:
                        if chunk_10000 == (0,0):
                            chunk_10000 = (vcf_pos, vcf_pos+10000-1)
                        else:
                            ol = [chrom, str(chunk_10000[0]), str(chunk_10000[1])]
                            ol.extend([str(chunk_10000_variants[x]) for x in levels])
                            chunk_10000_file.write('\t'.join(ol) + '\n')

                            while vcf_pos > chunk_10000[1]:
                                last_end = chunk_10000[1]
                                chunk_10000 = (last_end+1, last_end+1+10000-1)
                                chunk_10000_variants = {x:0 for x in levels}

                    if vcf_pos > chunk_100000[1]:
                        if chunk_100000 == (0,0):
                            chunk_100000 = (vcf_pos, vcf_pos+100000-1)
                        else:
                            ol = [chrom, str(chunk_100000[0]), str(chunk_100000[1])]
                            ol.extend([str(chunk_100000_variants[x]) for x in levels])
                            chunk_100000_file.write('\t'.join(ol) + '\n')

                            while vcf_pos > chunk_100000[1]:
                                last_end = chunk_100000[1]
                                chunk_100000 = (last_end+1, last_end+1+100000-1)
                                chunk_100000_variants = {x:0 for x in levels}

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
                    chunk_500_variants[af_level] += 1
                    chunk_1000_variants[af_level] += 1
                    chunk_10000_variants[af_level] += 1
                    chunk_100000_variants[af_level] += 1
                    chunk_500_variants['total'] += 1
                    chunk_1000_variants['total'] += 1
                    chunk_10000_variants['total'] += 1
                    chunk_100000_variants['total'] += 1

    ol = [chrom, str(chunk_500[0]), str(chunk_500[1])]
    ol.extend([str(chunk_500_variants[x]) for x in levels])
    chunk_500_file.write('\t'.join(ol) + '\n')
    chunk_500_file.close()

    ol = [chrom, str(chunk_1000[0]), str(chunk_1000[1])]
    ol.extend([str(chunk_1000_variants[x]) for x in levels])
    chunk_1000_file.write('\t'.join(ol) + '\n')
    chunk_1000_file.close()

    ol = [chrom, str(chunk_10000[0]), str(chunk_10000[1])]
    ol.extend([str(chunk_10000_variants[x]) for x in levels])
    chunk_10000_file.write('\t'.join(ol) + '\n')
    chunk_10000_file.close()

    ol = [chrom, str(chunk_100000[0]), str(chunk_100000[1])]
    ol.extend([str(chunk_100000_variants[x]) for x in levels])
    chunk_100000_file.write('\t'.join(ol) + '\n')
    chunk_100000_file.close()



if __name__ == '__main__':
    chrom = parse_args()
    process(chrom)
