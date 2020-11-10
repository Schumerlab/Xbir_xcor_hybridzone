#!/bin/bash

#SBATCH --job-name=10xbartr
#SBATCH --time=47:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=64000
#SBATCH -o slurm-%x.out

module load python
module load py-numpy

python process_10xReads.py -o barcode_trimmed_10X_reads_cortezi -b 16 -t 7 -1 5587-MS-0004_S7_L007_R1_001.fastq.gz -2 5587-MS-0004_S7_L007_R2_001.fastq.gz
