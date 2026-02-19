# Assignment #3
** Wyatt Travers **
** 2-19-26 **

## Directory Structure
├───assignment_03
│   │   README.md
│   │
│   └───data
│           GCF_000001735.4_TAIR10.1_genomic.fna
│           sequences.tsv
** NOTE: added sequences.tsv to solve problem #10 **

## Command Log
** [in hpc] **
- `mkdir data`, `cd data` - add and traverse to data folder in assignments_03
- `touch .gitkeep` - add skeleton file for later git push
- `wget https://gzahn.github.io/data/GCF_000001735.4_TAIR10.1_genomic.fna.gz` - download the entire file by copying url
- `gunzip https://gzahn.github.io/data/GCF_000001735.4_TAIR10.1_genomic.fna.gz` - unzip and delete original file

## Task 3 Problems
1. `grep "^>" GCF_000001735.4_TAIR10.1_genomic.fna | wc -l`
2. `grep -v "^>" GCF_000001735.4_TAIR10.1_genomic.fna | tr -d "\n" | wc -m`
3. `wc -l GCF_000001735.4_TAIR10.1_genomic.fna`
4. `grep "^>" GCF_000001735.4_TAIR10.1_genomic.fna | grep "mitochondrion" | wc -l`
5. `grep "^>" GCF_000001735.4_TAIR10.1_genomic.fna | grep "chromosome" | wc -l`
6. `sed -n '2p' GCF_000001735.4_TAIR10.1_genomic.fna | wc -m; sed -n '4p' GCF_000001735.4_TAIR10.1_genomic.fna | wc -m; sed -n '6p' GCF_000001735.4_TAIR10.1_genomic.fna | wc -m`
7. `sed -n '10p' GCF_000001735.4_TAIR10.1_genomic.fna | wc -m`
8. `grep -v "^>" GCF_000001735.4_TAIR10.1_genomic.fna | grep "AAAAAAAAAAAAAAAA" | wc -l`
9. `grep "^>" GCF_000001735.4_TAIR10.1_genomic.fna | sort | head -n 1`
10. `paste - - < GCF_000001735.4_TAIR10.1_genomic.fna > sequences.tsv` - NOTE: use head and cut command to check output of new file

## Reflection
I felt like this assignment was by far the most technically challenging one we’ve had so far. The thing about grep that confuses me the most is the order of the piping and setting up the command in a way that the standard output goes where I want it to. A couple times during task 3, I would use grep correctly to identify the part of the file I needed for the question, but ran into trouble finding the right way to pipe what I wanted into the terminal output. Also, for question 2 I had the issue where `wc -m` was counting the new line as a character, so I had to use `tr -d “\n”` to get the correct output. The skills I had to use for the assignment are definitely the most useful when working with large datasets like this one. Even though the file was huge (and trying to cat to see the structure of it would crash my terminal sometimes), the grep commands were super fast and I never had an issue with my code taking too long to run. To get around being unable to cat and control C the file to see the structure of some of the lines (even though I would instantly hit control C the file would print thousands of lines), I used the `cut -c` command after `head` so the output could fit on my screen. This was especially useful for problem #10, when I needed to see the line structure and the huge DNA strings were combined with the headings. I’m sure the stuff I did in this assignment could be automated to make it way more efficient, and I would guess this could be done by setting the file name to a variable and using some type of script. Someone using a script could simply run the script and get all of the same answers as me. This goes back to what we learned in the first reading, about how this would make my code much more reproducible, since someone running a script would be using the exact same commands as me. Since nothing would change between my code and the code of whoever was running the script, this would be a great way to check the accuracy of my answers, since we should (hopefully) get the exact same output.
