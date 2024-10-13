#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing


# Define input file and number of lines to skip
input_file="/home/user/Desktop/LFS/BLFS/Packages/all_packages_index.sh"
number_of_lines_skiped=5
pre_count=0

# Create and change to the test directory
mkdir -vp ./test
cd test || exit 1

# Read the file line by line
while IFS= read -r line; do
    if (( number_of_lines_skiped > 0 )); then
        ((number_of_lines_skiped--))
        continue
    fi

    if [[ "$line" == "## others ::" ]]; then
        break
    fi

    # Count the number of '#' characters in the line
    count=$(grep -o "#" <<< "$line" | wc -l)
    
    if ((count > 0)) ; then
        # Check if the current count is greater than the previous count
        if (( count > pre_count )); then
            echo "Entered directory: $dir_name (count increased to $count)"
        else
            echo "Returned to parent directory (count: $count not greater than $pre_count)"
            cd .. || exit 1
        fi

        # Clean up the directory name by removing '#' and replacing spaces with underscores
        dir_name=$(echo "$line" | sed 's/#//g; s/ /_/g')
        mkdir -vp "$dir_name"
        cd "$dir_name" || exit 1

        pre_count=$count
    fi


    # Extract and process the substring before the '='
    if [[ $line =~ ^export\ ([^=]+)= ]]; then
        extracted_text="${BASH_REMATCH[1]}"
        bash /home/user/Desktop/LFS/BLFS/model.sh "$extracted_text" || exit 1
    fi
done < "$input_file"

