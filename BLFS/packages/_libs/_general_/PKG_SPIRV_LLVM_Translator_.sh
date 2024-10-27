#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_SPIRV_LLVM_Translator_"
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

call_method "PKG_libxml_" "./packages/_libs/_general_/PKG_libxml_.sh"
call_method "PKG_llvm_src" "./packages/_libs/_system_utilities/PKG_llvm_src.sh"
call_method "PKG_SPIRV_Tools_" "./packages/_libs/_general_/PKG_SPIRV_Tools_.sh"


# recommended packages::



# optional packages::




# main ::
# Use eval to define the function
PKG_SPIRV_LLVM_Translator_() {
    # code
     ###PKG_SPIRV_LLVM_Translator_: 0.6 SBU
    if [[ -n "$PKG_SPIRV_LLVM_Translator_" ]] ;then
        extract_tar_files /sources "$PKG_SPIRV_LLVM_Translator_"
        echo -e "$PKG_SPIRV_LLVM_Translator_" " 0.6 SBU"
        echo $PKG_SPIRV_LLVM_Translator_
        cd $PKG_SPIRV_LLVM_Translator_
        next_pkg="$PKG_SPIRV_LLVM_Translator_"


        mkdir build &&
        cd    build &&

        cmake -D CMAKE_INSTALL_PREFIX=/usr                   \
            -D CMAKE_BUILD_TYPE=Release                    \
            -D BUILD_SHARED_LIBS=ON                        \
            -D CMAKE_SKIP_INSTALL_RPATH=ON                 \
            -D LLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=/usr \
            -G Ninja ..                                    &&
        ninja

        ninja install

        cd /sources/blfs
        rm -Rf $PKG_SPIRV_LLVM_Translator_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_SPIRV_LLVM_Translator_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


