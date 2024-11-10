#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_brotli_"
file_name_compiled="${file_name}_compiled"
path_to_compiled_pkgs="../../../../../../../../compiled_pckages.sh"

## check if already has been compiled
source "$path_to_compiled_pkgs"

if [[ -n "$file_name_compiled" && $file_name_compiled ]]; then
    echo -e "${OK}Already compiled${NO_STYLE}"
    exit 0
fi


# required packages:: (file calls with source)
call_method "PKG_cmake_" "./packages/_libs/_system_utilities/PKG_cmake_.sh"


# recommended packages::


# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
    call_method "PKG_pytest_" "./packages/_libs/_programing/_python_modules/PKG_pytest_.sh"
fi



# main ::
# Use eval to define the function
PKG_brotli_() {
    # code
     ###PKG_brotli_: 0.3 SBU
    if [[ -n "$PKG_brotli_" ]] ;then
        extract_tar_files /sources "$PKG_brotli_"
        echo -e "$PKG_brotli_" " 0.3 SBU"
        echo $PKG_brotli_
        cd $PKG_brotli_
        next_pkg="$PKG_brotli_"


        mkdir build &&
        cd    build &&

        cmake -D CMAKE_INSTALL_PREFIX=/usr \
            -D CMAKE_BUILD_TYPE=Release  \
            ..  &&
        make
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export error_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        if $DO_OPTIONNAL_TESTS; then
             make test
        fi

        make install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export error_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"


        cd .. &&
        sed "/c\/.*\.[ch]'/d;\
            /include_dirs=\[/\
            i libraries=['brotlicommon','brotlidec','brotlienc']," \
            -i setup.py &&
        pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD


        pip3 install --no-index --find-links=dist --no-cache-dir --no-user Brotli


        cd /sources/blfs
        rm -Rf $PKG_brotli_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_brotli_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


