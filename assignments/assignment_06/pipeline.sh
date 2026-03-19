#!/bin/bash
set -ueo pipefail

# PIPELINE SCRIPT

# download the data
./scripts/01_download_data.sh

# build local flye
./scripts/02_flye_2.9.6_manual_build.sh

# build flye conda environment
./scripts/02_flye_2.9.6_conda_install.sh

# make assemblies folder
mkdir -p assemblies

# run conda flye
./scripts/03_run_flye_conda.sh

# run module flye
./scripts/03_run_flye_module.sh

# run local flye
./scripts/03_run_flye_local.sh

# print final results
echo "------------------------------------------------"
echo "PIPELINE COMPLETE: FINAL COMPARISON"
echo "------------------------------------------------"

echo ">>> LOG: CONDA ENVIRONMENT"
tail -n 10 assemblies/assembly_conda/conda_flye.log
echo "------------------------------------------------"

echo ">>> LOG: MODULE ENVIRONMENT"
tail -n 10 assemblies/assembly_module/module_flye.log
echo "------------------------------------------------"

echo ">>> LOG: LOCAL BUILD"
tail -n 10 assemblies/assembly_local/local_flye.log
echo "------------------------------------------------"
