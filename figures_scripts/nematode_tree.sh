######################
#Reference tree build
######################
# generated from Silva 128 release 99 clustered tree
# get reference ids
grep "Spirurida" ~/refDB/silva128/99_SILVA_128_taxa_map_7_level.w_blastocystis_entamoeba.txt | awk '{print $1}' > spirurida.ids
grep "Rhabditida" ~/refDB/silva128/99_SILVA_128_taxa_map_7_level.w_blastocystis_entamoeba.txt | awk '{print $1}' > rhabditida.ids
grep "Trichuris" ~/refDB/silva128/99_SILVA_128_taxa_map_7_level.w_blastocystis_entamoeba.txt | awk '{print $1}' > trichuris.ids
grep "Oxyurida" ~/refDB/silva128/99_SILVA_128_taxa_map_7_level.w_blastocystis_entamoeba.txt | awk '{print $1}' > oxyurida.ids
grep "Ascari" ~/refDB/silva128/99_SILVA_128_taxa_map_7_level.w_blastocystis_entamoeba.txt | awk '{print $1}' > ascarid.ids
cat *ids > ref.ids
cat ref.ids | while read line; do grep $line ~/refDB/silva128/99_SILVA_128_taxa_map_7_level.w_blastocystis_entamoeba.txt ; done > annotations.txt
# filter from 99 clustered reference data
filter_fasta.py -f ~/refDB/silva128/99_SILVA_128_euks_rep_set.fasta -o ref.fa -s ref.ids
# in R, only keep those nodes in list
# library(ape)
# to_keep <- read.table("ref.ids", header=F)
# tree <- read.tree("/Users/mann/refDB/silva128/SILVA_128_18s_99_rep_set.tre")
# pruned_tree <- drop.tip(tree, tree$tip.label[-match(to_keep$V1, tree$tip.label)])

#######################
#Constraint tree build
#######################
mafft --auto ref.fa > ref.align.fa
align_seqs.py -i seqs.fa -t ref.align.fa -o htes_aligned -p 10
cat htes_aligned/seqs_aligned.fasta ref.align.fa > queryalign_plus_refalign.fa
raxmlHPC-PTHREADS-SSE3 -f a -N 100 -G 0.2 -m GTRCAT -n constrain.tre -s queryalign_plus_refalign.fa -g pruned_tree.tre -T 4 -x 25734 -p 78543






