#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_AppStream_"
file_name_compiled="${file_name}_compiled"
path_to_compiled_pkgs="../../../../../../../../compiled_pckages.sh"

## check if already has been compiled
source "$path_to_compiled_pkgs"

if [[ -n "$file_name_compiled" && $file_name_compiled ]]; then
    echo -e "${OK}Already compiled${NO_STYLE}"
    exit 0
fi


# required packages:: (file calls with source)
call_method "PKG_curl_"     "./packages/_Networking/_Networking_Libraries/PKG_curl_.sh"
call_method "PKG_itstool_"  "./packages/_Printing,_Scanning_and_Typesetting/_Extensible_Markup_Language_(XML)/PKG_itstool_.sh"
call_method "PKG_libxml_"   "./packages/_libs/_general_/PKG_libxml_.sh"
call_method "PKG_libxmlb_"  "./packages/_libs/_general_/PKG_libxmlb_.sh"
call_method "PKG_libyaml_"     "./packages/_libs/_general_/PKG_libyaml_.sh"


# recommended packages::
if [[ -n "$recommended_packages" && $recommended_packages ]]; then
   
   

fi


# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
   
   

fi



# main ::
# Use eval to define the function
PKG_AppStream_() {
# code
     ###PKG_AppStream_: 0.2 SBU
    if [[ -n "$PKG_AppStream_" ]] ;then
        extract_tar_files /sources "$PKG_AppStream_"
        echo -e "$PKG_AppStream_" " 0.2 SBU"
        echo $PKG_AppStream_
        cd $PKG_AppStream_
        next_pkg="$PKG_AppStream_"


        mkdir build &&
        cd    build &&

        meson setup --prefix=/usr       \
                    --buildtype=release \
                    -D apidocs=false    \
                    -D stemming=false   .. &&
        ninja
        echo -e "$BUILD_SUCCEEDED"

        if $DO_OPTIONNAL_TESTS; then
            ninja test
        fi

        ninja install
        echo -e "$BUILD_SUCCEEDED"
        mv -v /usr/share/doc/appstream{,-1.0.3}

        cd /sources/blfs
        rm -Rf $PKG_AppStream_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_AppStream_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


