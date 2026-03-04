#!/bin/bash
set -euo pipefail

# download data into ./data/raw
# <execute 01_download_data.sh script>
./scripts/01_download_data.sh

# run for loop to iterate through every .gz file in ./data/raw directory
# <execute 02_run_fastp.sh script>
for file in ./data/raw/*_R1_001.subset.fastq.gz; # only pull _R1_ files in directory
do
    ./scripts/02_run_fastp.sh $file
done
