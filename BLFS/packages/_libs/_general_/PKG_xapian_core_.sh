#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_PKG_xapian_core_"
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



# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
   call_method "PKG_valgrind_" "./packages/_libs/_system_utilities/PKG_valgrind_.sh"
   
fi



# main ::
# Use eval to define the function
PKG_xapian_core_() {
    # code
     ###PKG_xapian_core_: 0.5 SBU
    if [[ -n "$PKG_xapian_core_" ]] ;then
        extract_tar_files /sources "$PKG_xapian_core_"
        echo -e "$PKG_xapian_core_" " 0.6 SBU"
        echo $PKG_xapian_core_
        cd $PKG_xapian_core_
        next_pkg="$PKG_xapian_core_"


        ./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xapian-core-1.4.26 &&

        make
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export error_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        if $DO_OPTIONNAL_TESTS then
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
        rm -Rf $PKG_xapian_core_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_xapian_core_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


