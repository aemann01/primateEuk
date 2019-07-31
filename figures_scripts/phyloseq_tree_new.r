library("phyloseq");packageVersion("phyloseq")
library(ggplot2)
library(ape)

otu <- read.table("../swarm/entamoeba_in_tree.txt", sep="\t", header=T, row.names=1)
otu <- as.matrix(otu)

#read in mapping file, set as sample data type
map <- as.data.frame(read.table("../swarm/map.txt", sep="\t", header=T, row.names=1))
map <- sample_data(map)
tre <- read.tree("entamoeba.tre")

otutable <- otu_table(otu, taxa_are_rows=T)
physeq <- phyloseq(otutable)
physeq <- merge_phyloseq(physeq, tre, map)

#entamoeba tree
pdf("entamoeba_phyloseq_tree.pdf")
plot_tree(physeq, color="Species", ladderize="left", base.spacing=0.05, justify="left")
dev.off()

#nematode tree
otu <- read.table("nematodes_in_tree.txt", sep="\t", header=T, row.names=1)
otu <- as.matrix(otu)
tre <- read.tree("pruned_constraint.tre")
otutable <- otu_table(otu, taxa_are_rows=T)
physeq <- phyloseq(otutable)
physeq <- merge_phyloseq(physeq, tre, map)

pdf("nematode_phyloseq_tree.pdf")
plot_tree(physeq, color="Species", justify="left", base.spacing=0.05, ladderize="left") 
dev.off()