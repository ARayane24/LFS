#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_gwenview_"
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
call_method "PKG_exiv2_" "./packages/_libs/_graphical_and_font/PKG_exiv2_.sh"
call_method "PKG_kImageAnnotator_" "./packages/_Graphical_Components/_Display_Managers/PKG_kImageAnnotator_.sh"
call_method "PKG_lcms_" "./packages/_libs/_graphical_and_font/PKG_lcms_.sh"

# recommended packages::
if [[ -n "$recommended_packages" && $recommended_packages ]]; then
   call_method "PKG_libkdcraw_" "./packages/_KDE/_KDE_Frameworks_6_Based_Applications/PKG_libkdcraw_.sh"
   

fi


# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
   call_method "PKG_plasma_activities_" "./packages/_KDE/_KDE_Frameworks_6_Based_Applications/PKG_plasma_activities_.sh"
   #CFitsio (NOT IN BOOK)

fi



# main ::
# Use eval to define the function
PKG_gwenview_() {
    # code

    if [[ -n "$PKG_gwenview_" ]] ;then
        extract_tar_files /sources "$PKG_gwenview_"
        echo -e "$PKG_gwenview_" " 0.2 SBU"
        echo $PKG_gwenview_
        cd $PKG_gwenview_
        next_pkg="$PKG_gwenview_"

        mkdir build &&
        cd build &&

        cmake -D CMAKE_INSTALL_PREFIX=$KF6_PREFIX \
        -D CMAKE_BUILD_TYPE=Release \
        -D BUILD_TESTING=OFF \
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

        cd /sources/BLFS
        rm -r $PKG_gwenview_
        echo -e "$DONE"
        echo -e $PKG_gwenview_ "$TOOL_READY"


        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
}


