#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_wv_"
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
   call_method "PKG_libpng_" "./packages/_libs/_graphical_and_font/PKG_libpng_.sh"
   

fi


# optional packages::
#LIBWMF



# main ::
# Use eval to define the function
PKG_wv_() {
    # code

    if [[ -n "$PKG_wv_" ]] ;then
        extract_tar_files /sources "$PKG_wv_"
        echo -e "$PKG_wv_" " 0.4 SBU"
        echo $PKG_wv_
        cd $PKG_wv_
        next_pkg="$PKG_wv_"

        ./configure --prefix=/usr --disable-static &&
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

        cd /sources/BLFS
        rm -r $PKG_wv_
        echo -e "$DONE"
        echo -e $PKG_wv_ "$TOOL_READY"


        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
}


