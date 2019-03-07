#bacteria vs eukaryotic alpha diversity correlation plot
#calculate alpha diversity statistics from qiime alpha_diversity.py and merge together adiv from bacterial data
library(ggplot2)

dat <- read.table("adiv_eukVSbac.txt", header=T)

pdf("euk_v_bac_correlation.pdf")
ggplot(dat, aes(dat$PD_whole_tree_bac, dat$PD_whole_tree_euk)) + geom_point(aes(color=dat$Phylgroup, shape=dat$Genus)) + theme_classic() + scale_shape_manual(values=c(1:7,9:13)) + geom_smooth(method='lm',formula=y~x, color="black") + coord_fixed()
dev.off()