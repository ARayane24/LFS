#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_appstream_glib_"
file_name_compiled="${file_name}_compiled"
path_to_compiled_pkgs="../../../../../../../../compiled_pckages.sh"

## check if already has been compiled
source "$path_to_compiled_pkgs"

if [[ -n "$file_name_compiled" && $file_name_compiled ]]; then
    echo -e "${OK}Already compiled${NO_STYLE}"
    exit 0
fi


# required packages:: (file calls with source)
call_method "PKG_curl_" "./packages/_Networking/_Networking_Libraries/PKG_curl_.sh"
call_method "PKG_gdk_pixbuf_" "./packages/_Graphical_Components/_Display_Managers/PKG_gdk_pixbuf_.sh"
call_method "PKG_libarchive_" "./packages/_libs/_general_/PKG_libarchive_.sh"

# recommended packages::



# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
    call_method "PKG_docbook_xml_zip" "./packages/_Printing,_Scanning_and_Typesetting/_Extensible_Markup_Language_(XML)/PKG_docbook_xml_zip.sh"
    call_method "PKG_docbook_xsl_nons_" "./packages/_Printing,_Scanning_and_Typesetting/_Extensible_Markup_Language_(XML)/PKG_docbook_xsl_nons_.sh"
    call_method "PKG_gtk_doc_" "./packages/_libs/_general_uitilities/PKG_gtk_doc_.sh"
    call_method "PKG_libxslt_" "./packages/_libs/_general_/PKG_libxslt_.sh"
    call_method "PKG_libyaml_" "./packages/_libs/_general_/PKG_libyaml_.sh"
fi



# main ::
# Use eval to define the function
PKG_appstream_glib_() {
# code
     ###PKG_Vulkan_Loader_: 0.1 SBU
    if [[ -n "$PKG_Vulkan_Loader_" ]] ;then
        extract_tar_files /sources "$PKG_Vulkan_Loader_"
        echo -e "$PKG_Vulkan_Loader_" " 0.1 SBU"
        echo $PKG_Vulkan_Loader_
        cd $PKG_Vulkan_Loader_
        next_pkg="$PKG_Vulkan_Loader_"


        mkdir build &&
        cd    build &&

        meson setup ..            \
            --prefix=/usr       \
            --buildtype=release \
            -D rpm=false        &&
        ninja
        echo -e "$BUILD_SUCCEEDED"

        if $DO_OPTIONNAL_TESTS; then
            ninja test
        fi

        ninja install
        echo -e "$BUILD_SUCCEEDED"
        rm -v -rf /usr/share/installed-tests

        cd /sources/blfs
        rm -Rf $PKG_Vulkan_Loader_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_Vulkan_Loader_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


