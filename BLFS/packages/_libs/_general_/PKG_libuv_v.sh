#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_libuv_v"
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
PKG_libuv_v() {
    # code
    ###PKG_libuv: 0.1SBU
    if [[ -n "$PKG_libuv" && "$next_pkg" = "$PKG_libuv" ]] ;then
        extract_tar_files /sources "$PKG_libuv"
        echo -e "$PKG_libuv" " 0.1 SBU"
        echo $PKG_libuv
        cd $PKG_libuv

        # Save the current value of ACLOCAL
        ORIGINAL_ACLOCAL="$ACLOCAL"

        # Unset ACLOCAL
        unset ACLOCAL
    
        sh autogen.sh                             
        ./configure --prefix=/usr --disable-static
        make
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export next_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        if $DO_OPTIONNAL_TESTS; then
            make NON_ROOT_USERNAME=tester check-root
            groupadd -g 102 dummy -U tester
            chown -R tester . 
            su tester -c "make check"
            groupdel dummy
        fi

        make install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export next_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        install -Dm644 docs/build/man/libuv.1 /usr/share/man/man1

        export ACLOCAL="$ORIGINAL_ACLOCAL"

        cd /sources/blfs
        rm -Rf $PKG_libuv #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_libuv "$TOOL_READY"
        next_pkg="$PKG_libarchive"
        
        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


