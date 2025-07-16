#!/usr/bin/env python3

# small script to make a mergetable for the MAFFT merge functionality which combines different MSAs
# MSAs need to be combined in a single file, separated by a line break:
# echo >> MSA1.fa; echo >> MSA2.fa; cat MSA1.fa MSA2.fa; python mafft_mergetable.py 

import sys
import argparse

# Set up argument parser
parser = argparse.ArgumentParser(description="Process MSA files and append incremental numbers after '>' lines. Used for MAFFT merge")
parser.add_argument('-s', type=int, default=0, help='Seed offset')
parser.add_argument('files', nargs='+', help='Input files')
args = parser.parse_args()

seedoffset = args.s
files = args.files

num = seedoffset + 1
for file in files:
    output = ""
    sys.stderr.write(file + "\n")
    try:
        with open(file, 'r') as fp:
            for line in fp:
                if line.startswith('>'):
                    output += " " + str(num)
                    num += 1
    except IOError as e:
        sys.stderr.write(f"Error reading {file}: {e}\n")
        continue

    print(f"{output}  # {file}")
