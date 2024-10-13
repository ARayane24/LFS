#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_glib_"
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
PKG_glib_() {
    # code
    ###PKG_Glib: 0.1SBU
    if [[ -n "$PKG_Glib" && "$next_pkg" = "$PKG_Glib" ]] ;then
        extract_tar_files /sources "$PKG_Glib"
        echo -e "$PKG_Glib" " 0.1 SBU"
        echo $PKG_Glib
        cd $PKG_Glib

        export GLIB_LOG_LEVEL=4
        patch -Np1 -i ../glib-skip_warnings-1.patch

        mkdir build &&
        cd    build &&

        meson setup ..                  \
            --prefix=/usr             \
            --buildtype=release       \
            -D introspection=disabled \
            -D man-pages=enabled      &&
        ninja

        ninja install

        tar xf ../../gobject-introspection-1.80.1.tar.xz &&

        meson setup gobject-introspection-1.80.1 gi-build \
                    --prefix=/usr --buildtype=release     &&
        ninja -C gi-build

        if $DO_OPTIONNAL_TESTS; then
            ninja -C gi-build test
        fi

        ninja -C gi-build install
        meson configure -D introspection=enabled &&
        ninja

        ninja install

        source $build_file_path/run_befor_glib_test.sh

        make NON_ROOT_USERNAME=tester check-root
        groupadd -g 102 dummy -U tester
        chown -R tester . 
        su tester -c "LC_ALL=C ninja test "
        groupdel dummy

        cd /sources/blfs
        rm -Rf $PKG_Glib #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_Glib "$TOOL_READY"
        next_pkg="$PKG_phonon"
   
        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


