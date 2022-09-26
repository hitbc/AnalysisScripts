# -*- coding: UTF-8 -*-



if __name__ == '__main__':
    chroms = [str(x) for x in range(1, 23)]
    chroms.append('X')
    chroms = ['chr'+x for x in chroms]

    ofile_500 = open('/home/user/liusiyuan/process/region_check/region_variants/region_500_variants.txt', 'w')
    ofile_1000 = open('/home/user/liusiyuan/process/region_check/region_variants/region_1000_variants.txt', 'w')
    ofile_10000 = open('/home/user/liusiyuan/process/region_check/region_variants/region_10000_variants.txt', 'w')
    ofile_100000 = open('/home/user/liusiyuan/process/region_check/region_variants/region_100000_variants.txt', 'w')
    for chrom in chroms:
        with open(f'/home/user/liusiyuan/process/region_check/region_variants/{chrom}_region_500_variants.txt') as f:
            for line in f:
                if line.startswith('#'):
                    if chrom == 'chr1':
                        ofile_500.write(line)
                else:
                    ofile_500.write(line)

        with open(f'/home/user/liusiyuan/process/region_check/region_variants/{chrom}_region_1000_variants.txt') as f:
            for line in f:
                if line.startswith('#'):
                    if chrom == 'chr1':
                        ofile_1000.write(line)
                else:
                    ofile_1000.write(line)

        with open(f'/home/user/liusiyuan/process/region_check/region_variants/{chrom}_region_10000_variants.txt') as f:
            for line in f:
                if line.startswith('#'):
                    if chrom == 'chr1':
                        ofile_10000.write(line)
                else:
                    ofile_10000.write(line)

        with open(f'/home/user/liusiyuan/process/region_check/region_variants/{chrom}_region_100000_variants.txt') as f:
            for line in f:
                if line.startswith('#'):
                    if chrom == 'chr1':
                        ofile_100000.write(line)
                else:
                    ofile_100000.write(line)
