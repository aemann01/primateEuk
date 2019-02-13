import itertools
import sys

'''How many combinations of nucleotides for a set read length? Use: python3 combos.py <read length, numerical>'''

combos = itertools.combinations_with_replacement(["A","T","G","C"], int(sys.argv[1]))
print(sum(1 for i in combos))
