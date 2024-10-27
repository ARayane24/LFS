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



# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
   call_method "PKG_gi_docgen_" "./packages/_libs/_programing/_python_modules/PKG_gi_docgen_"
   call_method "PKG_qt_everywhere_src_" "./packages/_Graphical_Components/_Display_Managers/PKG_qt_everywhere_src_.sh"
fi



# main ::
# Use eval to define the function
PKG_AppStream_() {
# code
     ###PKG_AppStream_: 0.5 SBU
    if [[ -n "$PKG_AppStream_" ]] ;then
        extract_tar_files /sources "$PKG_AppStream_"
        echo -e "$PKG_AppStream_" " 0.5 SBU"
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

        install -vdm755 /usr/share/metainfo &&
        cat > /usr/share/metainfo/org.linuxfromscratch.lfs.xml << EOF
        <?xml version="1.0" encoding="UTF-8"?>
        <component type="operating-system">
        <id>org.linuxfromscratch.lfs</id>
        <name>${DISTRO_NAME}</name>
        <summary>A customized Linux system built entirely from source</summary>
        <description>
            <p>
            Linux From Scratch (LFS) is a project that provides you with
            step-by-step instructions for building your own customized Linux
            system entirely from source.
            </p>
        </description>
        <url type="homepage">https://github.com/ARayane24/LFS</url>
        <metadata_license>MIT</metadata_license>
        <developer id='linuxfromscratch.org'>
            <name>The Linux From Scratch Editors</name>
        </developer>

        <releases>
            <release version="12.2" type="release" date="2024-04-01">
            <description>
                <p>Now contains Binutils 2.43.1, GCC-14.2.0, Glibc-2.40,
                and Linux kernel 6.10.</p>
            </description>
            </release>

            <release version="12.1" type="stable" date="2024-03-01">
            <description>
                <p>Now contains Binutils 2.42, GCC-13.2.0, Glibc-2.39,
                and Linux kernel 6.7.</p>
            </description>
            </release>
        </releases>
        </component>
EOF

        cd /sources/blfs
        rm -Rf $PKG_AppStream_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_AppStream_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


