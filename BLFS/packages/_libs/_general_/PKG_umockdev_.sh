#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_umockdev_"
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

call_method "PKG_libgudev_" "./packages/_libs/_general_/PKG_libgudev_.sh"
call_method "PKG_libpcap_" "./packages/_libs/_Networking/_Networking_Libraries/PKG_libpcap_.sh"
call_method "PKG_vala_" "./packages/_libs/_system_utilities/PKG_vala_.sh"


# recommended packages::


# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
   
   call_method "PKG_gtk_doc_" "./packages/_libs/_general_uitilities/PKG_gtk_doc_.sh"
   #Need libgphoto2 for tests
   

fi



# main ::
# Use eval to define the function
PKG_umockdev_() {
    # code
     ###PKG_wayland_: 0.1 SBU
    if [[ -n "$PKG_wayland_" ]] ;then
        extract_tar_files /sources "$PKG_wayland_"
        echo -e "$PKG_wayland_" " 0.1 SBU"
        echo $PKG_wayland_
        cd $PKG_wayland_
        next_pkg="$PKG_wayland_"

        mkdir build &&
        cd    build &&

        meson setup --prefix=/usr --buildtype=release .. &&
        ninja

        if $DO_OPTIONNAL_TESTS then
            ninja test
        fi

        ninja install

        cd /sources/blfs
        rm -Rf $PKG_wayland_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_wayland_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


