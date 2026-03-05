## Assignment #5 ##
Wyatt Travers
3-4-26

## Assignment Tree
```text
│   pipeline.sh
│   README.md
│
├───data
│   ├───raw
│   │       .gitkeep
│   │
│   └───trimmed
│           .gitkeep
│
├───log
│       .gitkeep
│
└───scripts
        01_download_data.sh
        02_run_fastp.sh
```

## Setup assignment_05/ directory
```
mkdir data log scripts
mkdir ./data/raw ./data/trimmed
touch ./data/raw/.gitkeep ./data/trimmed/.gitkeep ./log/.gitkeep
```
Add a .gitkeep file in both data and log directories to keep the file structure (since .gz and .html files are hidden in .gitignore).

## Installing fastq into ~/programs
Ran the following code to install fastq into my programs directory:
```
wget http://opengene.org/fastp/fastp
chmod a+x ./fastp
```
Wanted to check the version with `fastp --version` because I downloaded an unkown "most up-to-date" one. I am on fastp 1.1.0 for this assignment.

## Creating 01_download_data.sh
```
#!/bin/bash
set -ueo pipefail

# download fastq data file, extract into ./data/raw, and clean up initial file
wget https://gzahn.github.io/data/fastq_examples.tar
tar -xf fastq_examples.tar -C ./data/raw # unpack data into data/raw instead of current directory
rm fastq_examples.tar
```

## Creating 02_run_fastp.sh
```
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
--out1 ${FWD_OUT/raw/trimmed} \ # save output to data/trimmed instead of data/raw
--out2 ${REV_OUT/raw/trimmed} \ # repeat for reversed output
--json /dev/null \ # discard JSON report into null
--html ./log/${FWD_OUT##*/}.html \ # save HTML report to log folder
--trim_front1 8 \
--trim_front2 8 \
--trim_tail1 20 \
--trim_tail2 20 \
--n_base_limit 0 \
--length_required 100 \
--average_qual 20
```

## Creating pipeline.sh
```
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
```
## Miscellaneous Notes
- After creating the 3 .sh scripts, make sure to run the following command to add the correct permissions to the files: `chmod 750 <file_name>`. 
- When creating the 02_run_fastp.sh script, I wanted to verify the environmental variable names before working on the fastp command. I added `echo $FWD_IN $REV_IN $FWD_OUT $REV_OUT` and ran it on a test file in data to verify the naming was correct. 
- To run the pipeline, all the user needs to do is execute `./pipieline.sh` from the assignment_05 directory.

## Personal Reflection
I think the reason we split this assignment into two separate scripts is to keep the main parts of the pipeline contained in case of errors in the workflow. Running the entire script in one file will most likely lead to a higher chance of running into an error, and splitting up the work into parts makes sure that I can run everything from top to bottom smoothly, and have an easier time finding what went wrong when things break (which happens to me too often). Also, having a script specifically for downloading data and another for the cleaning is useful if I only want to run one part. If someone has their own .gz files and just wants to use the cleaning part, not having to go into a large script and take out what they need (which is already dangerous) and instead just running the run_fastp file is quite handy. One of the main errors I ran into was when initially running the run_fastp script from my scripts folder. Since the script contains a few relative paths, which assume I am in my assignment_05 directory, some of the commands (like moving the HTML output to the log folder) were not working correctly. Making sure that there is a known start, and how the directories branch off where the script is being run, is important for the user to know. I’m definitely getting more comfortable with downloading things from the internet (specifically GitHub). Last assignment, downloading seqk had me running into some issues since I did not fully read the documentation, and had to troubleshoot getting the program to work once it was on my folder. This time, I scanned the GitHub and made sure I was downloading the program for Linux and running the additional commands, which made the process much easier. This has definitely been the most fun assignment so far, and I’m curious to see how these pipelines start to look with much more complex scripts and larger data sets.

