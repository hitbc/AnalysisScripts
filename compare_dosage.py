#!/usr/bin/env python
# coding=utf-8
import sys
import gzip
import numpy as np
from collections import defaultdict

def comparing(fimputed, fGWAS, fGWAS_af, liftover):
    gwasDict = defaultdict(list)
    with open(fGWAS, 'r') as f:
        f.readline()
        for line in f:
            line = line.strip().split('\t')
            key = ":".join(line[1:4])
            gwasDict[key] = [float(i) for i in line[4:]]

    gwasafDict = defaultdict(float)
    with open(fGWAS_af, 'r') as f:
        for line in f:
            line = line.strip().split('\t')
            key = ":".join(line[1:4])
            #gwasafDict[key] = round(min(float(line[-1]), 1-float(line[-1])), 5)
            gwasafDict[key] = round(float(line[-1]), 7) # AF

    with gzip.open(fimputed, 'rb') as f:
        na = 0
        for line in f:
            line = line.decode('utf-8')
            if line.startswith('#'): continue

            line = line.strip().split('\t')
            key = ":".join(line[1:2]+line[3:5])
            MAF = gwasafDict[key]
            #print(key, MAF, gwasDict[key])

            if gwasDict[key] == [] or MAF == 0.0: continue
            INFO = line[7].split(';')
            if liftover == "True":
                typ = INFO[-1]
                AF_by_imputed = INFO[0].split('=')[1]
            else:
                typ = INFO[-1]
                AF_by_imputed = INFO[0].split('=')[1]
            
            if typ != "IMPUTED": continue

            tList = []
            for i in line[9:]:
                dosage = float(i.split(':')[1])
                tList.append(dosage)
            
            X = gwasDict[key]
            Y = tList

            varX = np.var(X)
            if varX == 0.0:
                X[0] += 0.001

            varY = np.var(Y)
            if varY == 0.0:
                Y[0] += 0.001

            ## cal R2 method 1
            #n = len(tList)
            #X = np.array(X)
            #Y = np.array(Y)
            #sum_XY = np.sum(X*Y)
            #sum_X = np.sum(X)
            #sum_Y = np.sum(Y)
            #sum_XX = np.sum(X*X)
            #sum_YY = np.sum(Y*Y)
            #R2 = (n*sum_XY - sum_X*sum_Y) / (np.sqrt((n*sum_XX-sum_X*sum_X)*(n*sum_YY-sum_Y*sum_Y)))


            #print(key)
            #print(X)
            #print(Y)
            #print("sum_XY=%f, sum_X=%f, sum_Y=%f, sum_XX=%f, sum_YY=%f, R2=%f" %(sum_XY,sum_X,sum_Y,sum_XX,sum_YY,R2))

            # method 2
            R = np.corrcoef(X,Y)
            R2 = R[1,0]
            out = [key, "*", "*", "0.0", str(MAF), "*", str(R2*R2), AF_by_imputed]
            if out[-2] != "nan":
                print("\t".join(out))
            else:
                #print(R2)
                #print("sum_XY=%d, sum_X=%d,sum_Y=%d,sum_XX=%d,sum_YY=%d" %(sum_XY,sum_X,sum_Y,sum_XX,sum_YY))
                #print(len(X),X)
                #print(len(Y),Y)
                na += 1

if __name__ == '__main__':
    fimputed = sys.argv[1]
    fGWAS = sys.argv[2] ## masked dosage list using bcftools
    fGWAS_af = sys.argv[3] ## af list in reference panel
    isliftover = sys.argv[4]
    comparing(fimputed, fGWAS, fGWAS_af, isliftover)
