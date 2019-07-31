# Build a phylogenetic tree using RAxML EPA placement, then build ML tree from reads that align to the reference tree at 95% similarity
# Modified from EukRef HTES and curation pipeline
# Required programs: usearch, mafft, trimal, raxml, QIIME 1.9

REFS=/Users/mann/github/primateEuk/new_iodamoeba_tree/ref.fa
SEQS=/Users/mann/github/primateEuk/new_iodamoeba_tree/iodamoeba.fa

######################
#Reference tree build
######################
#first need to build your reference tree, get references from NCBI
#search term: txidXXXX[Organism:exp] (18S OR SSU OR small subunit) NOT (mitochondrial OR mitochondria OR complete genome OR shotgun OR chromosome)
# sort and cluster these to reduce input seq 
echo "Clustering reference sequences"
usearch -sortbylength $REFS -fastaout refsort.fa -minseqlength 200 
usearch -cluster_smallmem refsort.fa -id 0.97 -centroids refcluster_97.fa -uc refcluster_97.uc

#align using mafft
echo "Aligning reference sequences"
mafft --reorder --auto refcluster_97.fa > refalign.fa 

#clean up alignment, gap threshold 99%, min average similarity 0.001 
echo "Trimming"
trimal -in refalign.fa -out reftrimal.fa -gt 0.3 -st 0.001

#build initial reference tree, 100 bootstraps
echo "Building reference tree"
raxmlHPC-PTHREADS-SSE3 -T 4 -m GTRCAT -c 25 -e 0.001 -p 31415 -f a -N 100 -x 02938 -n ref.tre -s reftrimal.fa

#check this tree with figtree, make sure it looks ok, if not revise and repeat

######################
#EPA tree build
######################
#align your (unaligned) sequences to your curated reference alignment (not the trimmed one)
echo "Aligning sequences to reference alignment"
align_seqs.py -i $SEQS -t refalign.fa -o htes_aligned -p 10 
cat htes_aligned/iodamoeba_aligned.fasta refalign.fa > queryalign_plus_refalign.fa
#build epa tree
echo "EPA tree building"
raxmlHPC-PTHREADS-SSE3 -f v -G 0.2 -m GTRCAT -n epa.tre -s queryalign_plus_refalign.fa -t RAxML_bestTree.ref.tre -T 4

#clean up tree so you can read into figtree
sed 's/QUERY___//g' RAxML_labelledTree.epa.tre | sed 's/\[I[0-9]*\]//g' > RAxML_placementTree.epa.tre

#get alignment for network, hard trim
filter_fasta.py -f queryalign_plus_refalign.fa -s for_network.ids -o for_network.align.fa
trimal -in for_network.align.fa -out for_network.trimal.fa -gt 0.9 -st 0.001
seqmagick convert --output-format nexus --alphabet dna for_network.trimal.fa for_network.trimal.nex
grep "denovo" test.log | awk '{print $1}' | sort | uniq > wanted.ids # what reads are making it into the file?
cat wanted.ids | while read line; do grep -w $line ../swarm/swarm_otus.wtax.final.txt ; done > iodamoeba_traits.txt



