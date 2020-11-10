#!/bin/bash

#SBATCH --job-name=psmcXXrepXX
#SBATCH --time=45:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=64000
#SBATCH -o slurm-%x.out

module load python/2.7.13
module load py-numpy

psmc -p "4+25*2+4+6" -b -o cor_5587-MS-0004_mapped_bir_boot_XXrepXX.psmc cor_5587-MS-0004_mapped_bir_split.psmcfa

echo done
