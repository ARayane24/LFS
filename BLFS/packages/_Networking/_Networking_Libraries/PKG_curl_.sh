#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_curl_"
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
PKG_curl_() {
    # code
    ###PKG_curl: 0.2SBU
    if [[ -n "$PKG_curl" && "$next_pkg" = "$PKG_curl" ]] ;then
        extract_tar_files /sources "$PKG_curl"
        echo -e "$PKG_curl" " 0.2 SBU"
        echo $PKG_curl
        cd $PKG_curl

        ./configure --prefix=/usr                           \
                    --disable-static                        \
                    --with-openssl                          \
                    --enable-threaded-resolver              \
                    --with-ca-path=/etc/ssl/certs &&
        make
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export next_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"


        if $DO_OPTIONNAL_TESTS; then
            make test
        fi

        make install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export next_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        rm -rf docs/examples/.deps &&

        find docs \( -name Makefile\* -o  \
                    -name \*.1       -o  \
                    -name \*.3       -o  \
                    -name CMakeLists.txt \) -delete &&

        cp -v -R docs -T /usr/share/doc/$PKG_curl
        
        cd /sources/blfs
        rm -Rf $PKG_curl #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_curl "$TOOL_READY"
        next_pkg="$PKG_CMake"
        
        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


