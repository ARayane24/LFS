#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

# Define input file and number of lines to skip
input_file="/home/user/Desktop/LFS/BLFS/file.sh" # from xpath result in oxygen

# Create or clear the output file
echo "" > tree.txt
var=$(grep -Pzr -o "Description:.*\nXPath\s*location:.*" "$input_file" | sed 's/Description: /\n\n/g' | sed 's/XPath location: //g')

# Convert var into an array
readarray -t lines <<< "$var"

# Read the array line by line
for (( i=0; i<${#lines[@]}-1; i++ )); do
    line1="${lines[i]}"          # Current element
    line2="${lines[i+1]}"        # Next element

    if [[  -n "$line1" && "$line2" == *"h2[1]/text()"* ]]; then
        echo -e "\nPKG: $line1" >> tree.txt
    elif [[ "$line2" == *"/@class" ]]; then
        echo -e "\t#$line1" >> tree.txt
    elif [[ -n "$line1" && "$line2" == *"/@title" ]]; then
        echo -e "\t\t|--$line1" >> tree.txt
    fi
done