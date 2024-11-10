#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_numpy_"
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
PKG_numpy_() {
# code
     ###PKG_numpy_: 0.1 SBU
    if [[ -n "$PKG_numpy_" ]] ;then
        extract_tar_files /sources "$PKG_numpy_"
        echo -e "$PKG_numpy_" " 0.1 SBU"
        echo $PKG_numpy_
        cd $PKG_numpy_
        next_pkg="$PKG_numpy_"

        pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir -Csetup-args=-Dallow-noblas=true $PWD
        pip3 install --no-index --find-links=dist --no-cache-dir --no-user numpy

        mkdir -p test                                  &&
        cd       test                                  &&
        python3 -m venv --system-site-packages testenv &&
        source testenv/bin/activate                    &&
        pip3 install hypothesis                        &&
        python -c "import numpy, sys; sys.exit(numpy.test() is False)"
        deactivate

        cd /sources/blfs
        rm -Rf $PKG_numpy_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_numpy_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}