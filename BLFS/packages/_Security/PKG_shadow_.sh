#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_shadow_"
file_name_compiled="${file_name}_compiled"
path_to_compiled_pkgs="../../../../../../../compiled_pckages.sh"

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
PKG_shadow_() {
    # code
    ###PKG_shadow: 0.1SBU
    if [[ -n "$PKG_shadow" ]] ;then
        extract_tar_files /sources "$PKG_shadow"
        echo -e "$PKG_shadow" " 0.1 SBU"
        echo $PKG_shadow
        cd $PKG_shadow

        sed -i 's/groups$(EXEEXT) //' src/Makefile.in          &&

        find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \; &&
        find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \; &&
        find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \; &&

        sed -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD YESCRYPT@' \
            -e 's@/var/spool/mail@/var/mail@'                   \
            -e '/PATH=/{s@/sbin:@@;s@/bin:@@}'                  \
            -i etc/login.defs                                   &&

        ./configure --sysconfdir=/etc   \
                    --disable-static    \
                    --without-libbsd    \
                    --with-{b,yes}crypt &&
        make
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        make exec_prefix=/usr pamddir= install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        make -C man install-man
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        cd "/sources/blfs"
        rm -Rf $PKG_shadow #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_shadow "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


