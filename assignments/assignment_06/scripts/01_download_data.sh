#!/bin/bash
set -ueo pipefail

# SCRIPT 1: download genomic dataset

# download data in ./data
mkdir -p data
cd data
wget https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz
