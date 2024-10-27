#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_utfcpp_"
file_name_compiled="${file_name}_compiled"
path_to_compiled_pkgs="../../../../../../../../compiled_pckages.sh"

## check if already has been compiled
source "$path_to_compiled_pkgs"

if [[ -n "$file_name_compiled" && $file_name_compiled ]]; then
    echo -e "${OK}Already compiled${NO_STYLE}"
    exit 0
fi


# required packages:: (file calls with source)
# call_method method_name file_path(source)

call_method "PKG_cmake_" "./packages/_libs/_system_utilities/PKG_cmake_.sh"


# recommended packages::



# optional packages::




# main ::
# Use eval to define the function
PKG_utfcpp_() {
    # code
     ###PKG_utfcpp_: 0.1 SBU
    if [[ -n "$PKG_utfcpp_" ]] ;then
        extract_tar_files /sources "$PKG_utfcpp_"
        echo -e "$PKG_utfcpp_" " 0.1 SBU"
        echo $PKG_utfcpp_
        cd $PKG_utfcpp_
        next_pkg="$PKG_utfcpp_"


        mkdir build &&
        cd    build &&

        cmake -D CMAKE_INSTALL_PREFIX=/usr ..
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export error_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        make install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export error_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        cd /sources/blfs
        rm -Rf $PKG_utfcpp_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_utfcpp_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


