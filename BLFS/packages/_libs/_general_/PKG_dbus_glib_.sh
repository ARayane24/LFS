#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_dbus_glib_"
file_name_compiled="${file_name}_compiled"
path_to_compiled_pkgs="../../../../../../../../compiled_pckages.sh"

## check if already has been compiled
source "$path_to_compiled_pkgs"

if [[ -n "$file_name_compiled" && $file_name_compiled ]]; then
    echo -e "${OK}Already compiled${NO_STYLE}"
    exit 0
fi


# required packages:: (file calls with source)
call_method "PKG_dbus_" "./packages/_libs/_system_utilities/PKG_dbus_.sh"
call_method "PKG_glib_" "./packages/_libs/_general_/PKG_glib_.sh"


# recommended packages::

# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
    call_method "PKG_gtk_doc_" "./packages/_libs/_general_uitilities/PKG_gtk_doc_.sh"
fi



# main ::
# Use eval to define the function
PKG_dbus_glib_() {
    # code
     ###PKG_dbus_glib_: 0.1 SBU
    if [[ -n "$PKG_dbus_glib_" ]] ;then
        extract_tar_files /sources "$PKG_dbus_glib_"
        echo -e "$PKG_dbus_glib_" " 0.1 SBU"
        echo $PKG_dbus_glib_
        cd $PKG_dbus_glib_
        next_pkg="$PKG_dbus_glib_"


        ./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static &&
        make
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export error_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        if $DO_OPTIONNAL_TESTS; then
            make check
        fi

        make install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export error_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"


        cd /sources/blfs
        rm -Rf $PKG_dbus_glib_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_dbus_glib_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


