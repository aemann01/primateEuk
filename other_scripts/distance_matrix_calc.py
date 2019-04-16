#!/usr/bin/env python3

'''Generate a distance matrix (identity) from an aligned fasta file
Use: python3 distance_matrix_calc.py -i myfasta_align.fa'''

import argparse
from Bio.Phylo.TreeConstruction import DistanceCalculator
from Bio import AlignIO

parser = argparse.ArgumentParser()

parser.add_argument('-i', '--input', help='Aligned fasta file')

args = parser.parse_args()

aln = AlignIO.read(open(args.input), "fasta")
calculator = DistanceCalculator('identity')
dm = calculator.get_distance(aln)

print(dm)