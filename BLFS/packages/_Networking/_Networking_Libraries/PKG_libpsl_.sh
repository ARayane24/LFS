#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_libpsl_"
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
PKG_libpsl_() {
    # code
    ###PKG_libpsl: 0.1SBU
    if [[ -n "$PKG_libpsl" && "$next_pkg" = "$PKG_libpsl" ]] ;then
        extract_tar_files /sources "$PKG_libpsl"
        echo -e "$PKG_libpsl" " 0.1 SBU"
        echo $PKG_libpsl
        cd $PKG_libpsl

        mkdir build &&
        cd    build &&

        meson setup --prefix=/usr --buildtype=release &&

        ninja

        if $DO_OPTIONNAL_TESTS; then
            ninja test
        fi

        ninja install
        
        cd /sources/blfs
        rm -Rf $PKG_libpsl #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_libpsl "$TOOL_READY"
        next_pkg="$PKG_curl"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


