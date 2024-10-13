#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_desktop_file_utils_"
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


# recommended packages::
if [[ -n "$recommended_packages" && $recommended_packages ]]; then
   
   

fi


# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
   
   

fi



# main ::
# Use eval to define the function
PKG_desktop_file_utils_() {
    # code
    ###PKG_vlc: 0.1SBU
    if [[ -n "$PKG_vlc" && "$next_pkg" = "$PKG_vlc" ]] ;then
        echo -e "$PKG_vlc" " 0.1 SBU"
        echo $PKG_vlc
        cd $PKG_vlc

        patch -Np1 -i ../$PKG_vlc-taglib-1.patch         &&
        patch -Np1 -i ../$PKG_vlc-fedora_ffmpeg7-1.patch

        BUILDCC=gcc ./configure --prefix=/usr --disable-libplacebo &&
        make
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export next_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        make docdir=/usr/share/doc/$PKG_vlc install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export next_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        cd /sources/blfs
        rm -Rf $PKG_phonon #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_phonon "$TOOL_READY"
        next_pkg="$PKG_phonon_backend"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


