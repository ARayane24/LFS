#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_kirigami_addons_"
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

# recommended packages::
if [[ -n "$recommended_packages" && $recommended_packages ]]; then
    call_method "PKG_Vulkan_Loader_" "./packages/_Graphical_Components/_Display_Managers/PKG_Vulkan_Loader_.sh"
fi


# optional packages::



# main ::
# Use eval to define the function
PKG_kirigami_addons_() {
    # code
     ###PKG_kirigami_addons_: 0.6 SBU
    if [[ -n "$PKG_kirigami_addons_" ]] ;then
        extract_tar_files /sources "$PKG_kirigami_addons_"
        echo -e "$PKG_kirigami_addons_" " 0.6 SBU"
        echo $PKG_kirigami_addons_
        cd $PKG_kirigami_addons_
        next_pkg="$PKG_kirigami_addons_"


        mkdir build &&
        cd    build &&

        cmake -D CMAKE__INSTALL_PREFIX=$KF6_PREFIX \
            -D CMAKE_BUILD_TYPE=Release          \
            -D BUILD_TESTING=OFF                 \
            ..                                  &&
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
        rm -Rf $PKG_kirigami_addons_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_kirigami_addons_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


