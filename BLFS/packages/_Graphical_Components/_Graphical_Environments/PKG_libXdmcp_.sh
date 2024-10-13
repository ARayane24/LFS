#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_libXdmcp_"
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
PKG_libXdmcp_() {
    # code
    ###PKG_libXdmcp: 0.1SBU
    if [[ -n "$PKG_libXdmcp" && "$next_pkg" = "$PKG_libXdmcp" ]] ;then
        extract_tar_files /sources "$PKG_libXdmcp"
        echo -e "$PKG_libXdmcp" " 0.1 SBU"
        echo $PKG_libXdmcp
        cd $PKG_libXdmcp

        ./configure $XORG_CONFIG --docdir=/usr/share/doc/$PKG_libXdmcp &&
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
        rm -Rf $PKG_libXdmcp #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_libXdmcp "$TOOL_READY"
        next_pkg="$PKG_Fontconfig"


        if ! $IS_UEFI; then
            pushd $build_file_path
                source ../../../../bash_sources/step5_grub_uefi_requirement.sh ## the same required packges
            popd
        fi

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


