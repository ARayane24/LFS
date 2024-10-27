#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_abseil_cpp_"
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



# main ::
# Use eval to define the function
PKG_abseil_cpp_() {
    # code
    # code
     ###PKG_abseil_cpp_: 0.9 SBU
    if [[ -n "$PKG_abseil_cpp_" ]] ;then
        extract_tar_files /sources "$PKG_abseil_cpp_"
        echo -e "$PKG_abseil_cpp_" " 0.9 SBU"
        echo $PKG_abseil_cpp_
        cd $PKG_abseil_cpp_
        next_pkg="$PKG_abseil_cpp_"


        mkdir build &&
        cd    build &&

        cmake -D CMAKE_INSTALL_PREFIX=/usr \
            -D CMAKE_BUILD_TYPE=Release  \
            -D ABSL_PROPAGATE_CXX_STD=ON \
            -D BUILD_SHARED_LIBS=ON      \
            -G Ninja ..                  &&
        ninja
        echo -e "$BUILD_SUCCEEDED"

        if $DO_OPTIONNAL_TESTS; then
            ninja test
        fi

        ninja install
        echo -e "$BUILD_SUCCEEDED"

        cd /sources/blfs
        rm -Rf $PKG_abseil_cpp_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_abseil_cpp_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
    # end
    echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
}


