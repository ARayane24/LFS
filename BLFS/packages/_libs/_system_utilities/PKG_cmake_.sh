#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_cmake_"
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
PKG_cmake_() {
    # code
    ###PKG_CMake: 3SBU
    if [[ -n "$PKG_CMake" && "$next_pkg" = "$PKG_CMake" ]] ;then
        extract_tar_files /sources "$PKG_CMake"
        echo -e "$PKG_CMake" " 3 SBU"
        echo $PKG_CMake
        cd $PKG_CMake

        sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake &&

        ./bootstrap --prefix=/usr        \
                    --system-libs        \
                    --mandir=/share/man  \
                    --no-system-jsoncpp  \
                    --no-system-cppdap   \
                    --no-system-librhash \
                    --docdir=/share/doc/$PKG_CMake &&
        make
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export next_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"


        if $DO_OPTIONNAL_TESTS; then
            LC_ALL=en_US.UTF-8 bin/ctest -j$(nproc) -O cmake-3.30.2-test.log
        fi

        make install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export next_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"
        
        cd /sources/blfs
        rm -Rf $PKG_curl #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_CMake "$TOOL_READY"
        next_pkg="$PKG_Extra_cmake"
    
        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


