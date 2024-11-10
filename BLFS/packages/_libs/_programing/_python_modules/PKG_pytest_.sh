#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_pytest_"
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
PKG_pytest_() {
# code
     ###PKG_pytest_: 1.3 SBU
    if [[ -n "$PKG_pytest_" ]] ;then
        extract_tar_files /sources "$PKG_pytest_"
        echo -e "$PKG_pytest_" " 1.3 SBU"
        echo $PKG_pytest_
        cd $PKG_pytest_
        next_pkg="$PKG_pytest_"

        pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
        pip3 install --no-index --find-links=dist --no-cache-dir --no-user pytest

        python3 -m venv --system-site-packages testenv &&
        source testenv/bin/activate                    &&
        pip3 install pytest[dev] xmlschema hypothesis  &&
        python3 /usr/bin/pytest
        deactivate

        cd /sources/blfs
        rm -Rf $PKG_pytest_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_pytest_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}