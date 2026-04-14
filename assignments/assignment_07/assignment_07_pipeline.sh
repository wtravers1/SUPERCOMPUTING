#!/bin/bash
#SBATCH --job-name=assignment_07
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=12:00:00
#SBATCH --mem=32G
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=wtravers@wm.edu
#SBATCH -o /sciclone/home/wtravers/SUPERCOMPUTING/assignments/assignment_07/output/assignment_07.out
#SBATCH -e /sciclone/home/wtravers/SUPERCOMPUTING/assignments/assignment_07/output/assignment_07.err

set -ueo pipefail

# load samtools from module env
module load samtools/gcc-11.4.1/1.22.1

# start script 1
./scripts/01_download_data.sh

# start script 2
./scripts/02_clean_reads.sh

# start script 3
./scripts/03_map_reads.sh
