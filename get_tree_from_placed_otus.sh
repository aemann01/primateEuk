#pull OTUs that make it into our reference alignment at 95% identity (reference trees made using euk ref pipeline)
cd /parfreylab/mann/primateEuk/eukref_trees
#entamoeba at 95% identity
grep -v "No search" archamoeba_placement/htes_aligned_entamoeba/entamoeba.denovo_log.txt | grep "denovo" | awk '{print $1}' > archamoeba_raxml/placement_entamoeba.ids
#iodamoeba at 95% identity
grep -v "No search" archamoeba_placement/htes_aligned_iodamoeba/iodamoeba.denovo_log.txt | grep "denovo" | awk '{print $1}' > archamoeba_raxml/placement_iodamoeba.ids

filter_fasta.py -f /parfreylab/mann/primateEuk/data/v4/swarm/rep_set.fa -s archamoeba_raxml/placement_entamoeba.ids -o archamoeba_raxml/placed_ent_otus.fa
filter_fasta.py -f /parfreylab/mann/primateEuk/data/v4/swarm/rep_set.fa -s archamoeba_raxml/placement_iodamoeba.ids -o archamoeba_raxml/placed_ioda_otus.fa
cat archamoeba_reference/reduced_ncbi.fasta archamoeba_raxml/placed_ent_otus.fa > archamoeba_raxml/fortree.ent.fa
cat archamoeba_reference/reduced_ncbi.fasta archamoeba_raxml/placed_ioda_otus.fa > archamoeba_raxml/fortree.ioda.fa

usearch10.0.240_i86linux32 -fastx_uniques archamoeba_raxml/fortree.ent.fa -fastaout archamoeba_raxml/fortree.ent.uniq.fa
usearch10.0.240_i86linux32 -fastx_uniques archamoeba_raxml/fortree.ioda.fa -fastaout archamoeba_raxml/fortree.ioda.uniq.fa

mafft --auto archamoeba_raxml/fortree.ent.uniq.fa > archamoeba_raxml/fortree.ent.align.fa
mafft --auto archamoeba_raxml/fortree.ioda.uniq.fa > archamoeba_raxml/fortree.ioda.align.fa

#######Stop here, first trim manually in CLC viewer and then clean up alignment with trimal
trimal -in archamoeba_raxml/for_tree.clctrim.ent.fa -out archamoeba_raxml/fortree.ent.trimal.fa -gt 0.3 -st 0.001
trimal -in archamoeba_raxml/for_tree.clctrim.ioda.fa -out archamoeba_raxml/fortree.ioda.trimal.fa -gt 0.3 -st 0.001
cd archamoeba_raxml/
raxmlHPC-PTHREADS-SSE3 -T 4 -m GTRCAT -c 25 -p 31415 -x 20398 -d -f a -N 100 -s fortree.ent.trimal.fa -n entamoeba.tre
raxmlHPC-PTHREADS-SSE3 -T 4 -m GTRCAT -c 25 -p 31415 -x 20398 -d -f a -N 100 -s fortree.ioda.trimal.fa -n iodamoeba.tre


