####################
#taxonomy barchart
####################
library(reshape2)
library(ggplot2)
dat <- read.table("simplified_taxonomy.txt", sep="\t", header=T)
datmelt <- melt(dat)
pdf("taxonomy_barchart.pdf")
ggplot(datmelt, aes(fill=datmelt$taxonomy, x=datmelt$variable, y=datmelt$value)) + geom_bar(stat="identity", position="fill") + theme_classic()
dev.off()

#for environmental source
dat <- read.table("environ_source_forBarchart.txt", sep="\t", header=T)
datmelt <- melt(dat)
pdf("source_barchart.pdf")
ggplot(datmelt, aes(fill=datmelt$Environment, x=datmelt$variable, y=datmelt$value)) + geom_bar(stat="identity", position="fill") + theme_classic()
dev.off()