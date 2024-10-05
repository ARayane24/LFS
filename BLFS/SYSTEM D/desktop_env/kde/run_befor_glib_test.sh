#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing



###PKG_shared_mime_info: 0.1SBU
if [[ -n "$PKG_shared_mime_info" ]] ;then
    echo -e "$PKG_shared_mime_info" " 0.1 SBU"
    echo $PKG_shared_mime_info
    cd $PKG_shared_mime_info

    tar -xf ../xdgmime.tar.xz &&
    make -C xdgmime
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        echo "export next_pkg=$next_pkg" >> /.bashrc
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"


    mkdir build &&
    cd    build &&

    meson setup --prefix=/usr --buildtype=release -D update-mimedb=true .. &&
    ninja

    ninja test

    ninja install


    cd /sources/blfs
    rm -Rf $PKG_shared_mime_info #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_shared_mime_info "$TOOL_READY"
fi
###********************************



###PKG_desktop_file_utils: 0.1SBU
if [[ -n "$PKG_desktop_file_utils" ]] ;then
    echo -e "$PKG_desktop_file_utils" " 0.1 SBU"
    echo $PKG_desktop_file_utils
    cd $PKG_desktop_file_utils

    rm -fv /usr/bin/desktop-file-edit

    mkdir build &&
    cd    build &&

    meson setup --prefix=/usr --buildtype=release .. &&
    ninja

    ninja install


    cd /sources/blfs
    rm -Rf $PKG_desktop_file_utils #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_desktop_file_utils "$TOOL_READY"
fi
###********************************