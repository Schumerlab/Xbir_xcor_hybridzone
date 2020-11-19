#!/bin/bash

for line in $(cat xbir-10x_chromlist.list); do
    echo $line
    sed "s/XXchrXX/$line/g" 1.5.2_haplotypecaller_ref_bir.sh | sbatch
done
