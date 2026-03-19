#!/bin/bash
set -ueo pipefail

# SCRIPT 2: INSTALL FLYE FOR CONDA ENVIRONMENT

# load miniforge
module load miniforge3
source "$(conda info --base)/etc/profile.d/conda.sh"

# activate flye 2.9.6. only create environment if not downloaded
conda env list | grep -q "flye-env" || mamba create -y -n flye-env flye=2.9.6 -c bioconda
conda activate flye-env

# download .yml file
conda env export --no-builds > flye-env.yml
