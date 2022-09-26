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

    regions = []
    with open(file) as f:
        for line in f:
            chrom, start, end, index = line.strip().split('\t')
            regions.append((int(start), int(end)))

    chrom, chunk = os.path.basename(file).split('_')[:2]
    anno_file = f'/home/user/zhanganqi/test/ch100k_joint/workplace/prepare/Results.no_sample_filtered/XYOneAnno/{chrom}/{chrom}_{chunk}.{chrom}.{chunk}.core.integrated.txt'
    
    ofile = open(f'/home/user/liusiyuan/process/region_check/anno/anno_line/{chrom}_{chunk}.anno_line.txt', 'w')
    # ocfile = open(f'/home/user/liusiyuan/process/region_check/anno/anno_line/{chrom}_{chunk}.anno_line.complete.txt', 'w')

    with open(anno_file) as f:
        for line in f:
            ll = line.strip().split('\t')
            sl = ll[387:392]
            if line.startswith('#'):
                header = ['#Chrom', 'Pos', 'Ref', 'Alt']
                header.extend(sl)
                ofile.write('\t'.join(header) + '\n')
                # ocfile.write('\t'.join(ll) + '\n')
            else:
                vcf_pos = ll[6]
                vcf_ref = ll[8]
                vcf_alt = ll[9]

                for region in regions:
                    start, end = region
                    if start <= int(vcf_pos) <= end:
                        ol = [chrom, vcf_pos, vcf_ref, vcf_alt]
                        ol.extend(sl)
                        ofile.write('\t'.join(ol) + '\n')
                        break



if __name__ == '__main__':
    file = parse_args()
    process(file)
