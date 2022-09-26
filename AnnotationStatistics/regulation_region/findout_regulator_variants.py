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

    def read_chunk_file(file):
        with open(file) as f:
            for line in f:
                chrom, start, end, tag = line.strip().split('\t')
                yield int(start), int(end)

    promoter_file = f'/home/user/liusiyuan/process/region_check/regulation_region/{chrom}_promoter.txt'
    enhancer_file = f'/home/user/liusiyuan/process/region_check/regulation_region/{chrom}_enhancer.txt'

    promoter_ofile = open(f'/home/user/liusiyuan/process/region_check/regulation_region/result/{chrom}_promoter_variants.txt', 'w')
    enhancer_ofile = open(f'/home/user/liusiyuan/process/region_check/regulation_region/result/{chrom}_enhancer_variants.txt', 'w')

    indexs = [int(x.split('.')[0].split('_')[1]) for x in os.listdir(f'/home/user/zhanganqi/test/ch100k_joint/workplace/prepare/Results.no_sample_filtered/XYOneAnno/{chrom}/') if x.endswith('.txt')]
    indexs.sort()

    levels = ['total','w1','w2','w3','w4','w5','w6','w7','w8','w9','q1','q2','q3','q4','q5','q6','q7','q8','q9','b1','b2','b3','b4','b5','b6','b7','b8','b9','s1','s2','s3','s4','s5','s6','s7','s8','s9','g1']
    header = ['#Chrom', 'Start', 'End']
    header.extend(levels)

    promoter_ofile.write('\t'.join(header) + '\n')
    enhancer_ofile.write('\t'.join(header) + '\n')

    promoter_reader = read_chunk_file(promoter_file)
    enhancer_reader = read_chunk_file(enhancer_file)

    pstart, pend = next(promoter_reader)
    estart, eend = next(enhancer_reader)

    promoter_content = {x:0 for x in levels}
    enhancer_content = {x:0 for x in levels}

    promoter_continue = True
    enhancer_continue = True

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

                    if promoter_continue is True:
                        while vcf_pos > pend:
                            ol = [chrom, str(pstart), str(pend)]
                            ol.extend([str(promoter_content[x]) for x in levels])
                            promoter_ofile.write('\t'.join(ol) + '\n')

                            try:
                                pstart, pend = next(promoter_reader)
                                promoter_content = {x:0 for x in levels}
                            except StopIteration:
                                promoter_continue = False
                                break

                    if enhancer_continue is True:
                        while vcf_pos > eend:
                            ol = [chrom, str(estart), str(eend)]
                            ol.extend([str(enhancer_content[x]) for x in levels])
                            enhancer_ofile.write('\t'.join(ol) + '\n')

                            try:
                                estart, eend = next(enhancer_reader)
                                enhancer_content = {x:0 for x in levels}
                            except StopIteration:
                                enhancer_continue = False
                                break

                    if promoter_continue is False and enhancer_continue is False:
                        break

                    if pstart <= vcf_pos <= pend:
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

                        promoter_content[af_level] += 1
                        promoter_content['total'] += 1

                    if estart <= vcf_pos <= eend:
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

                        enhancer_content[af_level] += 1
                        enhancer_content['total'] += 1



if __name__ == '__main__':
    chrom = parse_args()
    process(chrom)
