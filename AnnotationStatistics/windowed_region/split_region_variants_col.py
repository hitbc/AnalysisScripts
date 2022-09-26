# -*- coding: UTF-8 -*-



if __name__ == '__main__':
    

    with open('combined/region_500_variants.txt') as f:
        for line in f:
            if line.startswith('#'):
                ll = line.strip().split('\t')
                levels = ll[3:]
                olevel_files = []
                for level in levels:
                    ofile = open(f'split/region_500_{level}_variants.txt', 'w')
                    ofile.write('\t'.join(['#Chrom', 'Start', 'End', 'Count']) + '\n')
                    olevel_files.append(ofile)
            else:
                ll = line.strip().split('\t')
                chrom, start, end = ll[:3]
                counts = ll[3:]
                for i in range(len(counts)):
                    count = counts[i]
                    olevel_files[i].write('\t'.join([chrom, start, end, count]) + '\n')

    with open('combined/region_1000_variants.txt') as f:
        for line in f:
            if line.startswith('#'):
                ll = line.strip().split('\t')
                levels = ll[3:]
                olevel_files = []
                for level in levels:
                    ofile = open(f'split/region_1000_{level}_variants.txt', 'w')
                    ofile.write('\t'.join(['#Chrom', 'Start', 'End', 'Count']) + '\n')
                    olevel_files.append(ofile)
            else:
                ll = line.strip().split('\t')
                chrom, start, end = ll[:3]
                counts = ll[3:]
                for i in range(len(counts)):
                    count = counts[i]
                    olevel_files[i].write('\t'.join([chrom, start, end, count]) + '\n')

    with open('combined/region_10000_variants.txt') as f:
        for line in f:
            if line.startswith('#'):
                ll = line.strip().split('\t')
                levels = ll[3:]
                olevel_files = []
                for level in levels:
                    ofile = open(f'split/region_10000_{level}_variants.txt', 'w')
                    ofile.write('\t'.join(['#Chrom', 'Start', 'End', 'Count']) + '\n')
                    olevel_files.append(ofile)
            else:
                ll = line.strip().split('\t')
                chrom, start, end = ll[:3]
                counts = ll[3:]
                for i in range(len(counts)):
                    count = counts[i]
                    olevel_files[i].write('\t'.join([chrom, start, end, count]) + '\n')

    with open('combined/region_100000_variants.txt') as f:
        for line in f:
            if line.startswith('#'):
                ll = line.strip().split('\t')
                levels = ll[3:]
                olevel_files = []
                for level in levels:
                    ofile = open(f'split/region_100000_{level}_variants.txt', 'w')
                    ofile.write('\t'.join(['#Chrom', 'Start', 'End', 'Count']) + '\n')
                    olevel_files.append(ofile)
            else:
                ll = line.strip().split('\t')
                chrom, start, end = ll[:3]
                counts = ll[3:]
                for i in range(len(counts)):
                    count = counts[i]
                    olevel_files[i].write('\t'.join([chrom, start, end, count]) + '\n')

