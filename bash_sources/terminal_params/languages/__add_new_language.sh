#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

clear

# Get all languages (files) that don't start with an underscore and store them in an array
export ALL_LANGUAGES=($(ls -1 | grep -v '^_' | column))

while true; do
    read -p "Input the ISO code of the language (ex: Arabic -> AR / Français -> FR ...): " Language_iso_code
    
    # Check if Language_iso_code is not empty
    if [[ -z "$Language_iso_code" ]]; then
        echo "Variable is empty."
        continue
    fi

    # Check if Language_iso_code matches the pattern [A-Z]
    if [[ ! "$Language_iso_code" =~ ^[A-Z]+$ ]]; then
        echo "Variable does not match the pattern [A-Z]."
        continue
    fi

    found=false  # Initialize found to false at the start of the loop
    for lang in "${ALL_LANGUAGES[@]}"; do
        # Remove the .sh extension for comparison
        lang_name="${lang%.sh}"
        
        if [[ "$lang_name" == "$Language_iso_code" ]]; then
            found=true
            break
        fi
    done

    if $found; then
        echo "The selected language already exists!"
        continue
    fi

    # If all checks passed
    echo "Adding new language: $Language_iso_code"
    break
done


### context 
# Define the file to read
file="EN.sh"

# Check if the file exists
if [[ ! -f "$file" ]]; then
    echo "File not found!"
    exit 1
fi

# Read all lines from the file into an array
mapfile -t lines < "$file"

for line in "${lines[@]}"; do
    clear
    if [[ $line == *"="* && $line != *"SAVE="* ]]; then
        var1="${line%%=*}="
        var2="${line#*=}"

        echo -e "\033[34;49;1mtranslate: \033[0m"
        echo "${var2//\\\"/}"
        
        read -r -p "Input the translation of the string above: " translation
        echo "$var1\\\"$translation\\\"" >> "$Language_iso_code.sh"
    else
        echo "$line" >> "$Language_iso_code.sh"
    fi
done
