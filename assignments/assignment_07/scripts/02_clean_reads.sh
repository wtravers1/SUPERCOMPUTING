#!/bin/bash
set -ueo pipefail

# SCRIPT 02: read qc and trimming

# MAKE DIRECTORY
mkdir -p data/clean

# LOOP THROUGH ALL FWD READS
# use for loop to iterate through files in raw/ folder
for FWD_IN in data/raw/*_1.fastq; do
    REV_IN=${FWD_IN/_1.fastq/_2.fastq}
    # move to data/clean/ and add _clean tag
    FWD_OUT=${FWD_IN/raw/clean}
    FWD_OUT=${FWD_OUT/.fastq/_clean.fastq}
    REV_OUT=${REV_IN/raw/clean}
    REV_OUT=${REV_OUT/.fastq/_clean.fastq}
    # run fastp with settings from previous assignment
    fastp \
      --in1 "$FWD_IN" \
      --in2 "$REV_IN" \
      --out1 "$FWD_OUT" \
      --out2 "$REV_OUT" \
      --trim_front1 8 \
      --trim_front2 8 \
      --trim_tail1 20 \
      --trim_tail2 20 \
      --n_base_limit 0 \
      --length_required 100 \
      --average_qual 20 \
      --thread 4
# --trim_front: Removes potential sequence bias from the start of the reads
# --trim_tail: Clips lower-quality bases at the end of the run
# --n_base_limit 0: Discards any read with undetermined "N" bases
# --length_required 100: Filters out short reads
# --average_qual 20: Requires 99% call accuracy to ensure the data represents real DNA matches
# --thread 4: Matches the process to the Bora nodes cpu allocation
done

echo "Cleaning complete. Files are in data/clean/"
