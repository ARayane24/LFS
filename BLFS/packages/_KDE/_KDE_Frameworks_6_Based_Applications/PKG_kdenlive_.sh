#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_kdenlive_"
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
source "./packages/_KDE/_KDE_Frameworks_6/building.sh"
call_method "PKG_mlt_" "./packages/_Multimedia/_Multimedia_Libraries_and_Drivers/PKG_mlt_.sh"
call_method "PKG_vl_utils_" "./packages/_Multimedia/_Multimedia_Libraries_and_Drivers/PKG_vl_utils_.sh"

# recommended packages::
if [[ -n "$recommended_packages" && $recommended_packages ]]; then
    call_method "PKG_breeze_icons_" "./packages/_Graphical_Components/_Icons/PKG_breeze_icons_.sh"
fi


# optional packages::


# main ::
# Use eval to define the function
PKG_kdenlive_() {
    # code
     ###PKG_kdenlive_: 1.7 SBU
    if [[ -n "$PKG_kdenlive_" ]] ;then
        extract_tar_files /sources "$PKG_kdenlive_"
        echo -e "$PKG_kdenlive_" " 1.7 SBU"
        echo $PKG_kdenlive_
        cd $PKG_kdenlive_
        next_pkg="$PKG_kdenlive_"


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
        rm -Rf $PKG_kdenlive_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_kdenlive_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


