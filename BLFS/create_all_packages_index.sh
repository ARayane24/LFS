#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing


# usage (as user not root) : bash /home/user/Desktop/LFS/BLFS/create_all_packages_index.sh all-blfs-wget-list


# Check if an input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <file_with_links>"
    exit 1
fi

dir="Packages"
mkdir -v $dir
resultFile="./$dir/all_packages_index.sh"
chmod -v a+wt  $dir
chmod -v a+wt  $resultFile


echo -e "#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing\n" > $resultFile

# Read the input file line by line
number_files=0
while IFS= read -r line; do
    # Skip empty lines
    if [[ -z "$line" ]]; then
        continue
    fi

    # Get the filename
    filename=$(basename "$line")
    pkg_name_version="${filename%.*}"   # Remove the file extension


    # Get the package name and remove numbers
    pkg_name="${filename%.tar.*}"   # Remove .tar and .gz or .tar.xz etc.
    pkg_name_no_numbers="${pkg_name//[0-9\.]/}"  # Remove numbers

    # Get the version
    pkg_version="${pkg_name_version##*-}" # Get the version

    # Format the output variables
    export_var_name="PKG_${pkg_name_no_numbers//-/_}"
    # Print the export statements
    echo "export $export_var_name=\"$pkg_name_no_numbers${pkg_version%.tar}\"" >> $resultFile

    ((number_files++))
done < "$1"

echo -e "\n # total number of packages : $number_files" >> $resultFile

