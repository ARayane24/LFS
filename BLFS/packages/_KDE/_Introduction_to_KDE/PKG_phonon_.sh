#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_phonon_"
file_name_compiled="${file_name}_compiled"
path_to_compiled_pkgs="../../../../../../../../compiled_pckages.sh"

## check if already has been compiled
source "$path_to_compiled_pkgs"

if [[ -n "$file_name_compiled" && $file_name_compiled ]]; then
    echo -e "${OK}Already compiled${NO_STYLE}"
    exit 0
fi


# required packages:: (file calls with source)
call_method "PKG_cmake_"                "./packages/_libs/_system_utilities/PKG_cmake_.sh"
call_method "PKG_glib_"                 "./packages/_libs/_general_/PKG_glib_.sh"
call_method "PKG_qt_everywhere_src_"    "./packages/_Graphical_Components/_Display_Managers/PKG_qt_everywhere_src_.sh"


# recommended packages::
if [[ -n "$recommended_packages" && $recommended_packages ]]; then
   
   

fi


# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
   
   

fi



# main ::
# Use eval to define the function
PKG_phonon_() {
    # code
    ###PKG_phonon_: 0.2 SBU
    if [[ -n "$PKG_phonon_" ]] ;then
        extract_tar_files /sources "$PKG_phonon_"
        echo -e "$PKG_phonon_" " 0.2 SBU"
        echo $PKG_phonon_
        cd $PKG_phonon_
        next_pkg="$PKG_phonon_"


        mkdir build &&
        cd    build &&

        cmake -D CMAKE_INSTALL_PREFIX=/usr \
            -D CMAKE_BUILD_TYPE=Release  \
            -D PHONON_BUILD_QT5=OFF      \
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
        rm -Rf $PKG_phonon_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_phonon_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


