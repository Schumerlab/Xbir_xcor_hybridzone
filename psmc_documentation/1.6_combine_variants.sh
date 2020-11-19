#!/bin/bash

#SBATCH --job-name=combvar
#SBATCH --time=24:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=64000
#SBATCH -o slurm-%x.out

rm variant_calls.list
for i in $(cat xbir-10x_chromlist.list); do echo cor_5587-MS-0004_mapped_bir_$i.g.vcf.gz >> variant_calls.list ; done

bcftools concat -o cor_5587-MS-0004_mapped_bir_allchr.g.vcf -f variant_calls.list

echo done
