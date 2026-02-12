# Assignment #2
** Wyatt Travers **
** 02-11-26 **

## Directory Structure
├───assignment_02
│   │   README.md
│   │
│   └───data
│           GCF_000005845.2_ASM584v2_genomic.fna.gz
│           GCF_000005845.2_ASM584v2_genomic.gff.gz
** NOTE: in my local directory I added a .gitkeep file to push data folder to GitHub, since .gitignore is blocking .gz files. **

## Command Log
** [in local] **
- `mkdir data`, `cd data/` - add and traverse a data folder to assignments_02
- `touch .gitkeep` - add skeleton file for later git push
- `ftp`
- `open ftp.ncbi.nlm.nih.gov` - login with user: anonymous AND password: personal email
- `cd genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/` - traverse to intended file path
- `mget GCF_000005845.2_ASM584v2_genomic.fna.gz GCF_000005845.2_ASM584v2_genomic.gff.gz`
- `md5sum *.gz` - generate hash tokens for data in local folder, using * to select all files in /data that end with .gz
- `git add .`, `git commit -m <message.>`, `git push` - push data folder to github
** NOTE: windows firewall blocked my mget command, so I used WinSCP to log into server and download files into my data folder. **
** [in hpc] **
- `bora` - log in to bora -> enter password
- `git pull` - update directory with data folder
- `cd SUPERCOMPUTING/assignments/assignment_02/data` - traverse to data folder in assignment_02
- `ls -l` - check for permissions. I see that both data files are not world readable
- `chmod 644 *gz` - 6 (gives owner permission to read and write) 4 (gives group permission to read) 4 (gives world permission to read)
- `md5sum *.gz`- generate hash tokens for data in hpc folder

## File Verification (MD5 Hashes)
| GCF_000005845.2_ASM584v2_genomic.fna.gz | Local Hash: [c13d459b5caa702ff7e1f26fe44b8ad7] | HPC Hash: [c13d459b5caa702ff7e1f26fe44b8ad7] | Match?: YES |
| GCF_000005845.2_ASM584v2_genomic.gff.gz | Local Hash: [2238238dd39e11329547d26ab138be41] | HPC Hash: [2238238dd39e11329547d26ab138be41] | Match?: YES |

## Bash Aliases
- `u`: moves back one directory level > clears screen > prints current working directory > lists all files (including hidden) with human-readable sizes, grouping directories first.
- `d`: returns to the previous directory > clears screen > prints current working directory > lists all files (including hidden) with human-readable sizes, grouping directories first.
- `ll`: lists all files in the current directory with detailed information and human-readable sizes, grouping directories first.

## Reflection
By far the biggest roadblock I had this assignment was using the mget command during the ftp connection with the .gov database. By roadblock, I mean it was impossible because Windows firewall blocks me from pulling files (I know, I'm a terrible person for using Windows). To get around this, I used WinSCP to connect to the server and manually dragged the two target files into my local repo. Once this was out of the way, the rest of the project flowed smoothly (besides a merge conflict when I forgot to pull a file). I also had difficulty with pushing the data folder for assignment_02 to my GitHub so it would appear in my HPC repo. Because we are not supposed to push real data files to GitHub, and the only two files I added to my folder are real, the folder was not being commited. The cleanest way I found (instead of a text or dummy data file) was to add a .gitkeep to make sure there was something for GitHub to take. I would probably try to find more shortcuts like the `/*` before a file extenstion to save time and make my life easier.
