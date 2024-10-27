#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_SPIRV_Tools_"
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

call_method "PKG_cmake_" "./packages/_libs/_system_utilities/PKG_cmake_.sh"
call_method "PKG_SPIRV_Headers_" "./packages/_libs/_general_/PKG_SPIRV_Headers_.sh"


# recommended packages::



# optional packages::



# main ::
# Use eval to define the function
PKG_SPIRV_Tools_() {
    # code
     ###PKG_SPIRV_Tools_: 1.0 SBU
    if [[ -n "$PKG_SPIRV_Tools_" ]] ;then
        extract_tar_files /sources "$PKG_SPIRV_Tools_"
        $PKG_SPIRV_Tools_ = "SPIRV-Tools-vulkan-sdk-1.3.290.0"
        echo -e "$PKG_SPIRV_Tools_" " 1.0 SBU"
        echo $PKG_SPIRV_Tools_
        cd $PKG_SPIRV_Tools_
        next_pkg="$PKG_SPIRV_Tools_"


        mkdir build &&
        cd    build &&

        cmake -D CMAKE_INSTALL_PREFIX=/usr     \
            -D CMAKE_BUILD_TYPE=Release      \
            -D SPIRV_WERROR=OFF              \
            -D BUILD_SHARED_LIBS=ON          \
            -D SPIRV_TOOLS_BUILD_STATIC=OFF  \
            -D SPIRV-Headers_SOURCE_DIR=/usr \
            -G Ninja .. &&
        ninja

        if $DO_OPTIONNAL_TESTS then
            ninja test
        fi

        ninja install

        cd /sources/blfs
        rm -Rf $PKG_SPIRV_Tools_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_SPIRV_Tools_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


