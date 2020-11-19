#!/bin/bash

#SBATCH --job-name=realigncor
#SBATCH --time=48:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=64000
#SBATCH -o slurm-%x.out

java -jar GenomeAnalysisTK.jar \
-T RealignerTargetCreator \
-R xiphophorus_birchmanni_10x_12Sep2018_yDAA6.fasta \
-I cor_5587-MS-0004_mapped_bir-dedup.sorted.bam \
-o target_intervals_cor_5587-MS-0004.list

java -jar GenomeAnalysisTK.jar \
-T IndelRealigner \
-R xiphophorus_birchmanni_10x_12Sep2018_yDAA6.fasta \
-I cor_5587-MS-0004_mapped_bir-dedup.sorted.bam \
-targetIntervals target_intervals_cor_5587-MS-0004.list \
-o cor_5587-MS-0004_mapped_bir-dedup.sorted.realigned.bam

echo done
