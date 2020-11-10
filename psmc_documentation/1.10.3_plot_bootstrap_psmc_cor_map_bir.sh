#!/bin/bash

#SBATCH --job-name=plotboot
#SBATCH --time=45:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=64000
#SBATCH -o slurm-%x.out

cat cor_5587-MS-0004_mapped_bir.psmc cor_5587-MS-0004_mapped_bir_boot_*.psmc > cor_5587-MS-0004_mapped_bir_combined.psmc

perl psmc_plot.pl -R -u 3.5e-09 -g 0.5 cor_5587-MS-0004_mapped_bir_combined cor_5587-MS-0004_mapped_bir_combined.psmc
