#!/bin/bash
set -ueo pipefail

# SCRIPT 3: RUN FLYE USING LOCAL BUILD

# add programs/flye to PATH
export PATH="$HOME/programs/Flye/bin:$PATH"

# run flye command
mkdir -p assemblies/assembly_local
flye --nano-hq data/*.fastq.gz -g 0.05m -o assemblies/assembly_local -t 6 --meta

# clean up assembly_local
cd assemblies/assembly_local
mv assembly.fasta local_assembly.fasta
mv flye.log local_flye.log
ls | grep -v "local_" | xargs rm -rf

# verify environment
echo "Script COMPLETE using Flye located at: $(which flye)"
