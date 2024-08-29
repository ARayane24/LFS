#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing
# source to generate colors (https://ansi.gabebanks.net/) by ANSI codes


# example :
# echo -e "${PROCESS}ERROR ${NO_STYLE} This is light blue text"

SAVE="

### Colors
export ERROR='\033[31;49;1m'      # Red color
export STEP='\033[34;49;1m'       # blue color
export TEST='\033[37;42;1;3m'     # Green bg & wite font
export OK='\033[32;49m'           # GREEN ok
export TITLE='\033[39;49;1;3;4m'  # bold & italic & undelined
export PROCESS='\x1b[37;43;1m'    # Yellow bg & wite font
export NO_STYLE='\033[0m'         # No Color (reset)

"
echo "$SAVE" >> $SHARED_FILE
sync

