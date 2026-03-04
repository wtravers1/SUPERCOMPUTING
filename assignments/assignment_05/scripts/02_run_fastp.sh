#!/bin/bash
set -ueo pipefail

# define input and output environmental variables
FWD_IN=$1
REV_IN=${FWD_IN/_R1_/_R2_} # read in reversed file by replacing _R1_ with _R2_
FWD_OUT=${FWD_IN/.fastq.gz/.trimmed.fastq.gz} # replace raw with trimmed before extension in file name
REV_OUT=${REV_IN/.fastq.gz/.trimmed.fastq.gz} # repeat for reversed file

# execute fastp command
fastp \
--in1 $FWD_IN \
--in2 $REV_IN \
--out1 ${FWD_OUT/raw/trimmed} \
--out2 ${REV_OUT/raw/trimmed} \
--json /dev/null \
--html ./log/${FWD_OUT##*/}.html \
--trim_front1 8 \
--trim_front2 8 \
--trim_tail1 20 \
--trim_tail2 20 \
--n_base_limit 0 \
--length_required 100 \
--average_qual 20
