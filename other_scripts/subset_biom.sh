#!/bin/sh
#subsets biom file for creating dendogram and pcoa plots (weighted unifrac)
#Use: ./subset_biom.sh taxon

TARGET=$1

filter_taxa_from_otu_table.py -i swarm/swarm_otus.wtax.final.biom -o $TARGET.biom -p $TARGET
filter_samples_from_otu_table.py -i $TARGET.biom -o $TARGET.fix -n 10
rm $TARGET.biom
mv $TARGET.fix $TARGET.biom
biom convert -i $TARGET.biom -o $TARGET.txt --to-tsv --table-type="OTU table"
tail -n +2 $TARGET.txt | sed 's/#OTU ID/OTUID/' > $TARGET.rdat.txt
rm $TARGET.biom $TARGET.txt

Rscript dist_dend.r $TARGET.rdat.txt $TARGET.pcoa.pdf $TARGET.dendogram.pdf
