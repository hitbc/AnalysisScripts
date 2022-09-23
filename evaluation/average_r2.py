#!/usr/bin/env python
# coding=utf-8
import sys 
import numpy as np
from collections import defaultdict

def af_bins(AF, target_bins):
    for i in range(len(target_bins)-1):
        af1 = target_bins[i]
        af2 = target_bins[i+1]
        
        if AF >= af1 and AF < af2:
            return af2

def ctrl(fin):
    target_ss = [0,0.00008]
    target_s0 = [0.0001,0.0002,0.0005]
    target_s1 = [0.001,0.002,0.005] # for hgdp
    #target_s0 = list(np.linspace(0.0001,0.0009,9))
    #target_s1 = list(np.linspace(0.001,0.009,9))
    target_s2 = list(np.linspace(0.01,0.09,9))
    target_s3 = list(np.linspace(0.1,0.9,9))

    target_bins = target_ss + target_s0 + target_s1 + target_s2 + target_s3
    rDict = defaultdict(list)

    with open(fin, 'r') as f:
        for line in f:
            line = line.strip().split('\t')
            AF = float(line[3])
            MAF = float(line[4])
            MAF_by_imputed = float(line[-1])
            R2 = float(line[6])

            #if R2 < 0.001: continue 
            #bins = af_bins(MAF_by_imputed, target_bins)
            bins = af_bins(MAF, target_bins)
            rDict[bins].append(R2)

    for bins in target_bins[1:]:
        #print(bins, len(rDict[bins]))
        if len(rDict[bins]) == 0: continue
        avgR2 = sum(rDict[bins]) / len(rDict[bins])
        print(round(bins, 5), len(rDict[bins]), avgR2)

if __name__ == '__main__':
    fin = sys.argv[1]
    ctrl(fin)
