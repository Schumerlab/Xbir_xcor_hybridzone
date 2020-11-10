#!/bin/bash

for line in $(cat xbir-10x_chromlist.list); do
    echo $line
    sed "s/XXchrXX/$line/g" haplotypecaller_ref_bir.sh | sbatch
done
