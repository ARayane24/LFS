#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_pulseaudio_qt_"
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
call_method "PKG_pulseaudio_" "./packages/_Multimedia/_Multimedia_Libraries_and_Drivers/PKG_pulseaudio_.sh"


# recommended packages::


# optional packages::



# main ::
# Use eval to define the function
PKG_pulseaudio_qt_() {
    # code
     ###PKG_pulseaudio_qt_: 0.1 SBU
    if [[ -n "$PKG_pulseaudio_qt_" ]] ;then
        extract_tar_files /sources "$PKG_pulseaudio_qt_"
        echo -e "$PKG_pulseaudio_qt_" " 0.1 SBU"
        echo $PKG_pulseaudio_qt_
        cd $PKG_pulseaudio_qt_
        next_pkg="$PKG_pulseaudio_qt_"


        mkdir build &&
        cd    build &&

        cmake -D CMAKE_INSTALL_PREFIX=$KF6_PREFIX \
            -D CMAKE_PREFIX_PATH=$QT6DIR        \
            -D CMAKE_SKIP_INSTALL_RPATH=ON      \
            -D CMAKE_BUILD_TYPE=Release         \
            -D BUILD_TESTING=OFF                \
            -D QT_MAJOR_VERSION=6               \
            .. &&
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
        rm -Rf $PKG_pulseaudio_qt_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_pulseaudio_qt_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


