#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_okular_"
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
call_method "PKG_plasma_activities_" "./packages/_KDE/_KDE_Frameworks_6_Based_Applications/PKG_plasma_activities_.sh"


# recommended packages::
if [[ -n "$recommended_packages" && $recommended_packages ]]; then
   call_method "PKG_libkexiv_" "./packages/_KDE/_KDE_Frameworks_6_Based_Applications/PKG_libkexiv_.sh"
   call_method "PKG_libtiff_" "./packages/_libs/_graphical_and_font/PKG_libtiff_.sh"
   call_method "PKG_poppler_" "./packages/_libs/_graphical_and_font/PKG_poppler_.sh"
   

fi


# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
   call_method "PKG_qca_" "./packages/_libs/_general_/PKG_qca_.sh"
   #Discount, DjVulibre, EPub, LibSpectre, LibZip (NOT IN BOOK) if added later remove line 59 (SKIP_OPTIONAL).

fi



# main ::
# Use eval to define the function
PKG_okular_() {
    # code

    if [[ -n "$PKG_okular_" ]] ;then
        extract_tar_files /sources "$PKG_okular_"
        echo -e "$PKG_okular_" " 0.8 SBU"
        echo $PKG_okular_
        cd $PKG_okular_
        next_pkg="$PKG_okular_"

        mkdir build &&
        cd build &&

        SKIP_OPTIONAL='Discount;DjVuLibre;EPub;LibSpectre;LibZip'
        cmake -D CMAKE_INSTALL_PREFIX=$KF5_PREFIX \
        -D CMAKE_BUILD_TYPE=Release \
        -D BUILD_TESTING=OFF \
        -D FORCE_NOT_REQUIRED_DEPENDENCIES="$SKIP_OPTIONAL" \
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
        rm -r $PKG_okular_
        echo -e "$DONE"
        echo -e $PKG_okular_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
}


