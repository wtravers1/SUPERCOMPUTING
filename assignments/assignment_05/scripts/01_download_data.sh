#!/bin/bash
set -ueo pipefail

# download fastq data file, extract into ./data/raw, and clean up initial file
wget https://gzahn.github.io/data/fastq_examples.tar
tar -xf fastq_examples.tar -C ./data/raw # unpack data into data/raw instead of current directory
rm fastq_examples.tar
