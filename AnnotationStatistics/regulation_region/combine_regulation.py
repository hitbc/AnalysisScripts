# -*- coding: UTF-8 -*-



if __name__ == '__main__':
    chroms = [str(x) for x in range(1,23)]
    chroms.append('X')
    chroms = ['chr'+x for x in chroms]

    pfile = open('/home/user/liusiyuan/process/region_check/regulation_region/result/promoter_variants.txt', 'w')
    efile = open('/home/user/liusiyuan/process/region_check/regulation_region/result/enhancer_variants.txt', 'w')
    for chrom in chroms:
        with open(f'/home/user/liusiyuan/process/region_check/regulation_region/result/{chrom}_promoter_variants.txt') as f:
            for line in f:
                if line.startswith('#'):
                    if chrom == 'chr1':
                        pfile.write(line)
                else:
                    pfile.write(line)


        with open(f'/home/user/liusiyuan/process/region_check/regulation_region/result/{chrom}_enhancer_variants.txt') as f:
            for line in f:
                if line.startswith('#'):
                    if chrom == 'chr1':
                        efile.write(line)
                else:
                    efile.write(line)
