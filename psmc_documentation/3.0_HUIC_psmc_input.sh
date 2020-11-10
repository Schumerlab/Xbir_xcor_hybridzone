#!/bin/bash

#SBATCH --job-name=huicprep
#SBATCH --time=45:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=64000
#SBATCH -o slurm-%x.out

for i in $(cat HUIC_pseudorefs.list); do
    IND=$(basename $i _psuedoref_birchmanni_10x_12Sep2018_yDAA6.fasta)
    echo $IND

    perl fasta_to_fastq.pl ${IND}_psuedoref_birchmanni_10x_12Sep2018_yDAA6.fasta > ${IND}_psuedoref_birchmanni_10x_12Sep2018_yDAA6.fastq

    seqtk subseq ${IND}_psuedoref_birchmanni_10x_12Sep2018_yDAA6.fastq xbir-10x_chromlist.list > ${IND}_psuedoref_birchmanni_majorchr.fastq

    fq2psmcfa -q20 ${IND}_psuedoref_birchmanni_majorchr.fastq > ${IND}_psuedoref_birchmanni.psmcfa

done
