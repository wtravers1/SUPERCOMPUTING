## ASSIGNMENT 7 ##
Wyatt Travers
3/25/26

## Assignment Tree

## Setup tools for assignment

This assignment requires many tools for the scripts to run. All these tools must be downloaded locally in a programs/ folder located at the root. samtools is also needed, and is used as a module environment.

```
wget --output-document sratoolkit.tar.gz https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
tar -xvzf sratoolkit.current-ubuntu64.tar.gz
rm sratoolkit.current-ubuntu64.tar.gz
```

datasets download
```
curl -o datasets 'https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/v2/linux-amd64/datasets'
```

BBmap download
```
wget https://sourceforge.net/projects/bbmap/files/BBMap_39.80.tar.gz
tar -xvzf bbmap.tar.gz
rm bbmap.tar.gz
```

samtools module
```
module load samtools/gcc-11.4.1/1.22.1
```

NOTE: make sure to add all tools added to programs/ file to your PATH. Then refresh terminal connection.

## Finding my sequence dataset

The dataset I ended up going with was 15 accessions of a Comparative shotgun metagenomic analysis of diets in sympatric aoudad, desert bighorn sheep, and mule deer in the Chihuahuan desert. I picked this project because the samples were between 200-300Mb large and paired. I used the following filters to find the samples:

(shotgun[All Fields] AND ("metagenome"[Organism] OR metagenome[All Fields])) AND "gut metagenome"[Organism] AND (cluster_public[prop] AND "library layout paired"[Properties] AND "platform illumina"[Properties] AND "strategy wgs"[Properties] OR "strategy wga"[Properties] OR "strategy wcs"[Properties] OR "strategy clone"[Properties] OR "strategy finishing"[Properties] OR "strategy validation"[Properties] AND "filetype fastq"[Properties])

## Creating 01_download_data.sh

```
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
# use ncbu dataset tool to download reference genome
datasets download genome taxon "canis familiaris" --reference --filename dog_genome.zip
unzip dog_genome.zip
mv ncbi_dataset/data/GCF*/*.fna data/dog_reference/dog_reference_genome.fna
rm -rf ncbi_dataset dog_genome.zip md5sum.txt README.md
```

## Creating 02_clean_reads.sh

```
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
```

## Creating 03_map_reads.sh

```
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
```

## creating assignment_07_pipeline.sh

```
#!/bin/bash
#SBATCH --job-name=assignment_07
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=06:00:00
#SBATCH --mem=32G
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=wtravers@wm.edu
#SBATCH -o /sciclone/home/wtravers/SUPERCOMPUTING/assignments/assignment_07/output/assignment_07.out
#SBATCH -e /sciclone/home/wtravers/SUPERCOMPUTING/assignments/assignment_07/output/assignment_07.err

set -ueo pipefail

# load samtools from module env
module load samtools/gcc-11.4.1/1.22.1

# start script 1
# ./scripts/01_download_data.sh

# start script 2
# ./scripts/02_clean_reads.sh

# start script 3
./scripts/03_map_reads.sh
```

## Personal reflection
