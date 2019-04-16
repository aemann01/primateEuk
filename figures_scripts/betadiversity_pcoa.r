#betadiversity pcoa plot
#get data from qiime:
#beta_diversity.py -i swarm/swarm_otus.wtax.final.biom -o bdiv -t RAxML_bestTree.microeuk.tre
#principal_coordinates.py -i bdiv/weighted_unifrac_swarm_otus.wtax.final.txt -o bdiv/weighted_unifrac_swarm_otus.wtax.final.pc
#x and y coordinates for plot:
#cp bdiv/weighted_unifrac_swarm_otus.wtax.final.pc bdiv/pc1_pc2.txt
#remove other info, get only first two columns
#awk '{print $1, "\t", $2, "\t", $3}' bdiv/pc1_pc2.txt > pc1_pc2.txt


args = commandArgs(trailingOnly=TRUE)

library(ggplot2)

dat <- read.table(args[1], header=T, row.names=1)
map <- read.table("map.txt", header=T, row.names=1)
merge <- transform(merge(map, dat, by=0), row.names=Row.names)
pdf("weighted_bdiv_plot.pdf")
ggplot(dat, aes(x=merge$X, y=merge$Y, color=merge$Phyl_Group)) + geom_point(aes(shape=merge$Genus)) + theme_classic() + scale_shape_manual(values=1:13) + xlim(-6.5, 3.5) + ylim(-6.5,3.5) + xlab("PC1 (69.06%)") + ylab("PC2 (8.68%)") + coord_fixed()
dev.off()