#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_apr_util_"
file_name_compiled="${file_name}_compiled"
path_to_compiled_pkgs="../../../../../../../../compiled_pckages.sh"

## check if already has been compiled
source "$path_to_compiled_pkgs"

if [[ -n "$file_name_compiled" && $file_name_compiled ]]; then
    echo -e "${OK}Already compiled${NO_STYLE}"
    exit 0
fi


# required packages:: (file calls with source)
call_method "PKG_apr_" "./packages/_libs/_general_/PKG_apr_.sh"


# recommended packages::


# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
    call_method "PKG_mariadb_" "./packages/_Servers/_Databases/PKG_mariadb_.sh"
    call_method "PKG_openldap_tgz" "./packages/_Servers/_Other_servers/PKG_openldap_tgz.sh"
    call_method "PKG_postgresql_" "./packages/_Servers/_Databases/PKG_postgresql_.sh"
    call_method "PKG_sqlite_autoconf_" "./packages/_Servers/_Databases/PKG_sqlite_autoconf_.sh"
    call_method "PKG_unixODBC_" "./packages/_libs/_general_uitilities/PKG_unixODBC_.sh"
fi



# main ::
# Use eval to define the function
PKG_apr_util_() {
    # code
     ###PKG_apr_util_: 0.1 SBU
    if [[ -n "$PKG_apr_util_" ]] ;then
        extract_tar_files /sources "$PKG_apr_util_"
        echo -e "$PKG_apr_util_" " 0.1 SBU"
        echo $PKG_apr_util_
        cd $PKG_apr_util_
        next_pkg="$PKG_apr_util_"


       ./configure --prefix=/usr       \
            --with-apr=/usr     \
            --with-gdbm=/usr    \
            --with-openssl=/usr \
            --with-crypto &&
        make
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export error_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        if $DO_OPTIONNAL_TESTS; then
             make -j1 test
        fi

        make install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export error_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        cd /sources/blfs
        rm -Rf $PKG_apr_util_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_apr_util_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


