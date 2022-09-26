# -*- coding: UTF-8 -*-



if __name__ == '__main__':
    index2ofile = {}
    with open('region_anno_index.txt') as f:
        for line in f:
            chrom, start, end, index = line.strip().split('\t')
            if (chrom, index) not in index2ofile:
                index2ofile[(chrom, index)] = f'split/{chrom}_{index}_region_check.txt'

            target_file = index2ofile[(chrom, index)]
            ofile = open(target_file, 'a')
            ofile.write(line)
            ofile.close
