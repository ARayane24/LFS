#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="$PKG_which_"
file_name_compiled="${file_name}_compiled"
path_to_compiled_pkgs="../../compiled_pckages.sh"

## check if already has been compiled
source "$path_to_compiled_pkgs"

if [[ -n "$file_name_compiled" && $file_name_compiled ]]; then
    echo -e "${OK}Already compiled${NO_STYLE}"
    exit 0
fi


# main ::
# Use eval to define the function
eval "$file_name() {
    # code

    ./configure --prefix=/usr &&
    make
    make install

    # end
    echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
}"
