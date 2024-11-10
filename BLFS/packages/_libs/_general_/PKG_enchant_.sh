#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_enchant_"
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
call_method "PKG_glib_" "./packages/_libs/_general_/PKG_glib_.sh"

# recommended packages::
if [[ -n "$recommended_packages" && $recommended_packages ]]; then
    call_method "PKG_aspell_" "./packages/_libs/_general_/PKG_aspell_.sh"
fi


# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
    call_method "PKG_dbus_glib_" "./packages/_libs/_general_/PKG_dbus_glib_.sh"
    call_method "PKG_doxygen_src" "./packages/_libs/_system_utilities/PKG_doxygen_src.sh"
fi



# main ::
# Use eval to define the function
PKG_enchant_() {
    # code
     ###PKG_enchant_: 0.1 SBU
    if [[ -n "$PKG_enchant_" ]] ;then
        extract_tar_files /sources "$PKG_enchant_"
        echo -e "$PKG_enchant_" " 0.1 SBU"
        echo $PKG_enchant_
        cd $PKG_enchant_
        next_pkg="$PKG_enchant_"


        ./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/$PKG_enchant_ &&
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
        rm -Rf $PKG_enchant_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_enchant_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


