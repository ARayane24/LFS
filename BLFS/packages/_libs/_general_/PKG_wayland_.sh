#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_wayland_"
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

call_method "PKG_libxml_" "./packages/_libs/_general_/PKG_libxml_.sh"


# recommended packages::


# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then

call_method "PKG_doxygen_src" "./packages/_libs/_system_utilities/PKG_doxygen_src.sh"
call_method "PKG_graphviz" "./packages/_libs/_general_utilities/PKG_graphviz.sh"
#call_method "PKG_xmlto_.sh" "./packages/_Multimedia/_Printing%2C_Scanning_and_Typesetting/_Extensible_Markup_Language_%28XML%29/PKG_xmlto_.sh"
call_method 
   
   

fi



# main ::
# Use eval to define the function
PKG_wayland_() {
    # code
     ###PKG_wayland_: 0.1 SBU
    if [[ -n "$PKG_wayland_" ]] ;then
        extract_tar_files /sources "$PKG_wayland_"
        echo -e "$PKG_wayland_" " 0.6 SBU"
        echo $PKG_wayland_
        cd $PKG_wayland_
        next_pkg="$PKG_wayland_"


        mkdir build &&
        cd    build &&

        meson setup ..            \
            --prefix=/usr       \
            --buildtype=release \
            -D documentation=false &&
        ninja

        if $DO_OPTIONNAL_TESTS then
            env -u XDG_RUNTIME_DIR ninja test
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


