#!/bin/bash

splitfa cor_5587-MS-0004_mapped_bir.psmcfa 5000 > cor_5587-MS-0004_mapped_bir_split.psmcfa


for i in {1..100}; do
    echo $i
    sed "s/XXrepXX/$i/g" bootstrap_psmc_cor_mapped_bir.sh | sbatch
done
