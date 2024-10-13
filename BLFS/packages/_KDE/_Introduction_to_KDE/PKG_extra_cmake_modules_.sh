#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_extra_cmake_modules_"
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
PKG_extra_cmake_modules_() {
    # code
    ###PKG_Extra_cmake: 3SBU
    if [[ -n "$PKG_Extra_cmake" && "$next_pkg" = "$PKG_Extra_cmake" ]] ;then
        extract_tar_files /sources "$PKG_Extra_cmake"
        echo -e "$PKG_Extra_cmake" " 3 SBU"
        echo $PKG_Extra_cmake
        cd $PKG_Extra_cmake

        sed -i '/"lib64"/s/64//' kde-modules/KDEInstallDirsCommon.cmake &&

        sed -e '/PACKAGE_INIT/i set(SAVE_PACKAGE_PREFIX_DIR "${PACKAGE_PREFIX_DIR}")' \
            -e '/^include/a set(PACKAGE_PREFIX_DIR "${SAVE_PACKAGE_PREFIX_DIR}")' \
            -i ECMConfig.cmake.in &&

        mkdir build &&
        cd    build &&

        cmake -D CMAKE_INSTALL_PREFIX=/usr .. &&
        make
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export next_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        make install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export next_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"
        
        cd /sources/blfs
        rm -Rf $PKG_Extra_cmake #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_Extra_cmake "$TOOL_READY"
        next_pkg="$PKG_xcb_proto"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


