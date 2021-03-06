# Build a phylogenetic tree using RAxML EPA placement, then build ML tree from reads that align to the reference tree at 95% similarity
# Modified from EukRef HTES and curation pipeline
# Required programs: usearch, mafft, trimal, raxml, QIIME 1.9

REFS=/parfreylab/mann/primateEuk/eukref_trees/archamoeba_reference/reference.fa
SEQS=/parfreylab/mann/primateEuk/eukref_trees/archamoeba_placement/denovo.fa

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
cat collapse.ids | sort | uniq | while read line; do grep -w $line $SEQS -A 1 ; done > collapse.fa
align_seqs.py -i $SEQS -t refalign.fa -o htes_aligned -p 10 # low PID to ensure all OTUs are incorporated in the placement tree
cat htes_aligned/collapse_aligned.fasta refalign.fa > queryalign_plus_refalign.fa
#build epa tree
echo "EPA tree building"
raxmlHPC-PTHREADS-SSE3 -f v -G 0.2 -m GTRCAT -n epa.tre -s queryalign_plus_refalign.fa -t RAxML_bestTree.ref.tre -T 4

#clean up tree so you can read into figtree
sed 's/QUERY___//g' RAxML_labelledTree.epa.tre | sed 's/\[I[0-9]*\]//g' > RAxML_placementTree.epa.tre

#######################
#Constraint tree build
#######################
raxmlHPC-PTHREADS-SSE3 -f a -N 100 -G 0.2 -m GTRCAT -n fullepa.tre -s queryalign_plus_refalign.fa -g RAxML_bestTree.ref.tre -T 4 -x 25734 -p 25793

#now pass to phyloseq_tree.r
