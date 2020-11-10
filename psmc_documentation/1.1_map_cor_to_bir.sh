#!/bin/bash

#SBATCH --job-name=mapcor
#SBATCH --time=47:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=64000
#SBATCH -o slurm-%x.out

module load biology
module load bwa
module load samtools

bwa mem -t 3 -M -R '@RG\tID:1\tSM:5587-MS-0004\tPL:illumina\tLB:10X\tPU:556' xiphophorus_birchmanni_10x_12Sep2018_yDAA6.fasta barcode_trimmed_10X_reads_cortezi_R1_001.fastq.gz barcode_trimmed_10X_reads_cortezi_R2_001.fastq.gz > cor_5587-MS-0004_mapped_bir.sam

samtools view -S -b cor_5587-MS-0004_mapped_bir.sam > cor_5587-MS-0004_mapped_bir.bam
samtools sort cor_5587-MS-0004_mapped_bir.bam -o cor_5587-MS-0004_mapped_bir.sorted.bam
samtools index cor_5587-MS-0004_mapped_bir.sorted.bam
