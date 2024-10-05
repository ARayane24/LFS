#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing



###PKG_shadow: 0.1SBU
if [[ -n "$PKG_shadow" ]] ;then
    echo -e "$PKG_shadow" " 0.1 SBU"
    echo $PKG_shadow
    cd $PKG_shadow

    sed -i 's/groups$(EXEEXT) //' src/Makefile.in          &&

    find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \; &&
    find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \; &&
    find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \; &&

    sed -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD YESCRYPT@' \
        -e 's@/var/spool/mail@/var/mail@'                   \
        -e '/PATH=/{s@/sbin:@@;s@/bin:@@}'                  \
        -i etc/login.defs                                   &&

    ./configure --sysconfdir=/etc   \
                --disable-static    \
                --without-libbsd    \
                --with-{b,yes}crypt &&
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    make exec_prefix=/usr pamddir= install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    make -C man install-man
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd "/sources/blfs"
    rm -Rf $PKG_shadow #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_shadow "$TOOL_READY"
fi
###********************************



###PKG_Systemd: 0.1SBU
if [[ -n "$PKG_Systemd" ]] ;then
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
fi
###********************************