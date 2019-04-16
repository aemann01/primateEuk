library("phyloseq");packageVersion("phyloseq")
library(ggplot2)
library(ape)

otu <- read.table("swarm/swarm_otus.wtax.final.nohash.txt", sep="\t", header=T, row.names=1)
otu <- as.matrix(otu)
#only display individuals who have N or more reads assigned to a particular node
#otu[otu<50] <- 0
#remove rows with only zeros
otu <- otu[which(rowSums(otu) > 0),] 
#write out to be used outside script
temp <- as.data.frame(otu)
write.table(temp, file="abundance_filtered.otus.txt", quote=F, sep="\t")
rm(temp)

#read in mapping file, set as sample data type
map <- as.data.frame(read.table("map.txt", sep="\t", header=T, row.names=1))
map <- sample_data(map)

#iodamoeba tree
#now using reduced alignment tree from here: /parfreylab/mann/primateEuk/iodamoeba_heatmap
tre <- read.tree("iodamoeba.tree")
tre <- root(tre, outgroup="JN635740.1")
otutable <- otu_table(otu, taxa_are_rows=T)
physeq <- phyloseq(otutable)
physeq <- merge_phyloseq(physeq, tre, map)

pdf("iodamoeba_phyloseq_tree.pdf")
plot_tree(physeq, color="Species", ladderize="left", label.tips="taxa_names",  size="abundance", base.spacing=0.05) + scale_shape_manual(values=c(2, 3, 10))
dev.off()

#entamoeba tree
tre <- read.tree("RAxML_bipartitions.entamoeba.trim.tre")
tre <- root(tre, outgroup="AB550910.1")
physeq <- phyloseq(otutable)
physeq <- merge_phyloseq(physeq, tre, map)

pdf("entamoeba_phyloseq_tree_shapes.pdf")
plot_tree(physeq, color="Phyl_Group", shape="Genus", ladderize="left", label.tips="taxa_names", base.spacing=0.03, nodelabf=nodeplotboot(lowcthresh=70)) + scale_shape_manual(values=c(3,9,10,11,12))
dev.off()

#entamoeba tree just colored
pdf("entamoeba_phyloseq_tree.pdf")
plot_tree(physeq, color="Species", ladderize="left", base.spacing=0.05, nodelabf=nodeplotblank, justify="left")
dev.off()

#nematode tree
#for nematodes, allow a min of 10 reads per sample
otu <- read.table("swarm/swarm_otus.wtax.final.nohash.txt", sep="\t", header=T, row.names=1)
otu <- as.matrix(otu)
#only display individuals who have N or more reads assigned to a particular node
#otu[otu<10] <- 0
#remove rows with only zeros
#otu <- otu[which(rowSums(otu) > 0),] 

tre <- read.tree("RAxML_bipartitions.nematode.trim.tre")
physeq <- phyloseq(otutable)
physeq <- merge_phyloseq(physeq, tre, map)

pdf("nematode_phyloseq_tree.pdf")
plot_tree(physeq, color="Phyl_Group", shape="Genus", ladderize="left", label.tips="taxa_names", base.spacing=0.03, nodelabf=nodeplotboot(lowcthresh=70), justify="left") + scale_shape_manual(values=c(1,2,3,4,5,7,9,10,11,12))
dev.off()