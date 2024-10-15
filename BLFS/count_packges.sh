#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing


# Define input file and number of lines to skip
input_file="/home/user/Desktop/LFS/BLFS/packages/all_packages_index.sh"
number_of_lines_skiped=5
pre_count=0

# Read the file line by line
while IFS= read -r line; do
    if (( number_of_lines_skiped > 0 )); then
        ((number_of_lines_skiped--))
        continue
    fi

    if [[ "$line" == "## others ::" ]]; then
        break
    fi
    # Extract and process the substring before the '='
    if [[ $line =~ ^export\ ([^=]+)= ]]; then
        ((pre_count++))
    fi
done < "$input_file"

echo "Total number of packages: $pre_count"
