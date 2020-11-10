#!/bin/bash

#SBATCH --job-name=insnp
#SBATCH --time=6:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=64000
#SBATCH -o slurm-%x.out

module load python/2.7.13
module load py-numpy

python insnp_v10_gatk3.4_gvcf.py cor_5587-MS-0004_mapped_bir.g.vcf  cor_5587-MS-0004_mapped_bir.g.vcf.insnp 20 20 50 199 40 10 10 4 -12.5 -8.0 5

seqtk mutfa xiphophorus_birchmanni_10x_12Sep2018_yDAA6.fasta cor_5587-MS-0004_mapped_bir.g.vcf.insnp > cor_5587-MS-0004_mapped_bir.fasta

echo done
