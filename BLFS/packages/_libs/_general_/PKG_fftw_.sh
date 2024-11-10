#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_fftw_"
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


# optional packages::




# main ::
# Use eval to define the function
PKG_fftw_() {
    # code
     ###PKG_fftw_: 1.6 SBU
    if [[ -n "$PKG_fftw_" ]] ;then
        extract_tar_files /sources "$PKG_fftw_"
        echo -e "$PKG_fftw_" " 1.6 SBU"
        echo $PKG_fftw_
        cd $PKG_fftw_
        next_pkg="$PKG_fftw_"


       ./configure --prefix=/usr    \
            --enable-shared  \
            --disable-static \
            --enable-threads \
            --enable-sse2    \
            --enable-avx     \
            --enable-avx2    &&
        make
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export error_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        if $DO_OPTIONNAL_TESTS; then
             make check
        fi

        make install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export error_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        make clean &&

        ./configure --prefix=/usr    \
                    --enable-shared  \
                    --disable-static \
                    --enable-threads \
                    --enable-sse2    \
                    --enable-avx     \
                    --enable-avx2    \
                    --enable-float   &&
        make
         if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export error_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi

        make install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export error_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi

        make clean &&

        ./configure --prefix=/usr    \
                    --enable-shared  \
                    --disable-static \
                    --enable-threads \
                    --enable-long-double &&
        make
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export error_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi

        make install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export error_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi

        cd /sources/blfs
        rm -Rf $PKG_fftw_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_fftw_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


