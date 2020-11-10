#!/bin/bash

perl fasta_to_fastq.pl cor_5587-MS-0004_mapped_bir.fasta > cor_5587-MS-0004_mapped_bir.fastq

seqtk subseq cor_5587-MS-0004_mapped_bir.fastq xbir-10x_chromlist.list > cor_5587-MS-0004_mapped_bir_majorchr.fastq

fq2psmcfa -q20 cor_5587-MS-0004_mapped_bir_majorchr.fastq > cor_5587-MS-0004_mapped_bir.psmcfa
