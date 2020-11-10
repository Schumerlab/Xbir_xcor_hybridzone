#!/bin/bash

#SBATCH --job-name=huicpsmc
#SBATCH --time=45:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=64000
#SBATCH -o slurm-%x.out

module load python/2.7.13
module load py-numpy

for i in $(cat HUIC_pseudorefs.list); do
    IND=$(basename $i _psuedoref_birchmanni_10x_12Sep2018_yDAA6.fasta)
    echo $IND

    psmc -p "4+25*2+4+6" -o ${IND}_psuedoref_birchmanni.psmc ${IND}_psuedoref_birchmanni.psmcfa

    perl psmc_plot.pl -R -u 3.5e-09 -g 0.5 ${IND}_pseudoref_birchmanni ${IND}_psuedoref_birchmanni.psmc

done
