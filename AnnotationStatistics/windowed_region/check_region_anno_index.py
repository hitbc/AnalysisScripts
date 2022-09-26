# -*- coding: UTF-8 -*-



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

    ofile = open('region_anno_index.txt', 'w')

    with open('check_regions.txt') as f:
            
        for line in f:
            chrom, start, end = line.strip().split('\t')
            if chrom not in region2index:
                continue

            file_indexs = []
            for file_start, file_end in region2index[chrom]:

                if file_start < int(start) < file_end:
                    index = region2index[chrom][(file_start, file_end)]
                    file_indexs.append(index)
                if file_start < int(end) < file_end:
                    index = region2index[chrom][(file_start, file_end)]
                    file_indexs.append(index)

            if len(file_indexs) == 1:
                ofile.write('\t'.join([chrom, start, end, str(file_indexs[0])]) + '\n')
            elif len(file_indexs) == 2:
                for index in range(file_indexs[0], file_indexs[1]+1):
                    ofile.write('\t'.join([chrom, start, end, str(index)]) + '\n')
            else:
                print(len(file_indexs))
