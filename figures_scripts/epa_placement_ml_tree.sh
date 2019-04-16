# Build a phylogenetic tree using RAxML EPA placement, then build ML tree from reads that align to the reference tree at 95% similarity
# Modified from EukRef HTES and curation pipeline
# Required programs: usearch, mafft, trimal, raxml, QIIME 1.9

REFS=/parfreylab/mann/primateEuk/eukref_trees/archamoeba_reference/reference.amoeba.fa
SEQS=/parfreylab/mann/primateEuk/eukref_trees/archamoeba_placement/amoeba.denovo.fa

######################
#Reference tree build
######################
#first need to build your reference tree, get references from NCBI
#search term: txidXXXX[Organism:exp] (18S OR SSU) NOT (mitochondrial OR mitochondria OR complete genome OR shotgun OR chromosome)
# sort and cluster these to reduce input seq 
usearch10.0.240_i86linux32 -sortbylength $REFS -fastaout refsort.fa -minseqlength 200 
usearch10.0.240_i86linux32 -cluster_smallmem refsort.fa -id 0.99 -centroids refcluster_99.fa -uc refcluster_99.uc -notrunclabels

#align using mafft
mafft --reorder --auto refcluster_99.fa > refalign.fa 

#clean up alignment, gap threshold 99%, min average similarity 0.001 
trimal -in refalign.fa -out reftrimal.fa -gt 0.99 -st 0.001

#build initial reference tree, 100 bootstraps
raxmlHPC-PTHREADS-SSE3 -T 4 -m GTRCAT -c 25 -e 0.001 -p 31415 -f a -N 100 -x 02938 -n ref.tre -s reftrimal.fa

#check this tree with figtree, make sure it looks ok

######################
#EPA tree build
######################
#align your (unaligned) sequences to your curated reference alignment (not the trimmed one)
#output of align_seqs.py gives you failed fasta file -- check this, if there are a lot of failed -- lower PID threshold
align_seqs.py -i $SEQS -t refalign.fa -o htes_aligned -p 95
cat htes_align/amoeba.denovo_aligned.fasta refalign.fa > queryalign_plus_refalign.fa
#clean up alignment 
trimal -in queryalign_plus_refalign.fa -out queryalign_plus_refalign.trimal.fa -gt 0.99 -st 0.001

#build epa tree
raxmlHPC-PTHREADS-SSE3 -f v -G 0.2 -m GTRCAT -n epa.tre -s queryalign_plus_refalign.trimal.fa -t RAxML_bestTree.ref.tre -T 4

#clean up tree so you can read into figtree
sed 's/QUERY___//g' RAxML_labelledTree.epa.tre | sed 's/\[I[0-9]*\]//g' > RAxML_placementTree.epa.tre

#check this in figtree, remove weird sequences, once happy with placement tree, build final tree

######################
#Final tree build
######################
raxmlHPC-PTHREADS-SSE3 -T 4 -m GTRCAT -c 25 -e 0.001 -p 31415 -f a -N 100 -x 02938 -s queryalign_plus_refalign.trimal.fa -n full.tre

