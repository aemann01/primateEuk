# Biodiversity of protists and nematodes in the wild non-human primate gut microbiome
Allison E. Mann, Florent Mazel, Matthew A. Lemay, Evan Morien1, Vincent Billy, Martin Kowalewski, Anthony Di Fiore, Andrés Link, Tony L. Goldberg, Stacey Tecot, Andrea L. Baden, Andres Gomez, Michelle L. Sauther, Frank P. Cuozzo, Gillian A.O. Rice, Nathaniel J. Dominy, Rebecca Stumpf, Rebecca J. Lewis, Larissa Swedell, Katherine Amato, Laura Wegener Parfrey

## Figures scripts

| File        | Description           |
| ------------- |:-------------:|
| additional_supp_figures.r     | R code for Bray-Curtis dissimilarity PCoA, Aitchison distance PCA, Taxonomy specific weighted Unifrac PCoA |
| aitchison_distance.sh      | Bash script to generate Aitchison Biplot      | 
| bac_v_euk_correlation.r | R code for bacterial and eukaryotic alpha diversity correlation (not phylogenetically constrained)      |
| betadiversity_pcoa.r | R code to generate beta diversity plots      |
| dist_dend.r | R code to generate beta diversity cluster dendrograms     |
| epa_placement_ml_tree.sh | Bash script to generate EukRef reference trees, RAxML placement tree     |
| get_tree_from_placed_otus.sh | Basch script to pull OTUs for EPA tree      |
| iodamoeba_cluster.sh | Code to generate PID distance matrix     |
| phyloseq_tree.r | R code to generate PhyloSeq trees     |
| taxonomy_barchart.r | R code to generate taxonomy plots, histograms of read counts, histogram of proportion gut    |
| upset.r | R code to generate upset plot     |

## Other scripts

| File        | Description           |
| ------------- |:-------------:|
| adonis.r      | R code adonis test |
| combos.py      | Silly python script, calculates the number of possible combinations of a read n bases long      | 
| distance_matrix_calc.py | Python script, generates distance matrix from aligned fasta      |
| genbankparse.py | Python script, pull metadata from genbank file     |
| subset_biom.sh | Bash script, subsets a biom file     |


## Preprocessing scripts

| File        | Description           |
| ------------- |:-------------:|
| preprocessing_16S.sh      | Bash script, process 16S amplicon data using SWARM |
| preprocessing_18S.sh      | Bash script, process 18S amplicon data using SWARM      | 
| unassigned_processing.sh | Bash script, process reads that could not be assigned a taxonomy using the SILVA 128 database      |

## Swarm

| File        | Description           |
| ------------- |:-------------:|
| swarm_otus.wtax.file.txt     | OTU table with taxonomy after filtering |
| swarm_otus.wtax.txt | Full OTU table with taxonomy unfiltered      |
| map.txt      | Metadata file     | 

## Supplementary tables

| Table        | 
| ------------- |
| 1 Sample metadata      | 
| 2 Read processing statistics       | 
| 3 Filtered OTU table with taxonomy and environment     | 
| 4 Bacterial OTU table rarified to 5k reads      | 
| 5 Blastocystis LEfSe results      | 
| 6 Nematoda LEfSe results      | 
| 7 Entamoeba LEfSe results      | 



