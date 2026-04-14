#!/bin/bash
set -ueo pipefail

# SCRIPT 01: download data from list of SRRs and NIH database

# MAKE DIRECTORIES
mkdir -p data data/raw data/dog_reference

# PROCESS SRA SAMPLES
# extract srr names and save them to a file
tail -n +2 data/SraRunTable.csv | cut -d ',' -f 1 > temp_srr.txt
# for loop to iterate through each srr name
for SRR in $(cat temp_srr.txt); do
     # use fasterq-dump to download paired-end fastq files
     fasterq-dump --split-files --outdir data/raw/ "$SRR"
     echo "downloaded $SRR..."
done

# DOWNLOAD DOG REFERENCE DATA
# use ncbi dataset tool to download reference genome
cd data/dog_reference
datasets download genome taxon "canis familiaris" --reference --filename dog_genome.zip
unzip dog_genome.zip
mv ncbi_dataset/data/GCF*/*.fna dog_reference_genome.fna
rm -rf ncbi_dataset dog_genome.zip md5sum.txt README.md
cd ../..
