# ###########NOTE: Taxonomy assignments for unassigned reads are done by loading blast output from above command in MEGAN community edition, selecting nodes that are of interest and getting taxonomy path to assigned reads output

#get everything but unassigned
grep -v "Unassigned" assigntax/rep_set_tax_assignments.txt | awk '{print $1, "\t", $2}' > assigntax/silva128_assignments.txt
sed 's/"root;cellular organisms;//' assigntax/unassigned.tax.txt | sed 's/;"$//' | sed 's/ /_/g' > assigntax/ncbi_assignments.txt
cat assigntax/silva128_assignments.txt assigntax/ncbi_assignments.txt > assigntax/full.tax.txt

#add taxonomic assignemnts to otu table 
biom add-metadata -i swarm/swarm_otus.biom -o swarm/swarm_otus.wtax.biom --observation-metadata-fp assigntax/full.tax.txt --observation-header OTUID,taxonomy --sc-separated taxonomy

#open resulting taxonomy file, remove any that are plants/vertebrates/insects and filter resulting biom table (also limit otu to min 10 obs)
filter_otus_from_otu_table.py -i swarm/swarm_otus.wtax.biom -o swarm/swarm_otus.wtax.final.biom -n 10 --negate_ids_to_exclude -e assigntax/microeuk.tax.fix.txt
biom convert -i swarm/swarm_otus.wtax.final.biom -o swarm/swarm_otus.wtax.final.txt --table-type="OTU table" --to-tsv --header-key taxonomy

#remove rep set otus that can't be assigned any taxonomy -- these are probably just sequencing error
awk '{print $1}' assigntax/full.tax.txt > assigntax/full.tax.ids
filter_fasta.py -f swarm/rep_set.fa -o swarm/rep_set.final.fa -s assigntax/full.tax.ids

mkdir tree
#generate rep set tree
mafft --quiet --maxiterate 1000 swarm/rep_set.final.fa > tree/rep_set.align.fa
cd tree
raxmlHPC -f a -x 12345 -p 12345 -# 100 -m GTRGAMMA -s rep_set.align.fa -n rep.tre

#filter biom table so that any hit of 1 is converted to 0
sed 's/\t1.0\t/\t0.0\t/g' swarm/swarm_otus.wtax.final.txt > swarm/fix
rm swarm/swarm_otus.wtax.final.txt
mv swarm/fix swarm/swarm_otus.wtax.final.txt
biom convert -i swarm/swarm_otus.wtax.final.txt -o swarm/swarm_otus.wtax.final.biom --to-hdf5 --table-type="OTU table" --process-obs-metadata taxonomy


