##########################
#Additional supp figures
##########################
#bray curtis PCOA
# cd /parfreylab/mann/primateEuk/data/v4/swarm
# beta_diversity.py -i swarm_otus.wtax.final.biom -o bdiv/ -m bray_curtis -t ../tree/RAxML_bestTree.microeuk.tre
# principal_coordinates.py -i bdiv/bray_curtis_swarm_otus.wtax.final.txt -o bdiv/bray_curtis_swarm_otus.wtax.final.pc
# make_2d_plots.py -i bdiv/bray_curtis_swarm_otus.wtax.final.pc -o bdiv/2dplot_bc -m /parfreylab/mann/primateEuk/map.fix.txt

#use the pc from this to generate plot in R

library(ggplot2)

dat <- read.table("bray_curtis_swarm_otus.wtax.final.pc", header=F, row.names=1)
map <- read.table("/Users/mann/github/primateEuk/swarm/map.txt", header=T, row.names=1)
merge <- transform(merge(map, dat, by=0), row.names=Row.names)
pdf("braycurtis_bdiv_plot.pdf")
ggplot(dat, aes(x=merge$V2, y=merge$V3, color=merge$Phyl_Group)) + geom_point(aes(shape=merge$Genus)) + theme_classic() + scale_shape_manual(values=1:13) + xlim(-0.4, 0.7) + ylim(-0.4,0.7) + xlab("PC1 (6.47%)") + ylab("PC2 (5.75%)") + coord_fixed()
dev.off()

#pcoa plots of weighted unifrac looking at just amoebozoa, fungi, or nematodes
# filter_taxa_from_otu_table.py -i swarm/swarm_otus.wtax.final.biom -o swarm/swarm_otus.wtax.amoebozoa.biom -p Amoebozoa
# filter_taxa_from_otu_table.py -i swarm/swarm_otus.wtax.final.biom -o swarm/swarm_otus.wtax.nematodes.biom -p Nematoda
# filter_taxa_from_otu_table.py -i swarm/swarm_otus.wtax.final.biom -o swarm/swarm_otus.wtax.fungi.biom -p Fungi
# beta_diversity.py -i swarm/swarm_otus.wtax.amoebozoa.biom -o bdiv/ -t RAxML_bestTree.microeuk.tre
# beta_diversity.py -i swarm/swarm_otus.wtax.fungi.biom -o bdiv/ -t RAxML_bestTree.microeuk.tre
# beta_diversity.py -i swarm/swarm_otus.wtax.nematodes.biom -o bdiv/ -t RAxML_bestTree.microeuk.tre
# principal_coordinates.py -i bdiv/weighted_unifrac_swarm_otus.wtax.amoebozoa.txt -o bdiv/weighted_unifrac_swarm_otus.wtax.amoebozoa.pc
# principal_coordinates.py -i bdiv/weighted_unifrac_swarm_otus.wtax.fungi.txt -o bdiv/weighted_unifrac_swarm_otus.wtax.fungi.pc
# principal_coordinates.py -i bdiv/weighted_unifrac_swarm_otus.wtax.nematodes.txt -o bdiv/weighted_unifrac_swarm_otus.wtax.nematodes.pc

#now can generate plots (these basically show us the same information as the dendrograms but in a different way)
dat <- read.table("bdiv/weighted_unifrac_swarm_otus.wtax.amoebozoa.pc", header=F, row.names=1)
merge <- transform(merge(map, dat, by=0), row.names=Row.names)
pdf("bdiv/amoebozoa_bdiv_plot.pdf")
ggplot(dat, aes(x=merge$V2, y=merge$V3, color=merge$Phyl_Group)) + geom_point(aes(shape=merge$Genus)) + theme_classic() + scale_shape_manual(values=1:13) + xlab("PC1 (71.47%)") + ylab("PC2 (11.77%)") + coord_fixed() + xlim(-10, 15) + ylim(-10,15)
dev.off()

dat <- read.table("bdiv/weighted_unifrac_swarm_otus.wtax.fungi.pc", header=F, row.names=1)
merge <- transform(merge(map, dat, by=0), row.names=Row.names)
pdf("bdiv/fungi_bdiv_plot.pdf")
ggplot(dat, aes(x=merge$V2, y=merge$V3, color=merge$Phyl_Group)) + geom_point(aes(shape=merge$Genus)) + theme_classic() + scale_shape_manual(values=1:13) + xlab("PC1 (42.88%)") + ylab("PC2 (20.92%)") + coord_fixed() + xlim(-2, 1) + ylim(-2,1)
dev.off()

dat <- read.table("bdiv/weighted_unifrac_swarm_otus.wtax.nematodes.pc", header=F, row.names=1)
merge <- transform(merge(map, dat, by=0), row.names=Row.names)
pdf("bdiv/nematode_bdiv_plot.pdf")
ggplot(dat, aes(x=merge$V2, y=merge$V3, color=merge$Phyl_Group)) + geom_point(aes(shape=merge$Genus)) + theme_classic() + scale_shape_manual(values=1:13) + xlab("PC1 (36.25%)") + ylab("PC2 (26.55%)") + coord_fixed() + xlim(-3, 3) + ylim(-3,3)
dev.off()

#alpha diversity boxplots by genus
dat <- read.table("adiv.txt", header=T, row.names=1)
pdf("adiv_byGenus.pdf")
ggplot(dat, aes(x=dat$Genus, y=dat$observed_otus), color=dat$Phylogroup) + geom_boxplot() + geom_jitter() + theme_classic()
dev.off()

