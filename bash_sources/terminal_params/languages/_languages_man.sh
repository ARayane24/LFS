#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing


# Get the directory of the current script
SCRIPT_DIR=$(dirname "$(realpath "$0")")

cd $SCRIPT_DIR

# Get all languages (files) that don't start with an underscore and store them in an array
export ALL_LANGUAGES=($(ls -1 | grep -v '^_' | column))

# Get the length of the array
export ALL_LANGUAGES_LENGTH=${#ALL_LANGUAGES[@]}

# Print the number of languages
echo -e "\nThere are $ALL_LANGUAGES_LENGTH languages to choose from !!\n"


# Prepare the content to be appended
SAVE="
### Languages
export ALL_LANGUAGES=(${ALL_LANGUAGES[*]})
export ALL_LANGUAGES_LENGTH=$ALL_LANGUAGES_LENGTH
export SCRIPT_DIR=$SCRIPT_DIR
"

# Append the content to $SHARED_FILE
echo "$SAVE"  >> $SHARED_FILE

source ./_methodes.sh
source $SHARED_FILE
#Choosing language
select_lang
bash $SELECTED_LANG

