#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_libunistring_"
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
PKG_libunistring_() {
    # code
    ###PKG_libunistring: 0.5SBU
    if [[ -n "$PKG_libunistring" && "$next_pkg" = "$PKG_libunistring" ]] ;then
        extract_tar_files /sources "$PKG_libunistring"
        echo -e "$PKG_libunistring" " 0.5 SBU"
        echo $PKG_libunistring
        cd $PKG_libunistring

        ./configure --prefix=/usr    \
                --disable-static \
                --docdir=/usr/share/doc/$PKG_libunistring &&
        make
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export next_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        if $DO_OPTIONNAL_TESTS; then
            make check
        fi

        make install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export next_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        
        cd /sources/blfs
        rm -Rf $PKG_libunistring #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_libunistring "$TOOL_READY"
        next_pkg="$PKG_libidn2"
        
        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


