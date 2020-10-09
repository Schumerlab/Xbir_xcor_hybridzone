#!/bin/bash

#SBATCH --job-name=XXinfileXX
#SBATCH --time=48:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=32000
#SBATCH --mail-user=schumer@stanford.edu
#SBATCH -p hns,normal
#SBATCH -o slurm-%x.out

module load gsl
module load python/3.6.1
module load R
infile=XXinfileXX
WORKDIR=/scratch/groups/schumer/molly/exploring_slim

mkdir $WORKDIR/output_neutral/$infile

while read line; do
    
    seed="`echo $line | cut -d',' -f1`"
    popsize="`echo $line | cut -d',' -f2`"
    gen="`echo $line | cut -d',' -f3`"
    init_prop="`echo $line | cut -d',' -f4`"
    mig1="`echo $line | cut -d',' -f5`"
    mig2="`echo $line | cut -d',' -f6`"
    echo "Running simulation $seed, Population size = $popsize, Generations after admixture = $gen, Initial proportion population 1 = $init_prop, Migration rate 1 = $mig1, Migration rate 2 = $mig2"

    slim -d SEED=$seed -d POPSIZE=$popsize -d GEN=$gen -d INIT_PROP=$init_prop -d PAR1MIG=0.0 -d PAR2MIG=$mig2 $WORKDIR/neutral_admixture_ABC_migration.ms.slim 
    python3 $WORKDIR/slim_genetree_to_indiv_ancestries.py $WORKDIR/slim_out/dem_abc_sim$seed.trees 50 $WORKDIR/output_neutral/$infile/dem_abc_sim_mig$seed.tsv
    rm $WORKDIR/slim_out/dem_abc_sim$seed.trees
    Rscript $WORKDIR/summary_stats.R $seed $WORKDIR/output_neutral/$infile/dem_abc_sim_mig$seed.tsv >> $WORKDIR/output_neutral/$infile/summary_params_mig_$infile.txt

done <$WORKDIR/input_popsize_10to3k/$infile
