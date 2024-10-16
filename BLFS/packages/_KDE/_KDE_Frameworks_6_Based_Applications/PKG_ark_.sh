#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_ark_"
file_name_compiled="${file_name}_compiled"
path_to_compiled_pkgs="../../../../../../../../compiled_pckages.sh"

## check if already has been compiled
source "$path_to_compiled_pkgs"

if [[ -n "$file_name_compiled" && $file_name_compiled ]]; then
    echo -e "${OK}Already compiled${NO_STYLE}"
    exit 0
fi


# required packages:: (file calls with source)
source "./packages/_KDE/_KDE_Frameworks_6/building.sh"
call_method "PKG_libarchive_" "./packages/_libs/_general_/PKG_libarchive_.sh"


# recommended packages::
if [[ -n "$recommended_packages" && $recommended_packages ]]; then
   call_method "PKG_cpio_" "./packages/_libs/_system_utilities/PKG_cpio_.sh"
   call_method "PKG_pzip_" "./packages/_libs/_system_utilities/PKG_pzip_.sh"
   call_method "PKG_unrarsrc_" "./packages/_libs/_system_utilities/PKG_unrarsrc_.sh"
   call_method "PKG_unzip" "./packages/_libs/_system_utilities/PKG_unzip.sh"
   call_method "PKG_zip" "./packages/_libs/_system_utilities/PKG_zip.sh"
fi

# optional packages::



# main ::
# Use eval to define the function
PKG_ark_() {
    # code
     ###PKG_ark_: 0.4 SBU
    if [[ -n "$PKG_ark_" ]] ;then
        extract_tar_files /sources "$PKG_ark_"
        echo -e "$PKG_ark_" " 0.4 SBU"
        echo $PKG_ark_
        cd $PKG_ark_
        next_pkg="$PKG_ark_"


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
        rm -Rf $PKG_ark_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_ark_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


