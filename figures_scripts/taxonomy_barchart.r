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
# Ptr14
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
# RC2068
# RC2096
# rc2071
# rc2068
# rc2098
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