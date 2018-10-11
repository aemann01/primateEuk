#!/usr/bin/env python3

'''
For primate euk project, parse multi genbank file, pull metadata for euk ref tree build 
Use: python genbankparse.py myfile.gb
'''

import sys
import pandas as pd
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord

data = []

for record in SeqIO.parse(open(sys.argv[1], "r"), "genbank"):
    accession = record.id
    organism = record.annotations["organism"]
    for feature in record.features:
        if "isolation_source" in feature.qualifiers:
            source = feature.qualifiers['isolation_source'][0]
        if "host" in feature.qualifiers:
            host = feature.qualifiers["host"][0]
        if "country" in feature.qualifiers:
            country = feature.qualifiers["country"][0]
    try:
        source
    except NameError:
        source = "NA"
    try:
        host
    except NameError:
        host = "NA"
    try:
        country
    except NameError:
        country = "NA"
    data.append([accession, organism, str(source), str(host), str(country)])
df = pd.DataFrame(data)
df.columns = ['accession', 'organism', 'isolation_source', 'host', 'country']
df.to_csv("metadata.txt", sep="\t", index=False)








