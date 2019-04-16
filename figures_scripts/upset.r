#first need to filter biom table by those otus that made it into the entamoeba placement tree (raxml version has only placement otus)
# sed 's/:/\n/g' RAxML_bipartitions.entamoeba.trim.tre | grep "denovo" | awk -F"," '{print $2}' | sed 's/(//g' > entamoeba_denovo_in_tree.ids
#then filter biom table to only include those otus
# filter_otus_from_otu_table.py -i swarm/swarm_otus.wtax.final.biom -o swarm/entamoeba_in_tree.biom --negate_ids_to_exclude -e entamoeba_denovo_in_tree.ids
#convert to tsv
# biom convert -i swarm/entamoeba_in_tree.biom -o swarm/entamoeba_in_tree.txt --to-tsv --table-type="OTU table"
#fix header and run code below

library(UpSetR)

#read in data and mapping file
dat <- as.matrix(read.table("swarm/entamoeba_in_tree.txt", header=T, sep="\t", row.names=1))
map <- as.matrix(read.table("map.txt", header=T, sep="\t", row.names=1))
#transpose data, merge by row names
dat.t <- t(dat)
merged <- merge(dat.t, map, by="row.names")
n <- ncol(dat.t) + 1
agg <- aggregate(merged[,2:n], by=list(merged$Species), FUN=sum)
#rownames(agg) <- agg$Group.1

#remove columns with only zeros
agg <- agg[,colSums(agg !=0) > 0]

#convert to presence absence table -- ignore warnining message, still works
agg[agg>1] <- 1
#transpose again
agg <- setNames(data.frame(t(agg[,-1])), agg[,1])

#upsetR -- ignore gorilla and lemur since they don't have anything
pdf("entamoeba_upset.pdf", onefile=F)
upset(agg, sets=c("seniculus", "pigra", "hybridus", "belzebuth", "troglodytes", "hamadryas", "anubis", "gelada", "ascanius", "badius", "verreauxi"), keep.order=T, order.by="freq", mainbar.y.label="Number of phylotypes", sets.x.label="Phylotypes per species", mb.ratio = c(0.55, 0.45))
dev.off()

#now for species subset
#open tree in archaeoptryx, pull ids from each clade of interest and save to text file
# grep "denovo" ecoli_in_tree.ids | awk '{print $1}' > ecoli_in_tree.denovo.ids
# grep "denovo" ehartmanni_in_tree.ids | awk '{print $1}' > ehartmanni_in_tree.denovo.ids
# filter_otus_from_otu_table.py -i swarm/swarm_otus.wtax.final.biom -o ecoli_in_tree.denovo.biom --negate_ids_to_exclude -e ecoli_in_tree.denovo.ids
# filter_otus_from_otu_table.py -i swarm/swarm_otus.wtax.final.biom -o ehartmanni_in_tree.denovo.biom --negate_ids_to_exclude -e ehartmanni_in_tree.denovo.ids
# biom convert -i ecoli_in_tree.denovo.biom -o ecoli_in_tree.denovo.txt --to-tsv --table-type="OTU table"
# biom convert -i ehartmanni_in_tree.denovo.biom -o ehartmanni_in_tree.denovo.txt --to-tsv --table-type="OTU table"
#clean up headers and load into r
library(UpSetR)

#read in data and mapping file
dat <- as.matrix(read.table("ecoli_in_tree.denovo.txt", header=T, sep="\t", row.names=1))
map <- as.matrix(read.table("map.txt", header=T, sep="\t", row.names=1))
dat.t <- t(dat)
merged <- merge(dat.t, map, by="row.names")
n <- ncol(dat.t) + 1
agg <- aggregate(merged[,2:n], by=list(merged$Species), FUN=sum)
#remove columns with only zeros
agg <- agg[,colSums(agg !=0) > 0]
#convert to presence absence table -- ignore warnining message, still works
agg[agg>1] <- 1
#transpose again
agg <- setNames(data.frame(t(agg[,-1])), agg[,1])

pdf("ecoli_upset.pdf", onefile=F)
upset(agg, sets=c("seniculus", "pigra", "hybridus", "troglodytes", "hamadryas", "anubis", "gelada", "ascanius", "badius"), keep.order=T, order.by="freq", mainbar.y.label="Number of phylotypes", sets.x.label="Phylotypes per species", mb.ratio = c(0.55, 0.45))
dev.off()

dat <- as.matrix(read.table("ehartmanni_in_tree.denovo.txt", header=T, sep="\t", row.names=1))
dat.t <- t(dat)
merged <- merge(dat.t, map, by="row.names")
n <- ncol(dat.t) + 1
agg <- aggregate(merged[,2:n], by=list(merged$Species), FUN=sum)
#remove columns with only zeros
agg <- agg[,colSums(agg !=0) > 0]
#convert to presence absence table -- ignore warnining message, still works
agg[agg>1] <- 1
#transpose again
agg <- setNames(data.frame(t(agg[,-1])), agg[,1])
pdf("ehart_upset.pdf", onefile=F)
upset(agg, sets=c("belzebuth", "troglodytes", "hamadryas", "anubis", "gelada", "ascanius", "badius", "verreauxi"), keep.order=T, order.by="freq", mainbar.y.label="Number of phylotypes", sets.x.label="Phylotypes per species", mb.ratio = c(0.55, 0.45))
dev.off()