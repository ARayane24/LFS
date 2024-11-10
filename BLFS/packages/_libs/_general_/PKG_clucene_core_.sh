#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_clucene_core_"
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
if [[ -n "$recommended_packages" && $recommended_packages ]]; then
    call_method "PKG_boost__b_nodocs" "./packages/_libs/_general_/PKG_boost__b_nodocs.sh"
fi


# optional packages::




# main ::
# Use eval to define the function
PKG_clucene_core_() {
    # code
     ###PKG_clucene_core_: 0.8 SBU
    if [[ -n "$PKG_clucene_core_" ]] ;then
        extract_tar_files /sources "$PKG_clucene_core_"
        echo -e "$PKG_clucene_core_" " 0.8 SBU"
        echo $PKG_clucene_core_
        cd $PKG_clucene_core_
        next_pkg="$PKG_clucene_core_"


        patch -Np1 -i ../clucene-2.3.3.4-contribs_lib-1.patch &&

        sed -i '/Misc.h/a #include <ctime>' src/core/CLucene/document/DateTools.cpp &&

        mkdir build &&
        cd    build &&

        cmake -D CMAKE_INSTALL_PREFIX=/usr \
            -D BUILD_CONTRIBS_LIB=ON .. &&
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


        cd .. &&
        sed "/c\/.*\.[ch]'/d;\
            /include_dirs=\[/\
            i libraries=['brotlicommon','brotlidec','brotlienc']," \
            -i setup.py &&
        pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD


        pip3 install --no-index --find-links=dist --no-cache-dir --no-user Brotli


        cd /sources/blfs
        rm -Rf $PKG_clucene_core_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_clucene_core_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


