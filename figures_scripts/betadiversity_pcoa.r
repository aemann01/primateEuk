#betadiversity pcoa plot
#get data from qiime:
#single_rarefaction.py -i swarm/swarm_otus.wtax.final.biom -o swarm/swarm_otus.wtax.final.d500.biom -d 500
#beta_diversity.py -i swarm/swarm_otus.wtax.final.d500.biom -o bdiv -t RAxML_bestTree.microeuk.tre
#alpha_diversity.py -i swarm/swarm_otus.wtax.final.d500.biom -o adiv.txt -t RAxML_bestTree.microeuk.tre
#principal_coordinates.py -i bdiv/weighted_unifrac_swarm_otus.wtax.final.d500.txt -o bdiv/weighted_unifrac_swarm_otus.wtax.final.d500.pc
#principal_coordinates.py -i bdiv/unweighted_unifrac_swarm_otus.wtax.final.d500.txt -o bdiv/unweighted_unifrac_swarm_otus.wtax.final.d500.pc
#x and y coordinates for plot:
#cp bdiv/weighted_unifrac_swarm_otus.wtax.final.d500.pc bdiv/weighted_pc1_pc2.txt
#cp bdiv/unweighted_unifrac_swarm_otus.wtax.final.d500.pc bdiv/unweighted_pc1_pc2.txt
#remove other info, get only first two columns
#awk '{print $1, "\t", $2, "\t", $3}' bdiv/weighted_pc1_pc2.txt > wpc1_pc2.txt
#awk '{print $1, "\t", $2, "\t", $3}' bdiv/unweighted_pc1_pc2.txt > uwpc1_pc2.txt
library(ggplot2)

dat <- read.table("new_diversity_analyses/wpc1_pc2.txt", header=T, row.names=1)
map <- read.table("map.txt", header=T, row.names=1)
merge <- transform(merge(map, dat, by=0), row.names=Row.names)
pdf("weighted_bdiv_plot.pdf")
ggplot(dat, aes(x=merge$PC1, y=merge$PC2, color=merge$Phyl_Group)) + geom_point(aes(shape=merge$Genus)) + theme_classic() + scale_shape_manual(values=c(1,2,3,4,5,7,9,10,11,12,13)) + coord_fixed() + xlim(-5.5,5) + ylim(-5.5,5) + xlab("PC1 (69.75%)") + ylab("PC2 (10.02%)")
dev.off()

#unweighted plot
dat <- read.table("new_diversity_analyses/uwpc1_pc2.txt", header=T, row.names=1)
merge <- transform(merge(map, dat, by=0), row.names=Row.names)
pdf("unweighted_unifrac_bdiv.pdf")
ggplot(dat, aes(x=merge$PC1, y=merge$PC2, color=merge$Phyl_Group)) + geom_point(aes(shape=merge$Genus)) + theme_classic() + scale_shape_manual(values=c(1,2,3,4,5,7,9,10,11,12,13)) + coord_fixed() + xlim(-0.4,0.5) + ylim(-0.4,0.5) + xlab("PC1 (20.44%)") + ylab("PC2 (18.14%)")
dev.off()

#bray curtis plot
# cd /parfreylab/mann/primateEuk/data/v4/swarm
# beta_diversity.py -i swarm/swarm_otus.wtax.final.d500.biom -o new_diversity_analyses/bdiv/ -m bray_curtis -t RAxML_bestTree.microeuk.tre
# principal_coordinates.py -i new_diversity_analyses/bdiv/bray_curtis_swarm_otus.wtax.final.d500.txt -o new_diversity_analyses/bdiv/bray_curtis_swarm_otus.wtax.final.d500.pc
dat <- read.table("new_diversity_analyses/bdiv/bray_curtis_swarm_otus.wtax.final.d500.pc", header=F, row.names=1)
merge <- transform(merge(map, dat, by=0), row.names=Row.names)
pdf("braycurtis_bdiv_plot.pdf")
ggplot(dat, aes(x=merge$V2, y=merge$V3, color=merge$Phyl_Group)) + geom_point(aes(shape=merge$Genus)) + theme_classic() + scale_shape_manual(values=c(1,2,3,4,5,7,9,10,11,12,13)) + xlim(-0.4, 0.65) + ylim(-0.4,0.65) + xlab("PC1 (8.89%)") + ylab("PC2 (7.31%)") + coord_fixed()
dev.off()

#aitchison plot
dat <- read.table("aitchison_distance.txt", header=T, row.names=1)
merge <- transform(merge(map, dat, by=0), row.names=Row.names)
pdf("aitchison_bdiv_plot.pdf")
ggplot(dat, aes(x=merge$x, y=merge$y, color=merge$Phyl_Group)) + geom_point(aes(shape=merge$Genus)) + theme_classic() + scale_shape_manual(values=c(1:7,9:13)) + xlab("PC1 (55.82%)") + ylab("PC2 (29.82%)") + coord_fixed() + xlim(-0.4, 0.5) + ylim(-0.4,0.5)
dev.off()

#euk vs bac alpha diversity correlation
dat <- read.table("adiv_forFlo.txt", header=T)
test <- cor.test(dat$observed_otus_bac, dat$observed_otus_euks)
print(test)
# 	Pearson's product-moment correlation

# data:  dat$observed_otus_bac and dat$observed_otus_euks
# t = 3.0704, df = 40, p-value = 0.003832
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#  0.1531259 0.6538707
# sample estimates:
#       cor 
# 0.4367318 
pdf("euk_v_bac_correlation.pdf")
ggplot(dat, aes(dat$observed_otus_bac, dat$observed_otus_euks)) + geom_point(aes(color=dat$Phylogroup, shape=dat$Genus)) + theme_classic() + scale_shape_manual(values=c(1,2,3,4,5,7,9,10,11,12,13)) + geom_smooth(method='lm',formula=y~x, color="black")
dev.off()