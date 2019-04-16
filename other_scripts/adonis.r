#adonis 
library("phyloseq");packageVersion("phyloseq")
library(ape)
library(vegan)
otu <- read.table("swarm/swarm_otus.wtax.final.nohash.txt", sep="\t", header=T, row.names=1)
otu <- as.matrix(otu)
map <- as.data.frame(read.table("map.txt", sep="\t", header=T, row.names=1))
map <- sample_data(map)
tre <- read.tree("RAxML_bestTree.microeuk.tre")
otutable <- otu_table(otu, taxa_are_rows=T)
physeq <- phyloseq(otutable)
physeq <- merge_phyloseq(physeq, tre, map)
metadata <- as(sample_data(physeq), "data.frame")
adonis(distance(physeq, method="bray") ~ Phyl_Group, data=metadata)

#additional test request from Flo
library(caper)
dat <- read.table("adiv_eukVSbac.txt", header=T, row.names=1)
comparative.data(phy="MammalTrees_fix.tre", dat=dat, names.col="Genus_species", vcv.dim=2, warn.dropped=T)
model<-pgls(observed_otus_bac ~ observed_otus_euks, data=comp.data, lambda=”ML”)
summary(model)

