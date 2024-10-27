#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_mlt_"
file_name_compiled="${file_name}_compiled"
path_to_compiled_pkgs="../../../../../../../../compiled_pckages.sh"

## check if already has been compiled
source "$path_to_compiled_pkgs"

if [[ -n "$file_name_compiled" && $file_name_compiled ]]; then
    echo -e "${OK}Already compiled${NO_STYLE}"
    exit 0
fi


# required packages:: (file calls with source)
call_method "PKG_freir_plugins_" "./packages/_Multimedia/_Multimedia_Libraries_and_Drivers/PKG_freir_plugins_.sh"
call_method "PKG_qt_everywhere_src_" "./packages/_Graphical_Components/_Display_Managers/PKG_qt_everywhere_src_.sh"


# recommended packages::


# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
    call_method "PKG_doxygen_src"   "./packages/_libs/_system_utilities/PKG_doxygen_src.sh"
    call_method "PKG_fftw_"         "./packages/_libs/_general_/PKG_fftw_.sh"
    call_method "PKG_libexif_"      "./packages/_libs/_graphical_and_font/PKG_libexif_.sh"
    call_method "PKG_SDL_"          "./packages/_Multimedia/_Multimedia_Libraries_and_Drivers/PKG_SDL_.sh"
    call_method "PKG_qt_everywhere_opensource_src_"      "./packages/_Graphical_Components/_Display_Managers/PKG_qt_everywhere_opensource_src_.sh"
fi



# main ::
# Use eval to define the function
PKG_mlt_() {
# code
     ###PKG_mlt_: 0.1 SBU
    if [[ -n "$PKG_mlt_" ]] ;then
        extract_tar_files /sources "$PKG_mlt_"
        echo -e "$PKG_mlt_" " 0.1 SBU"
        echo $PKG_mlt_
        cd $PKG_mlt_
        next_pkg="$PKG_mlt_"


        mkdir build &&
        cd    build &&

        cmake -D CMAKE_INSTALL_PREFIX=/usr \
            -D CMAKE_BUILD_TYPE=Release  \
            -D MOD_QT=OFF                \
            -D MOD_QT6=ON                \
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
        rm -Rf $PKG_mlt_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_mlt_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


