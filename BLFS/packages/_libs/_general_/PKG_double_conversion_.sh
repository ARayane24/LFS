#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_double_conversion_"
file_name_compiled="${file_name}_compiled"
path_to_compiled_pkgs="../../../../../../../../compiled_pckages.sh"

## check if already has been compiled
source "$path_to_compiled_pkgs"

if [[ -n "$file_name_compiled" && $file_name_compiled ]]; then
    echo -e "${OK}Already compiled${NO_STYLE}"
    exit 0
fi


# required packages:: (file calls with source)
call_method "PKG_cmake_" "./packages/_libs/_system_utilities/PKG_cmake_.sh"


# recommended packages::

# optional packages::



# main ::
# Use eval to define the function
PKG_double_conversion_() {
    # code
     ###PKG_double_conversion_: 0.1 SBU
    if [[ -n "$PKG_double_conversion_" ]] ;then
        extract_tar_files /sources "$PKG_double_conversion_"
        echo -e "$PKG_double_conversion_" " 0.1 SBU"
        echo $PKG_double_conversion_
        cd $PKG_double_conversion_
        next_pkg="$PKG_double_conversion_"

        mkdir build &&
        cd    build &&

        cmake -D CMAKE_INSTALL_PREFIX=/usr \
            -D BUILD_SHARED_LIBS=ON      \
            -D BUILD_TESTING=ON          \
            ..                          &&
        make
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export error_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        if $DO_OPTIONNAL_TESTS; then
            make test
        fi

        make install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export error_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"


        cd /sources/blfs
        rm -Rf $PKG_double_conversion_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_double_conversion_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


