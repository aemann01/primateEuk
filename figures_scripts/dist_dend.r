#!/usr/bin/env Rscript
#script generates a weighted unifrac pcoa and dendogram
#Use: Rscript input_freq_table.txt output_pcoa.pdf output_dendogram.pdf

args = commandArgs(trailingOnly=TRUE)

library("phyloseq");packageVersion("phyloseq")
library(ape)
library(ggplot2)
library(ggdendro)
library(gridExtra)
library(dendextend)
library(phangorn)

taxa <- as.matrix(read.table(args[1], header=T, sep="\t", row.names=1))
taxa.md <- read.table("map.txt", header=T, sep="\t", row.names=1)
tree <- read.tree("RAxML_bestTree.microeuk.tre")
tree <- midpoint(tree)
otutable <- otu_table(taxa, taxa_are_rows=T)
map <- sample_data(data.frame(taxa.md))
physeq <- phyloseq(otutable)
physeq <- merge_phyloseq(physeq, tree, map)

#generate pcoa plot
# pdf(args[2])
# plot_ordination(physeq, ordinate(physeq, "PCoA", "unifrac", weighted = TRUE), color="Phyl_Group", shape="Genus") + theme_classic() + coord_fixed() + scale_shape_manual(values=1:13)
# dev.off()

#generate dendogram
wuni <- UniFrac(physeq, weighted=T, normalized=F)
hc <- hclust(wuni)

df2 <- data.frame(cluster=cutree(hc,6), states=factor(hc$labels, levels=hc$labels[hc$order]))
#p1 <- ggdendrogram(hc, rotate = FALSE, size = 2, ylim=c(0.0,20.0)) 

hcd <- as.dendrogram(hc)
dend_data <- dendro_data(hcd, type="rectangle")
p1 <- ggplot(dend_data$segments) + geom_segment(aes(x=x,y=y, xend=xend, yend=yend)) + theme_classic() + geom_text(data = dend_data$labels, aes(x, y, label = label), hjust = 1, angle = 90, size = 3) + ylim(-2,20) + xlab("") + ylab("") + theme(axis.text.x=element_blank(), axis.ticks.x=element_blank())

merge <- transform(merge(df2, map, by=0), row.names=Row.names)
p2 <- ggplot(merge, aes(states, y=1, fill=factor(merge$Phyl_Group))) + geom_tile() + scale_y_continuous(expand=c(0,0)) + theme(axis.title=element_blank(), axis.ticks=element_blank(), axis.text=element_blank(), legend.position="none")
#p3 <- ggplot(merge, aes(states, y=1, fill=factor(cluster))) + geom_tile() + scale_y_continuous(expand=c(0,0)) + theme(axis.title=element_blank(), axis.ticks=element_blank(), axis.text=element_blank(), legend.position="none")

gp1<-ggplotGrob(p1)
gp2<-ggplotGrob(p2)
#gp3<-ggplotGrob(p3)

maxWidth = grid::unit.pmax(gp1$widths[2:5], gp2$widths[2:5])
#maxWidth = grid::unit.pmax(gp1$widths[2:5], gp2$widths[2:5], gp3$widths[2:5])
gp1$widths[2:5] <- as.list(maxWidth)
gp2$widths[2:5] <- as.list(maxWidth)
#gp3$widths[2:5] <- as.list(maxWidth)

#pdf(args[3])
grid.arrange(gp1, gp2, ncol=1,heights=c(4/5,1/5,1/5))
dev.off()