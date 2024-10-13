#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing


if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <file_with_links>"
    exit 1
fi

# Define the unique file name
unique_file="compiled_pckages.sh"
save_current_dir="$(pwd)"
current_dir="$(pwd)"
path=""
    
# Loop until we reach the root directory or find the target
while [[ "$current_dir" != "/" ]]; do
    if [[ "$(basename "$current_dir")" == "Packages" ]]; then
        break
    fi
    
    # Move to the parent directory
    cd ..
    current_dir="$(pwd)"
    path="../$path"
done

cd $save_current_dir

echo -e "#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name=\"$1\"
file_name_compiled=\"\${file_name}_compiled\"
path_to_compiled_pkgs=\"$path$unique_file\"

## check if already has been compiled
source \"\$path_to_compiled_pkgs\"

if [[ -n \"\$file_name_compiled\" && "\$file_name_compiled" ]]; then
    echo -e \"\${OK}Already compiled\${NO_STYLE}\"
    exit 0
fi


# required packages:: (file calls with source)
# call_method method_name file_path(source)


# recommended packages::
if [[ -n \"\$recommended_packages\" && "\$recommended_packages" ]]; then
   
   

fi


# optional packages::
if [[ -n \"\$optional_packages\" && "\$optional_packages" ]]; then
   
   

fi



# main ::
# Use eval to define the function
$1() {
    # code


    # end
    echo -e \"\$file_name_compiled=true\" >> \$path_to_compiled_pkgs
}

" > $1.sh