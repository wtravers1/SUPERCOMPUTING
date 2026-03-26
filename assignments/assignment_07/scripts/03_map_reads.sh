#!/bin/bash
set -ueo pipefail

# SCRIPT 03: mapping and contaminant extraction

# MAKE DIRECTORY
mkdir -p output

# LOAD SAMTOOLS MODULE ENVIRONMENT
module load samtools/gcc-11.4.1/1.22.1

# ALIGN READS TO DOG GENOME AND MATCHING SEQUENCES
# using for loop iterate through cleaned fastq files
for FWD_IN in data/clean/*_1_clean.fastq; do
    # set paired inpit and output names
    REV_IN=${FWD_IN/_1_clean.fastq/_2_clean.fastq}
    SAMPLE_NAME=$(basename "$FWD_IN" _1_clean.fastq)
    TEMP_SAM="output/${SAMPLE_NAME}_temp.sam"
    FINAL_SAM="output/${SAMPLE_NAME}.sam"

    # map reads against dog reference genome
    bbmap.sh \
      ref="data/dog_reference/dog_reference_genome.fna" \
      in1="$FWD_IN" \
      in2="$REV_IN" \
      outm="$TEMP_SAM" \
      minid=0.95 \
      threads=8 \
      overwrite=true \
      -Xmx24g
      # ref: Specifies the dog reference genome location for the BBMap alignment.
      # minid=0.95: Sets a strict 95% identity threshold to ensure high-accuracy mapping.
      # outm: Captures only the reads that successfully mapped to the dog genome.
      # threads=8: Utilizes the full CPU capacity of the Bora node for faster alignment.
      # -Xmx24g: Allocates 24GB of RAM to BBMap to handle the large dog genome index.
    # process mapping results using samtools
    samtools view -h -F 4 "$TEMP_SAM" > "$FINAL_SAM"
    # samtools view -h -F 4: Keeps the header (-h) and excludes unmapped reads (-F 4).
    rm "$TEMP_SAM"
done

echo "Script complete. Results in /output"
