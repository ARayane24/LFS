#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="xorg_libs"
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
xorg_libs() {
    # code
    ###PKG_Xorg_lib: 0.1SBU
    if [[ -n "$PKG_Xorg_lib" && "$next_pkg" = "$PKG_Xorg_lib" ]] ;then
        echo -e "$PKG_Xorg_lib" " 0.1 SBU"
        echo $PKG_Xorg_lib
        cd $PKG_Xorg_lib

        as_root()
        {
            if   [ $EUID = 0 ];        then $*
            elif [ -x /usr/bin/sudo ]; then sudo $*
            else                            su -c \\"$*\\"
            fi
        }

        export -f as_root


        bash -e "$build_file_path/build_xorg_libs.sh"

        cd /sources/blfs
        #rm -Rf $PKG_Xorg_lib #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_Xorg_lib "$TOOL_READY"
        next_pkg="$PKG_Qt"
        
        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


