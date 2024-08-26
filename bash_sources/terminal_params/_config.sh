#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

source ./_colors_in_consol.sh
source $SHARED_FILE

# Define multiple lines of text to center
lines=("Welcome to My Program"
       "Create LFS easily !!")
layout=("${STEP}${lines[0]}${NO_STYLE}"
       "${TITLE}${lines[1]}${NO_STYLE}")

# Get the width of the terminal
terminal_width=$(tput cols)

# Loop through each line and print it centered
i=0
for text in "${lines[@]}"; do
    text_length=${#text}
    spaces=$(( (terminal_width - text_length) / 2 ))
    padding=$(printf "%${spaces}s")
    echo -e "${padding}${layout[$i]}"
     ((i++))
done

cd ./languages
# select_lang found in ./_methodes
source ./_methodes.sh
source ./_languages_man.sh
source $SHARED_FILE
cd ..

#Choosing language
select_lang
source $SHARED_FILE
bash $SELECTED_LANG
echo -e "$DONE"


# other methodes
source ./_util_methodes.sh

