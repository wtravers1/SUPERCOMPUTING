#!/bin/bash
set -ueo pipefail

# SCRIPT 3: RUN FLYE USING MODULE ENVIRONMENT

# load bora module
module load Flye/gcc-11.4.1/2.9.6

# run flye command
mkdir -p assemblies/assembly_module
flye --nano-hq data/*.fastq.gz -g 0.05m -o assemblies/assembly_module -t 6 --meta

# clean up assembly_module
cd assemblies/assembly_module
mv assembly.fasta module_assembly.fasta
mv flye.log module_flye.log
ls | grep -v "module_" | xargs rm -rf

# verify environment
echo "Script COMPLETE using Flye located at: $(which flye)"
