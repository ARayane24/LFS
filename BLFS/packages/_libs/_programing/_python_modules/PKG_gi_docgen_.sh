#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="Gi-DocGen-2024.1"
file_name_compiled="${file_name}_compiled"
path_to_compiled_pkgs="../../../compiled_pckages.sh"

## check if already has been compiled
source "$path_to_compiled_pkgs"

if [[ -n "$file_name_compiled" && $file_name_compiled ]]; then
    echo -e "${OK}Already compiled${NO_STYLE}"
    exit 0
fi


# required packages:: (file calls with source)



# recommended packages::



# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
  
   

fi



# main ::
# Use eval to define the function
PKG_gi_docgen_() {
# code
     ###PKG_gi_docgen_: 0.1 SBU
    if [[ -n "$PKG_gi_docgen_" ]] ;then
        extract_tar_files /sources "$PKG_gi_docgen_"
        echo -e "$PKG_gi_docgen_" " 0.1 SBU"
        echo $PKG_gi_docgen_
        cd $PKG_gi_docgen_
        next_pkg="$PKG_gi_docgen_"

        sed -i '/if err:/s/err/proc.returncode/' gidocgen/utils.py
        pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
        pip3 install --no-index --find-links=dist --no-cache-dir --no-user gi-docgen

        cd /sources/blfs
        rm -Rf $PKG_gi_docgen_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_gi_docgen_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}