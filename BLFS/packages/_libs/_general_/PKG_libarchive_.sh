#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_libarchive_"
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
    call_method "PKG_libxml_" "./packages/_libs/_general_/PKG_libxml_.sh"
fi


# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
    call_method "PKG_lzo_" "./packages/_libs/_general_/PKG_lzo_.sh"
    call_method "PKG_nettle_" "./packages/_Security/PKG_nettle_.sh"
    call_method "PKG_pcre_" "./packages/_libs/_general_/PKG_pcre_.sh"
fi



# main ::
# Use eval to define the function
PKG_libarchive_() {
    # code
    ###PKG_libarchive: 0.4SBU
    if [[ -n "$PKG_libarchive" && "$next_pkg" = "$PKG_libarchive" ]] ;then
        extract_tar_files /sources "$PKG_libarchive"
        echo -e "$PKG_libarchive" " 0.4 SBU"
        echo $PKG_libarchive
        cd $PKG_libarchive

        ./configure --prefix=/usr --disable-static --without-expat &&
        make
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export next_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        if $DO_OPTIONNAL_TESTS; then
            LC_ALL=C.UTF-8 make check
        fi

        make install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export next_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        
        cd /sources/blfs
        rm -Rf $PKG_libarchive #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_libarchive "$TOOL_READY"
        next_pkg="$PKG_libunistring"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


