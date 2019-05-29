#!/bin/sh
#############################
#18S rRNA Amplicon Processing
#############################
#must be in a directory with raw fastq files with the following extension _R1_001.fastq.gz _R2_001.fastq.gz
REF18S=/Users/mann/refDB/silva128/99_SILVA_128_euks_rep_set.fasta
REFTAX=/Users/mann/refDB/silva128/99_SILVA_128_taxa_map_7_level.w_blastocystis_entamoeba.txt
VSEARCH=/usr/local/bin/vsearch
NTDB=/Users/mann/refDB/NCBI/nt

mkdir trim
echo "Trimming adapter and primer sequences"
#trim off any residual adapter sequence (should be pretty low)
ls *R1* | sed 's/_R1_001.fastq.gz//' | parallel -j6 'cutadapt -a AATGATACGGCGACCACCGAGATCTACACGCT -A AGCGTGTAGATCTCGGTGGTCGCCGTATCATT --trim-n -m 50 -o trim/{}.R1.trim.fastq -p trim/{}.R2.trim.fastq  {}_R1_001.fastq.gz {}_R2_001.fastq.gz 1> trim/{}.adapt.trim.info'
#trim primers
ls *R1* | sed 's/_R1_001.fastq.gz//' | parallel -j6 'cutadapt -a CYGCGGTAATTCCAGCTC  -g CRAAGAYGATYAGATACCRT  -o trim/{}.R1.trimprimer.fastq -p trim/{}.R2.trimprimer.fastq  trim/{}.R1.trim.fastq trim/{}.R2.trim.fastq 1> trim/{}.primer.trim.info'

echo "Paired end read merging"
mkdir pear
#merge paired end reads
ls *R1* | sed 's/_R1_001.fastq.gz//' | parallel -j10 'pear -f trim/{}.R1.trimprimer.fastq -r trim/{}.R2.trimprimer.fastq -o pear/{} -q 30 -t 50 -n 50 1>pear/{}.out'

cd pear

echo "Fastq to fasta"
#convert to fasta and add sequence headers to both the merged and unmerged forward reads
ls *assembled.fastq | sed 's/.fastq//' | parallel -j10 'fastq_to_fasta -i {}.fastq -o {}.fasta -Q 33'
ls *unassembled.forward.fastq | sed 's/.fastq//' | parallel -j10 'fastq_to_fasta -i {}.fastq -o {}.fasta -Q 33'

ls *fastq | parallel 'gzip {}' &

echo "Adding headers and cleaning up"
#add headers
ls *assembled.fasta | sed 's/.assembled.fasta//' | while read line; do awk '/^>/{print ">'$line'."; next} {print}' < $line.assembled.fasta > $line.assembled.headers.fa; done
rm *assembled.fasta
ls *unassembled.forward.fasta | sed 's/.unassembled.forward.fasta//' | while read line; do awk '/^>/{print ">'$line'."; next} {print}' < $line.unassembled.forward.fasta > $line.unassembled.forward.headers.fa; done
rm *unassembled.forward.fasta
ls *assembled.headers.fa | sed 's/.assembled.headers.fa//' | while read line; do cat $line.assembled.headers.fa $line.unassembled.forward.headers.fa > $line.full.fa; done
ls *full.fa | sed 's/.full.fa//' | while read line; do awk '/^>/{$0=$0""(++i)}1' $line.full.fa > $line.full.fix.fa; done
cat *full.fix.fa > combinedseq.fa

rm *full.fa
rename 's/full.fix.fa/full.fa/' *full.fix.fa

cd ..

echo "Chimera check"
#chimera check
vsearch --uchime_ref pear/combinedseq.fa --db $REF18S --chimeras pear/combinedseq.chims.fa --nonchimeras pear/combinedseq.nochims.fa

mkdir swarm
echo "Running swarm"
#run swarm
pick_otus.py -i pear/combinedseq.nochims.fa -o swarm/ -m swarm

#get rep set
pick_rep_set.py -i swarm/combinedseq.nochims_otus.txt -f pear/combinedseq.nochims.fa -m most_abundant -o swarm/rep_set.fa

echo "Assigning taxonomy"
#assign taxonomy with vsearch
#first need to set is as an alias
alias uclust=$VSEARCH
assign_taxonomy.py -i swarm/rep_set.fa -t $REFTAX -r $REF18S -m uclust -o assigntax

#get taxonomy assignments for the unassigned
grep "Unassigned" assigntax/rep_set_tax_assignments.txt | awk '{print $1}' > assigntax/unassigned.ids
filter_fasta.py -f swarm/rep_set.fa -o assigntax/unassigned.fa -s assigntax/unassigned.ids

echo "Blast unassigned reads"
#run blast against NT database to get better taxonomy assignments for unassigned reads
blastn -query assigntax/unassigned.fa -out assigntax/unassigned.blast.xml -db $NTDB -perc_identity 0.99 -evalue 1e-10 -max_target_seqs 500 -outfmt 6 &




