#!/bin/bash
set -ueo pipefail

# SCRIPT 03: RUN FLYE USING CONDA ENVIRONMENT

# activate conda
module load miniforge3
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate flye-env

# run flye command
mkdir assemblies/assembly_conda
flye --nano-hq data/*.fastq.gz -g 0.05m -o assemblies/assembly_conda -t 6 --meta

# clean up assembly_conda
cd assemblies/assembly_conda
mv assembly.fasta conda_assembly.fasta
mv flye.log conda_flye.log
ls | grep -v "conda_" | xargs rm -rf

# verify environment
echo "Script COMPLETE using Flye located at: $(which flye)"
