#!/bin/bash
set -ueo pipefail

# SCRIPT 2: DOWNLOAD FLYE USING LOCAL BUILD

# clone repo and make. if flye exists, skip clone
cd ~/programs
[ ! -d "Flye" ] && git clone https://github.com/fenderglass/Flye
cd Flye
make
