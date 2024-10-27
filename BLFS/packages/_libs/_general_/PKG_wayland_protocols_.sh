#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_wayland_protocols_"
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

call_method "PKG_wayland_" "./packages/_libs/_general_/PKG_wayland_.sh"


# recommended packages::



# optional packages::




# main ::
# Use eval to define the function
PKG_wayland_protocols_() {
    # code
     ###PKG_wayland_protocols: 0.1 SBU
    if [[ -n "$PKG_wayland_protocols" ]] ;then
        extract_tar_files /sources "$PKG_wayland_protocols"
        echo -e "$PKG_wayland_protocols" " 0.1 SBU"
        echo $PKG_wayland_protocols
        cd $PKG_wayland_protocols
        next_pkg="$PKG_wayland_protocols"


        mkdir build &&
        cd    build &&
        meson setup --prefix=/usr --buildtype=release &&
        ninja

        if $DO_OPTIONNAL_TESTS then
            ninja test
        fi

        ninja install

        cd /sources/blfs
        rm -Rf $PKG_wayland_protocols #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_wayland_protocols "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


