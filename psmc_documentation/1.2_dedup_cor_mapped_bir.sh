#!/bin/bash

#SBATCH --job-name=dedupbir
#SBATCH --time=12:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=32000
#SBATCH -o slurm-%x.out

java -jar picard-tools-1.118/MarkDuplicates.jar \
I=cor_5587-MS-0004_mapped_bir.sorted.bam \
O=cor_5587-MS-0004_mapped_bir-dedup.bam \
M=cor_5587-MS-0004_mapped_bir-dedup_metrics.txt \
MAX_FILE_HANDLES=450

java -jar picard-tools-1.118/SortSam.jar INPUT=cor_5587-MS-0004_mapped_bir-dedup.bam OUTPUT=cor_5587-MS-0004_mapped_bir-dedup.sorted.bam SORT_ORDER=coordinate

java -jar picard-tools-1.118/BuildBamIndex.jar I=cor_5587-MS-0004_mapped_bir-dedup.sorted.bam

echo done
