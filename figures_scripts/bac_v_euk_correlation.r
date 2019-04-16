#bacteria vs eukaryotic alpha diversity correlation plot
#calculate alpha diversity statistics from qiime alpha_diversity.py and merge together adiv from bacterial data
#alpha_diversity.py -i /parfreylab/mann/primateEuk/data/v4/swarm/swarm_otus.wtax.final.biom -t /parfreylab/mann/primateEuk/data/v4/tree/RAxML_bestTree.microeuk.tre -o adiv.euks.txt
#merge bac and euk alpha diversity and add genus/phylo information

library(ggplot2)

dat <- read.table("adiv_eukVSbac.txt", header=T)
test <- cor.test(dat$observed_otus_bac, dat$observed_otus_euks)
print(test)
pdf("euk_v_bac_correlation.pdf")
ggplot(dat, aes(dat$observed_otus_bac, dat$observed_otus_euks)) + geom_point(aes(color=dat$Phylgroup, shape=dat$Genus)) + theme_classic() + scale_shape_manual(values=c(1:7,9:13)) + geom_smooth(method='lm',formula=y~x, color="black") + coord_fixed()
dev.off()