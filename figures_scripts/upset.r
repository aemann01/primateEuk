#first need to filter biom table by those otus that made it into the entamoeba placement tree (raxml version has only placement otus)
# grep ">denovo" queryalign_plus_refalign.fa | sed 's/>//' | sed 's/ .*//' > entamoeba.ids
# filter_otus_from_otu_table.py -i ../swarm/swarm_otus.wtax.final.biom -o ../swarm/entamoeba_in_tree.biom --negate_ids_to_exclude -e entamoeba.ids
# biom convert -i ../swarm/entamoeba_in_tree.biom -o ../swarm/entamoeba_in_tree.txt --to-tsv --table-type="OTU table"
#fix header and run code below

library(UpSetR)

#read in data and mapping file
dat <- as.matrix(read.table("../swarm/entamoeba_in_tree.txt", header=T, sep="\t", row.names=1))
map <- as.matrix(read.table("../swarm/map.txt", header=T, sep="\t", row.names=1))
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

#upsetR 
pdf("entamoeba_upset.pdf", onefile=F)
upset(agg, sets=c("seniculus", "pigra", "hybridus", "belzebuth", "lagotricha", "troglodytes", "gorilla", "hamadryas", "anubis", "gelada", "ascanius", "badius", "guereza", "verreauxi", "rubriventer"), keep.order=T, order.by="freq", mainbar.y.label="Number of phylotypes", sets.x.label="Phylotypes per species", mb.ratio = c(0.55, 0.45))
dev.off()

#nematode upset plot
dat <- as.matrix(read.table("nematodes_in_tree.txt", header=T, sep="\t", row.names=1))
dat.t <- t(dat)
merged <- merge(dat.t, map, by="row.names")
n <- ncol(dat.t) + 1
agg <- aggregate(merged[,2:n], by=list(merged$Species), FUN=sum)

pdf("nematode_upset.pdf", onefile=F)
upset(agg, sets=c("seniculus", "pigra","belzebuth", "lagotricha", "troglodytes", "hamadryas", "anubis", "gelada", "ascanius", "badius", "guereza","rubriventer"), keep.order=T, order.by="freq", mainbar.y.label="Number of phylotypes", sets.x.label="Phylotypes per species", mb.ratio = c(0.55, 0.45))
dev.off()