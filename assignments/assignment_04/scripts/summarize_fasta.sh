#!/bin/bash
set -ueo pipefail
# initialize variables and run seqtk commands
file=$1
nseq=$(seqtk size "$file" | cut -f1)
nnuc=$(seqtk size "$file" | cut -f2)
# store data in temp file
seqtk comp "$file" | cut -f1,2 > table.tmp
# report information with explanations
echo "---------------------------------------------------------------"
echo "Information for file: $file"
echo "---------------------------------------------------------------"
echo "Total number of sequences: $nseq"
echo "Total number of nucleotides: $nnuc"
echo "Sequence names and lengths:"
cat table.tmp
# remove temp table
rm table.tmp
