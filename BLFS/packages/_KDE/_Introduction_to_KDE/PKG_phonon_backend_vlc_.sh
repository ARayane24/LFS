#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_phonon_backend_vlc_"
file_name_compiled="${file_name}_compiled"
path_to_compiled_pkgs="../../../../../../../../compiled_pckages.sh"

## check if already has been compiled
source "$path_to_compiled_pkgs"

if [[ -n "$file_name_compiled" && $file_name_compiled ]]; then
    echo -e "${OK}Already compiled${NO_STYLE}"
    exit 0
fi


# required packages:: (file calls with source)
call_method "PKG_vlc_" "./packages/_Multimedia/_Video_Utilities/PKG_vlc_.sh"


# recommended packages::


# optional packages::



# main ::
# Use eval to define the function
PKG_phonon_backend_vlc_() {
    # code
    ###PKG_phonon_backend_vlc_: 0.2SBU
    if [[ -n "$PKG_phonon_backend_vlc_" ]] ;then
        extract_tar_files /sources "$PKG_phonon_backend_vlc_"   
        echo -e "$PKG_phonon_backend_vlc_" " 0.2 SBU"
        echo $PKG_phonon_backend_vlc_
        cd $PKG_PKG_phonon_backendvlc
        next_pkg="$PKG_phonon"

        mkdir build &&
        cd    build &&

        cmake -D CMAKE_INSTALL_PREFIX=/usr \
            -D CMAKE_BUILD_TYPE=Release  \
            -D PHONON_BUILD_QT5=OFF      \
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
        rm -Rf $PKG_phonon_backend_vlc_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_phonon_backend_vlc_ "$TOOL_READY"


        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


