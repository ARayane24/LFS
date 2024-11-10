#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_boost__b_nodocs"
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
    call_method "PKG_which_" "./packages/_libs/_system_utilities/PKG_which_.sh"
fi


# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
    call_method "PKG_icuc_srctgz" "./packages/_libs/_general_/PKG_icuc_srctgz.sh"
    call_method "PKG_numpy_" "./packages/_libs/_programing/_python_modules/PKG_numpy_.sh"
fi



# main ::
# Use eval to define the function
PKG_boost__b_nodocs() {
    # code
     ###PKG_apr_util_: 1.8 SBU
    if [[ -n "$PKG_apr_util_" ]] ;then
        extract_tar_files /sources "$PKG_apr_util_"
        echo -e "$PKG_apr_util_" " 1.8 SBU"
        echo $PKG_apr_util_
        cd $PKG_apr_util_
        next_pkg="$PKG_apr_util_"

        patch -Np1 -i ../boost-1.86.0-upstream_fixes-1.patch
        case $(uname -m) in
            i?86)
                sed -e "s/defined(__MINGW32__)/& || defined(__i386__)/" \
                    -i ./libs/stacktrace/src/exception_headers.h ;;
        esac

        ./bootstrap.sh --prefix=/usr --with-python=python3 &&
        ./b2 stage -j<N> threading=multi link=shared

        if $DO_OPTIONNAL_TESTS; then
            pushd status; ../b2; popd
        fi

        rm -rf /usr/lib/cmake/[Bb]oost*
        ./b2 install threading=multi link=shared


        cd /sources/blfs
        rm -Rf $PKG_apr_util_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_apr_util_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


