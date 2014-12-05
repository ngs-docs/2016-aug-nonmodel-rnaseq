#! /bin/bash
#PBS -l walltime=24:00:00,nodes=1:ppn=2,mem=10gb

cd $HOME/rnaseq/script
. env.sh

java -jar $TRIM/trimmomatic PE ERR315424_1.fastq ERR315424_2.fastq \
        lung_repl2_R1.qc.fq.gz s1_se lung_repl2_R2.qc.fq.gz s2_se \
        ILLUMINACLIP:$TRIM/adapters/TruSeq3-PE.fa:2:40:15 \
        LEADING:2 TRAILING:2 \
        SLIDINGWINDOW:4:2 \
        MINLEN:25

tophat -p 4 \
    -G ~/RNAseq-model/Homo_sapiens/Ensembl/GRCh37/Annotation/Genes/genes.gtf \
    --transcriptome-index=$HOME/RNAseq-model/transcriptome \
    -o tophat_lung_repl2 \
    ~/RNAseq-model/Homo_sapiens/Ensembl/GRCh37/Sequence/Bowtie2Index/genome \
    lung_repl2_R1.qc.fq.gz lung_repl2_R2.qc.fq.gz

htseq-count --format=bam --stranded=no --order=pos \
    tophat_lung_repl2/accepted_hits.bam \
    ~/RNAseq-model/Homo_sapiens/Ensembl/GRCh37/Annotation/Genes/genes.gtf > lung_repl2_counts.txt
