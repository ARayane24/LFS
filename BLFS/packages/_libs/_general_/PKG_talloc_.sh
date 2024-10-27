#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_talloc_"
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



# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then

call_method "PKG_docbook_xml_zip" "./packages/_Printing%2C_Scanning_and_Typesetting/_Extensible_Markup_Language_%28XML%29/PKG_docbook_xml_zip.sh"
call_method "PKG_docbook_xsl_nons" "./packages/_Printing%2C_Scanning_and_Typesetting/_Extensible_Markup_Language_%28XML%29/PKG_docbook_xsl_nons.sh"
call_method "PKG_libxslt" "./packages/_libs/_general_/PKG_libxslt.sh"
call_method "PKG_gdb_" "./packages/_libs/_system_utilities/PKG_gdb_.sh"
call_method "PKG_git" "./packages/_system_utilities/PKG_git.sh"
call_method "PKG_libnsl_" "./packages/_Networking/_Networking_Libraries/PKG_libnsl_.sh"   
call_method "PKG_libtirpc_" "./packages/_Networking/_Networking_Libraries/PKG_libtirpc_.sh"
call_method "PKG_valgrind_" "./packages/_libs/_system_utilities/PKG_valgrind_.sh"
call_method "PKG_xfsprogs_" "./packages/_File_Systems_and_Disk_Management/PKG_xfsprogs_.sh"

fi



# main ::
# Use eval to define the function
PKG_talloc_() {
    # code
     ###PKG_talloc_: 0.4 SBU
    if [[ -n "$PKG_talloc_" ]] ;then
        extract_tar_files /sources "$PKG_talloc_"
        echo -e "$PKG_talloc_" " 0.4 SBU"
        echo $PKG_talloc_
        cd $PKG_talloc_
        next_pkg="$PKG_talloc_"

        ./configure --prefix=/usr &&
        make

        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export error_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        if $DO_OPTIONNAL_TESTS then
            make check
        fi

        make install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export error_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        cd /sources/blfs
        rm -Rf $PKG_talloc_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_talloc_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


