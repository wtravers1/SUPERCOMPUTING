## Command Log (Assignment 1)
The following commands were executed from 'SUPERCOMPUTING/assignments/assignment_01' directory

1. Initialize primary documentation
	touch README.md assignment_1_essay.md
*Note: Created the README and assignment_1_essay both as markdown files*

2. Create base directory architecture
	mkdir config data docs logs results scripts
	mkdir -p data/{clean,raw}
*Note: I used -p and braces to create the nested directories without having to traverse back and forth into the data directory*

3. Generate placeholder files
   `touch data/clean/clean_data.csv data/raw/raw_data.csv`
   `touch config/settings.conf docs/assignment_documentation.md logs/logfile.log results/output.txt scripts/script.sh`
*Note: Created empty placeholder files with file types that match their intended uses*

4. Verify assignment structure
	cmd //c tree //f
*Note: generates a visual tree to confirm contents match assignment requirements*

## Explanation and Assignment Notes
**Project Structure**: I chose this layout to follow best practices for reproducible research. By separating data, scripts, and results, the workflow remains organized and easy for others to navigate.
** Future Formatting**: This space will be used more for future assignments where there is more complexity and things that need extra explanation for others.
