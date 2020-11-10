#!/bin/bash

#SBATCH --job-name=htcXXchrXX
#SBATCH --time=24:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=64000
#SBATCH -o slurm-%x.out

module load biology

java -jar GenomeAnalysisTK.jar \
-T HaplotypeCaller \
-R xiphophorus_birchmanni_10x_12Sep2018_yDAA6.fasta \
-I cor_5587-MS-0004_mapped_bir-dedup.sorted.realigned.bam \
--genotyping_mode DISCOVERY \
-L XXchrXX \
-stand_emit_conf 10 \
-stand_call_conf 30 \
-ERC GVCF \
-o cor_5587-MS-0004_mapped_bir_XXchrXX.rawvariants.g.vcf.gz

java -jar GenomeAnalysisTK.jar \
-T GenotypeGVCFs \
-R xiphophorus_birchmanni_10x_12Sep2018_yDAA6.fasta \
--variant cor_5587-MS-0004_mapped_bir_XXchrXX.rawvariants.g.vcf.gz \
--sample_ploidy 2 \
--max_alternate_alleles 4 \
--includeNonVariantSites \
--standard_min_confidence_threshold_for_calling 30 \
-o cor_5587-MS-0004_mapped_bir_XXchrXX.g.vcf.gz

echo done
