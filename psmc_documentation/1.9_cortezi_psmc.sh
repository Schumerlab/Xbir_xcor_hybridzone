#!/bin/bash

#SBATCH --job-name=cor_psmc
#SBATCH --time=45:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=64000
#SBATCH -o slurm-%x.out

module load python/2.7.13
module load py-numpy

psmc -p "4+25*2+4+6" -o cor_5587-MS-0004_mapped_bir.psmc cor_5587-MS-0004_mapped_bir.psmcfa

perl psmc_plot.pl -u 3.5e-09 -g 0.5 cor_5587-MS-0004_mapped_bir cor_5587-MS-0004_mapped_bir.psmc

echo done
