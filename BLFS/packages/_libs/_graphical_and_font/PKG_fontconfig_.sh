#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_fontconfig_"
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
PKG_fontconfig_() {
    # code
    ###PKG_Fontconfig: 0.1SBU
    if [[ -n "$PKG_Fontconfig" && "$next_pkg" = "$PKG_Fontconfig" ]] ;then
        extract_tar_files /sources "$PKG_Fontconfig"
        echo -e "$PKG_Fontconfig" " 0.1 SBU"
        echo $PKG_Fontconfig
        cd $PKG_Fontconfig

        ./configure --prefix=/usr        \
                --sysconfdir=/etc    \
                --localstatedir=/var \
                --disable-docs       \
                --docdir=/usr/share/doc/$PKG_Fontconfig &&
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

        install -v -dm755 \
            /usr/share/{man/man{1,3,5},doc/$PKG_Fontconfig/fontconfig-devel} &&
        install -v -m644 fc-*/*.1         /usr/share/man/man1 &&
        install -v -m644 doc/*.3          /usr/share/man/man3 &&
        install -v -m644 doc/fonts-conf.5 /usr/share/man/man5 &&
        install -v -m644 doc/fontconfig-devel/* \
                                        /usr/share/doc/$PKG_Fontconfig/fontconfig-devel &&
        install -v -m644 doc/*.{pdf,sgml,txt,html} \
                                        /usr/share/doc/$PKG_Fontconfig

        cd /sources/blfs
        rm -Rf $PKG_Fontconfig #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_Fontconfig "$TOOL_READY"
        next_pkg="$PKG_Xorg_lib"


        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


