#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_aspell_"
file_name_compiled="${file_name}_compiled"
path_to_compiled_pkgs="../../../../../../../../compiled_pckages.sh"

## check if already has been compiled
source "$path_to_compiled_pkgs"

if [[ -n "$file_name_compiled" && $file_name_compiled ]]; then
    echo -e "${OK}Already compiled${NO_STYLE}"
    exit 0
fi


# required packages:: (file calls with source)
call_method "PKG_which_" "./packages/_libs/_system_utilities/PKG_which_.sh"

# recommended packages::


# optional packages::



# main ::
# Use eval to define the function
PKG_aspell_() {
    # code
     ###PKG_aspell_: 0.4 SBU
    if [[ -n "$PKG_aspell_" ]] ;then
        extract_tar_files /sources "$PKG_aspell_"
        echo -e "$PKG_aspell_" " 0.4 SBU"
        echo $PKG_aspell_
        cd $PKG_aspell_
        next_pkg="$PKG_aspell_"


        ./configure --prefix=/usr &&
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

        ln -svfn aspell-0.60 /usr/lib/aspell &&

        install -v -m755 -d /usr/share/doc/aspell-0.60.8.1/aspell{,-dev}.html &&

        install -v -m644 manual/aspell.html/* \
            /usr/share/doc/aspell-0.60.8.1/aspell.html &&

        install -v -m644 manual/aspell-dev.html/* \
            /usr/share/doc/aspell-0.60.8.1/aspell-dev.html


        tar xf ../aspell6-en-2020.12.07-0.tar.bz2 &&
        cd aspell6-en-2020.12.07-0                &&

        install -v -m 755 scripts/ispell /usr/bin/
        install -v -m 755 scripts/spell /usr/bin/

        ./configure &&
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
        rm -Rf $PKG_aspell_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_aspell_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


