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
    sort_file = file.replace('.txt', '.sort.txt')
    max_1000_file = file.replace('.txt', '.top1000.txt')
    os.system(f"sed -n '2,$p' {file} | sort -k 4 -n > {sort_file}")
    os.system(f'tail -1000 {sort_file} > {max_1000_file}')


if __name__ == '__main__':
    file = parse_args()
    process(file)

