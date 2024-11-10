#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_exempi_"
file_name_compiled="${file_name}_compiled"
path_to_compiled_pkgs="../../../../../../../../compiled_pckages.sh"

## check if already has been compiled
source "$path_to_compiled_pkgs"

if [[ -n "$file_name_compiled" && $file_name_compiled ]]; then
    echo -e "${OK}Already compiled${NO_STYLE}"
    exit 0
fi


# required packages:: (file calls with source)
call_method "PKG_boost__b_nodocs" "./packages/_libs/_general_/PKG_boost__b_nodocs.sh"


# recommended packages::


# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
    call_method "PKG_valgrind_" "./packages/_libs/_system_utilities/PKG_valgrind_.sh"
fi



# main ::
# Use eval to define the function
PKG_exempi_() {
       # code
     ###PKG_exempi_: 0.4 SBU
    if [[ -n "$PKG_exempi_" ]] ;then
        extract_tar_files /sources "$PKG_exempi_"
        echo -e "$PKG_exempi_" " 0.4 SBU"
        echo $PKG_exempi_
        cd $PKG_exempi_
        next_pkg="$PKG_exempi_"

        sed -i -r '/^\s?testadobesdk/d' exempi/Makefile.am &&
        autoreconf -fiv

        ./configure --prefix=/usr --disable-static &&
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
        rm -Rf $PKG_exempi_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_exempi_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


