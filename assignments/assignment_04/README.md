# Assignment #4
** Wyatt Travers **
** 2-26-26 **

## Downloading gh and seqtk into ~/programs
** install_gh.sh script **
```
#!/bin/bash
set -ueo pipefail
# traverse to root and into programs/ directory. if the directory does not exist, create it
mkdir -p ~/programs
cd ~/programs
# download gh file using link from github.com
wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz
tar -xzvf gh_2.74.2_linux_amd64.tar.gz
rm gh_2.74.2_linux_amd64.tar.gz
# add location to $PATH
echo "export PATH=$PATH:/sciclone/home/wtravers/programs/gh_2.74.2_linux_amd64/bin" >> ~/.bashrc
```
** NOTE: versions were mismatched for me. Using 2.74.2 for purpose of script **

** install_seqtk.sh script **
```
#!/bin/bash
set -ueo pipefail
# traverse to root and into programs/ directory. if the directory does not exist, create it
mkdir -p ~/programs
cd ~/programs
# download gh file using link from github.com
wget https://github.com/lh3/seqtk/archive/refs/tags/v1.5.tar.gz
tar -xzvf v1.5.tar.gz
rm v1.5.tar.gz
cd seqtk-1.5/
make
# add location to $PATH
echo 'export PATH=$PATH:/sciclone/home/wtravers/programs/seqtk-1.5' >> ~/.bashrc
```
** NOTE: cd into seqtk/ directory and use make command to create executable file **
** NOTE: when in programs/ directory, use command `chmod 750 <file name> to give .sh files executable privileges **

## Creating fasta files in data/ directory
```
cp ~/SUPERCOMPUTING/assignments/assignment_03/data/GCF_000001735.4_TAIR10.1_genomic.fna .
cp GCF_000001735.4_TAIR10.1_genomic.fna COPY_GCF_000001735.4_TAIR10.1_genomic.fna
```
** NOTE: I went to ftp database and downloaded 3 .fna files, however 2 of them did not have any sequences. Ended up copying .fna from assignment 3 because I knew it was a reliable dataset **

## Writing summarize_fasta.sh script
```
mkdir scripts/
cd scripts/
nano summarize_fasta.sh
```
** NOTE: created a scripts folder to store .sh file **

** summarize_fasta.sh script **
```
#!/bin/bash
set -ueo pipefail
# initialize variables and run seqtk commands
file=$1
nseq=$(seqtk size "$file" | cut -f1)
nnuc=$(seqtk size "$file" | cut -f2)
# store data in temp file
seqtk comp "$file" | cut -f1,2 > table.tmp
# report information with explanations
echo "---------------------------------------------------------------"
echo "Information for file: $file"
echo "---------------------------------------------------------------"
echo "Total number of sequences: $nseq"
echo "Total number of nucleotides: $nnuc"
echo "Sequence names and lengths:"
cat table.tmp
# remove temp table
rm table.tmp
```

## Command to Loop Through .fasta Files
```
for file in *.fna; do ~/SUPERCOMPUTING/assignments/assignment_04/scripts/summarize_fasta.sh "$file"; done
```

## Personal Reflection
If I didn’t run into any errors while working on this assignment, it probably wouldn’t have taken me more than an hour to finish. Unfortunately, this was not the case. Writing the scripts and downloading seqtk (since I already had gh) was easy. I created a test/ directory in my programs/ directory to verify my scripts worked before I ran them. However, I reached a problem when checking to see if seqtk was actually usable in bash. Whenever I tried to run a simple `seqtk` command to see if it was working, bash gave me a file not found error. To solve this, I had to traverse into the seqtk-1.5/ directory and run a `make` command to create a green executable file. I also had a problem with the path for gh. In the script, I assume the user has version 2.74.2, since that was the one linked in the assignment. However, I had version 2.74.0 in my programs, so the script was appending the wrong file name to the end of my $PATH variable. After troubleshooting, I manually changed my path in /.bashrc, but left the script as version 2.74.2, since a user running this for the first time will have consistent versions. On the topic of $PATH, I learned that it is essentially a list of directories that the shell searches through every time you type a command. By appending all the new program directories to this variable in my /.bashrc file, I made it possible to run the scripts from anywhere in my computer, since it will look through the folders and find the location instead of me manually having to type it out. I learned a lot about seqtk, mainly by typing seqtk and reading the commands. I was also confused on the formatting of fasta files, but after doing research began to understand how they are just a universal format of sequences that start with a > and contain huge lines of nucleotide characters.
