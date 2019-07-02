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

#generate histograms of each sample representing log post filtered read count and proportion of known gut taxa to add to composition figure
#log counts post filter
counts <- read.table("table_for_taxonomy_barchart_ordered.txt", sep="\t", header=T)
pdf("log_counts_for_taxplot.pdf")
ggplot(counts, aes(x=counts$SampleID, y=log(counts$PostDietaryFilter))) + geom_bar(stat="identity") + coord_flip() + scale_y_continuous(limits=c(0,12), breaks = seq(0, 12, by = 2)) + theme_classic()
dev.off()
#prop expected gut 
pdf("propgut_for_taxplot.pdf")
ggplot(counts, aes(x=counts$SampleID, y=counts$PropGut)) + geom_bar(stat="identity") + coord_flip() + scale_x_discrete(limits=counts$SampleID) + theme_classic()
dev.off()

ggplot(counts, aes(x=counts$SampleID, y=counts$PropGut)) + geom_bar(stat="identity") + scale_x_discrete(limits=counts$SampleID) + theme_classic()

#for environmental source
dat <- read.table("environ_source_forBarchart.txt", sep="\t", header=T)
datmelt <- melt(dat)
pdf("source_barchart.pdf")
ggplot(datmelt, aes(fill=datmelt$Environment, x=datmelt$variable, y=datmelt$value)) + geom_bar(stat="identity", position="fill") + theme_classic()
dev.off()

#sample order for barchart
# AsenLink2
# AsenLink1
# AsenLink3
# AsenLink5
# APF38
# APF37
# APF39
# LagEllis5
# LagEllis1
# LagAb2
# LagEllis4
# LagEllis3
# Ahyb1000
# Ahyb135
# AtbelzLink2
# AtbelzLink4
# AtbelzLink1
# Gor11
# Gor12
# Ptr10
# Ptr1
# Ptr14
# Ptr11
# Ptr13
# Jb1
# Jb13
# jb15
# Jb17
# Jb18
# Jb10
# Jb12
# Jb24
# Jb25
# Jb28
# Jb3
# Jb27
# Jb29
# Jb32
# Jb34
# RT2048
# RT2021
# RT2013
# RT2019
# RT2017
# BWC2063
# BWC2115
# RC2036
# RC2096
# RC2071
# RC2068
# RC2098
# PVPet
# PVLou
# PVAbb
# PVPan
# PvQui
# ERUB101M
# ERUB104M
# EBRUB105M
# ERUB102M
# ERUB06M