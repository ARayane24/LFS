#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_systemd_"
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
PKG_systemd_() {
    # code
    ###PKG_Systemd: 0.1SBU
    if [[ -n "$PKG_Systemd" ]] ;then
        extract_tar_files /sources "$PKG_Systemd"
        echo -e "$PKG_Systemd" " 0.1 SBU"
        echo $PKG_Systemd
        cd $PKG_Systemd

        sed -i -e 's/GROUP="render"/GROUP="video"/' \
        -e 's/GROUP="sgx", //' rules.d/50-udev-default.rules.in

        mkdir build &&
        cd    build &&

        meson setup ..                 \
            --prefix=/usr            \
            --buildtype=release      \
            -D default-dnssec=no     \
            -D firstboot=false       \
            -D install-tests=false   \
            -D ldconfig=false        \
            -D man=auto              \
            -D sysusers=false        \
            -D rpmmacrosdir=no       \
            -D homed=disabled        \
            -D userdb=false          \
            -D mode=release          \
            -D pam=enabled           \
            -D pamconfdir=/etc/pam.d \
            -D dev-kvm-mode=0660     \
            -D nobody-group=nogroup  \
            -D sysupdate=disabled    \
            -D ukify=disabled        \
            -D docdir=/usr/share/doc/systemd-256.4 &&

        ninja

        if $DO_OPTIONNAL_TESTS; then
            ninja test
        fi

        ninja install

        cd /sources/blfs
        rm -Rf $PKG_Systemd #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_Systemd "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


