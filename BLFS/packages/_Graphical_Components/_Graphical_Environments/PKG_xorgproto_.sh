#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_xorgproto_"
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
PKG_xorgproto_() {
    # code
    ###PKG_xorg_proto: 0.1SBU
    if [[ -n "$PKG_xorg_proto" && "$next_pkg" = "$PKG_xorg_proto" ]] ;then
        extract_tar_files /sources "$PKG_xorg_proto"
        echo -e "$PKG_xorg_proto" " 0.1 SBU"
        echo $PKG_xorg_proto
        cd $PKG_xorg_proto

        mkdir build &&
        cd    build &&

        meson setup --prefix=$XORG_PREFIX .. &&
        ninja

        ninja install &&
        
        mv -v $XORG_PREFIX/share/doc/xorgproto{,-2024.1}
        
        cd /sources/blfs
        rm -Rf $PKG_xorg_proto #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_xorg_proto "$TOOL_READY"
        next_pkg="$PKG_libxau"
    
        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


