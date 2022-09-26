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

def process(file, region2index):

    length = os.path.basename(file).split('_')[1]
    ofile = open(file.replace('top1000/', 'top1000_anno/').replace('.txt', '.anno.txt'), 'w')
    ofile.write('\t'.join(['#Chrom', 'Start', 'End', 'Length', 'Value', 'Anno']) + '\n')

    with open(file) as f:
        for line in f:
            chrom, start, end, value = line.strip().split('\t')

            if chrom != 'chrY':
                file_indexs = []
                for file_start, file_end in region2index[chrom]:

                    if file_start < int(start) < file_end:
                        index = region2index[chrom][(file_start, file_end)]
                        file_indexs.append(index)
                    if file_start < int(end) < file_end:
                        index = region2index[chrom][(file_start, file_end)]
                        file_indexs.append(index)

                if len(file_indexs) > 2:
                    raise ValueError('File index num > 2')

                anno_results = []
                for index in file_indexs:
                    anno_file = f'/home/user/liusiyuan/process/region_check/anno/anno_line/{chrom}_{index}.anno_line.txt'
                    with open(anno_file) as af:
                        for aline in af:
                            if aline.startswith('#'):
                                continue
                            achrom, apos, aref, aalt, afunc, agene, ageneDetail, aexonicFunc, aChange = aline.strip().split('\t')
                            if int(start) <= int(apos) <= int(end):
                                anno_results.append(f'{agene}@{afunc}')

                anno_results = list(set(anno_results))
                ofile.write('\t'.join([chrom, start, end, length, value, ','.join(anno_results)]) + '\n')
            else:
                anno_results = []
                for index in file_indexs:
                    anno_file = f'/home/user/liusiyuan/process/region_check/anno/anno_line/Y.anno_line.txt'
                    with open(anno_file) as af:
                        for aline in af:
                            if aline.startswith('#'):
                                continue
                            achrom, apos, aref, aalt, afunc, agene, ageneDetail, aexonicFunc, aChange = aline.strip().split('\t')
                            if int(start) <= int(apos) <= int(end):
                                anno_results.append(f'{agene}@{afunc}')

                anno_results = list(set(anno_results))
                ofile.write('\t'.join([chrom, start, end, length, value, ','.join(anno_results)]) + '\n')



if __name__ == '__main__':
    region2index = {}
    with open('/home/user/zhanganqi/test/ch100k_joint/workplace/prepare/eagle.v2.bed') as f:
        for line in f:
            chrom, start, end = line.strip().split('\t')[:3]
            if chrom not in region2index:
                region2index[chrom] = {}
                index = 1
            region2index[chrom][(int(start), int(end))] = index
            index += 1

    file = parse_args()
    process(file, region2index)
