#!/bin/sh
#############################
#16S rRNA Amplicon Processing
#############################
#data accession number: PRJEB22679
#since these are single end, just use cutadapt to quality filter and trim
REF16S=/Users/mann/refDB/ezbiocloud_qiime_full.fasta
mkdir trim
ls *fastq | sed 's/.fastq//' | parallel -j 10 'cutadapt --trim-n -m 50 -q 30,30 -o trim/{}.cutadapt.fastq {}.fastq' 1>cutadapt.stats
ls *fastq | sed 's/.fastq//' | parallel -j10 'fastq_to_fasta -i trim/{}.fastq -o trim/{}.fasta -Q 33'
cd trim
ls *cutadapt.fasta | sed 's/.cutadapt.fasta//' | while read line; do awk '/^>/{print ">'$line'."++i; next} {print}' < $line.cutadapt.fasta > $line.headers.fasta; done
rm *cutadapt.fasta
cat *headers* > ../combinedseq.fa
vsearch --uchime_ref combinedseq.fa --db $REF16S --chimeras combinedseq.chims.fa --nonchimeras combinedseq.nochims.fa
pick_otus.py -i combinedseq.nochims.fa -o swarm -m swarm
pick_rep_set.py -i swarm/combinedseq.nochims_otus.txt -f combinedseq.nochims.fa -m most_abundant -o swarm/rep_set.fa
alias uclust='/usr/local/bin/vsearch'
assign_taxonomy.py -i rep_set.fa -t ~/refDB/ezbiocloud_id_taxonomy.txt -r ~/refDB/ezbiocloud_qiime_full.fasta -m uclust -o assigntax
sed -i 's/\./_/g' swarm/combinedseq.nochims_otus.txt
make_otu_table.py -i swarm/combinedseq.nochims_otus.txt -o swarm/swarm_otus.biom
grep -v "Unassigned" assigntax/rep_set_tax_assignments.txt | awk '{print $1, "\t", $2}' > assigntax/rep_tax.txt
biom add-metadata -i swarm/swarm_otus.biom -o swarm/swarm_otus.wtax.biom --observation-metadata-fp assigntax/rep_tax.txt --observation-header OTUID,taxonomy --sc-separated taxonomy
grep  "Unassigned" assigntax/rep_set_tax_assignments.txt | awk '{print $1}' > assigntax/unassigned.ids 
filter_otus_from_otu_table.py -i swarm/swarm_otus.wtax.names.biom -o swarm/swarm_otus.wtax.names.filt.biom -e assigntax/unassigned.ids -n 50
single_rarefaction.py -i swarm/swarm_otus.wtax.names.filt.biom -o swarm/swarm_otus.wtax.d5k.biom -d 5000
filter_fasta.py -f swarm/rep_set.fa -o swarm/rep_set.filt.fa -s assigntax/rep_tax.txt
mafft --parttree swarm/rep_set.filt.fa > swarm/rep_set.filt.align.fa
raxmlHPC-PTHREADS -f a -x 12345 -p 12345 -# 100 -m GTRCAT -s swarm/rep_set.filt.align.fa -n rep.tre


