## ASSIGNMENT #6 ##

**Wyatt Travers**
**3-19-26**

## Assignment Tree

```text
│   flye-env.yml
│   pipeline.sh
│   README.md
│
├───assemblies
│   ├───assembly_conda
│   │       .gitkeep
│   │
│   ├───assembly_local
│   │       .gitkeep
│   │
│   └───assembly_module
│           .gitkeep
│
├───data
│       .gitkeep
│
└───scripts
        01_download_data.sh
        02_flye_2.9.6_conda_install.sh
        02_flye_2.9.6_manual_build.sh
        03_run_flye_conda.sh
        03_run_flye_local.sh
        03_run_flye_module.sh
```

## Setup assignment_06/ directory

Make subdirectories for data and scripts. Add a .gitkeep file to data/ since .fastq.gz is hidden in .gitignore.
```
mkdir data scripts
touch ./data/.gitkeep
```

## Creating 01_download_data.sh

```
#!/bin/bash
set -ueo pipefail

# SCRIPT 1: download genomic dataset

# download data in ./data
cd data
wget https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz
```

## Creating 02_flye_2.9.6_manual_build.sh

```
#!/bin/bash
set -ueo pipefail

# SCRIPT 2: DOWNLOAD FLYE USING LOCAL BUILD

# clone repo and make. if flye exists, skip clone
cd ~/programs
[ ! -d "Flye" ] && git clone https://github.com/fenderglass/Flye
cd Flye
make
```
The `[ ! -d "Flye" ]` logic checks to see if the GitHub repo is already cloned. If it is, skip over this process. The make command automatically checks to see what files have been previously downloaded, so no need to implement similar logic.

## Creating 02_flye_2.9.6_conda_install.sh

```
#!/bin/bash
set -ueo pipefail

# SCRIPT 2: INSTALL FLYE FOR CONDA ENVIRONMENT

# load miniforge
module load miniforge3
source "$(conda info --base)/etc/profile.d/conda.sh"

# activate flye 2.9.6. only create environment if not downloaded
conda env list | grep -q "flye-env" || mamba create -y -n flye-env flye=2.9.6 ->
conda activate flye-env

# download .yml file
conda env export --no-builds > flye-env.yml
```
Similar to the local build script, use piping and grep to check if conda/mamba is already donwloaded. If it is not, then the create line needs to be run to implement the correct version of flye.

## Creating 03_run_flye_conda.sh

```
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
```

## Creating 03_run_flye_module.sh

```
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
```

## Creating 03_run_flye_local.sh

```
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
```

## Creating pipeline.sh

```
#!/bin/bash
set -ueo pipefail

# PIPELINE SCRIPT

# download the data
./scripts/01_download_data.sh

# build local flye
./scripts/02_flye_2.9.6_manual_build.sh

# build flye conda environment
./scripts/02_flye_2.9.6_conda_install.sh

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
```

## Location of scripts

- All of the scripts, excluding pipeline.sh, can be found in the scripts/ folder.
- pipeline.sh can be found directly in the assignment_06 directory.
- IMPORTANT: run the pipeline.sh script DIRECTLY from the assignment_06 directory using `./pipeline.sh`. Make sure all scripts are executable (green color with *). If a script is not executable by the user, run the command `chmod 750 <file name> to give user permissions.

## Final results

| Installation Method | Total Length | Fragment Count | Fragments N50 |
| :--- | :--- | :--- | :--- |
| **Conda Environment** | 91,713 bp | 2 | 47,428 bp |
| **Bora Module** | 91,713 bp | 2 | 47,428 bp |
| **Local Build** | 91,713 bp | 2 | 47,428 bp |

Note: All three installation methods utilized Flye v2.9.6 and had identical assembly statistics as their output, confirming environment consistency.

## Personal reflection
The most difficult part of this assignment for me was getting comfortable with what it meant to run a program in different environments. My first confusion was the difference between the local build and the module environment, since I assumed they both used the Flye file in my ~/programs directory. This was maybe due to there being a step on the local build and the conda environment, but nothing on the module environment. Once I realized the difference, I had some issues with how to implement calling the Flye file from ~/programs. I first just used the flye keyword as it was, since this automatically called from the correct directory. I used which flye to confirm this. However, if I loaded in the module from bora, calling flye used the file in the module environment. To be consistent, instead of hard coding the local path, I add it to the Path so I could be sure when I just used the keyword, I was calling it from the right place. In my scripts, I added a line at the bottom of all three that used echo to print (which flye), so I could confirm each script used the flye file from the correct environment. When using the module environment, I had to learn commands like module avail flye (to check the name, since it was called Flye/gcc-11.4.1/2.9.6 and not flye), and module purge to exit the module environment. The easiest environment to use was definitely the local build, since I just had to clone the repo into my programs and it was the easiest to track. I could immediately test if it downloaded correctly and use which flye to see where it was stored. However, this was the least reproducible. The most practical for a professional environment is probably conda, since it is consistent on any machine and allows for the most reproducibility. However, it is the most confusing to set up since there are a lot of things the user has to download and commands to run. A good middle ground is the module environment, since you simply have to load the module and you can immediately start using the keyword. However, this requires an admin or someone else downloading and maintaining the module. So for personal use, I think conda wins out since once you learn it, you can apply it to any package and it is the most up to date and professional as long as you remember to never initialize it to your PATH!

