# get everything in qiime2 format
qiime tools import --input-path ~/github/primateEuk/swarm/swarm_otus.wtax.final.biom --output-path swarm_otus.wtax.final.nohash.qza --type 'FeatureTable[Frequency]'

# ordination
qiime deicode rpca --i-table swarm_otus.wtax.final.nohash.qza --p-min-feature-count 1 --p-min-sample-count 1 --o-biplot ordination.qza --o-distance-matrix distance.qza


# biplot
qiime emperor biplot --i-biplot ordination.qza --m-sample-metadata-file map.txt --o-visualization biplot.qzv --p-number-of-features 8

# export to fix up in R
qiime tools export --input-path ordination.qza --output-path ordination.txt