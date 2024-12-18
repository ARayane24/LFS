#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_libxml_"
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
    call_method "PKG_icuc_srctgz" "./packages/_libs/_general_/PKG_icuc_srctgz.sh"
fi


# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
    call_method "PKG_valgrind_" "./packages/_libs/_system_utilities/PKG_valgrind_.sh"
fi



# main ::
# Use eval to define the function
PKG_libxml_() {
    # code
    ###PKG_libxml: 0.4SBU
    if [[ -n "$PKG_libxml" ]] ;then
        extract_tar_files /sources "$PKG_libxml"
        echo -e "$PKG_libxml" " 0.4 SBU"
        echo $PKG_libxml
        cd $PKG_libxml
    
        patch -Np1 -i ../$PKG_libxml-upstream_fix-2.patch

        ./configure --prefix=/usr           \
                --sysconfdir=/etc       \
                --disable-static        \
                --with-history          \
                --with-icu              \
                PYTHON=/usr/bin/python3 \
                --docdir=/usr/share/doc/$PKG_libxml &&
        make
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export next_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        if $DO_OPTIONNAL_TESTS; then
            tar xf ../xmlts20130923.tar.gz
            make check-valgrind > check.log
            grep -E '^Total|expected|Ran' check.log
        fi

        make install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export next_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        rm -vf /usr/lib/libxml2.la && sed '/libs=/s/xml2.*/xml2"/' -i /usr/bin/xml2-config

        cd /sources/blfs
        rm -Rf $PKG_libxml #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_libxml "$TOOL_READY"
        next_pkg="$PKG_nghttp2"
    
        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


