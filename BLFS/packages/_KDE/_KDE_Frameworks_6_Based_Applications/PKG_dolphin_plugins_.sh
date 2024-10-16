#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_dolphin_plugins_plugins_"
file_name_compiled="${file_name}_compiled"
path_to_compiled_pkgs="../../../../../../../../compiled_pckages.sh"

## check if already has been compiled
source "$path_to_compiled_pkgs"

if [[ -n "$file_name_compiled" && $file_name_compiled ]]; then
    echo -e "${OK}Already compiled${NO_STYLE}"
    exit 0
fi


# required packages:: (file calls with source)
call_method "PKG_dolphin_" "./packages/_KDE/_KDE_Frameworks_6_Based_Applications/PKG_dolphin_.sh"


# recommended packages::


# optional packages::



# main ::
# Use eval to define the function
PKG_dolphin_plugins_plugins_() {
    # code
     ###PKG_dolphin_plugins_: 0.2 SBU
    if [[ -n "$PKG_dolphin_plugins_" ]] ;then
        extract_tar_files /sources "$PKG_dolphin_plugins_"
        echo -e "$PKG_dolphin_plugins_" " 0.2 SBU"
        echo $PKG_dolphin_plugins_
        cd $PKG_dolphin_plugins_
        next_pkg="$PKG_dolphin_plugins_"


        mkdir build &&
        cd    build &&

        cmake -D CMAKE_INSTALL_PREFIX=$KF6_PREFIX \
            -D CMAKE_BUILD_TYPE=Release         \
            -D BUILD_TESTING=OFF                \
            -W no-dev .. &&
        make
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
        rm -Rf $PKG_dolphin_plugins_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_dolphin_plugins_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


