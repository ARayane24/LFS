#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="$PKG_valgrind_"
file_name_compiled="${file_name}_compiled"
path_to_compiled_pkgs="../../compiled_pckages.sh"

## check if already has been compiled
source "$path_to_compiled_pkgs"

if [[ -n "$file_name_compiled" && $file_name_compiled ]]; then
    echo -e "${OK}Already compiled${NO_STYLE}"
    exit 0
fi


# optional packages::
if [[ -n "$optional_packages" && $optional_packages || $DO_OPTIONNAL_TESTS ]]; then
   call_method "$PKG_which_" "BLFS/Packages/libs/system_utils/$PKG_which_.sh"
   

fi



# main ::
# Use eval to define the function
eval "$file_name() {
    # code

    sed -i 's|/doc/valgrind||' docs/Makefile.in &&

    ./configure --prefix=/usr \
                --datadir=/usr/share/doc/$file_name &&
    make

    if $DO_OPTIONNAL_TESTS ; then
        make regtest
    fi

    sed -e 's@prereq:.*@prereq: false@' \
    -i {helgrind,drd}/tests/pth_cond_destroy_busy.vgtest

    make install

    # end
    echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
}"


