#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing




###PKG_Linux_PAM: 0.1SBU
if [[ -n "$PKG_Linux_PAM" && "$next_pkg" = "$PKG_Linux_PAM" ]] ;then
    echo -e "$PKG_Linux_PAM" " 0.1 SBU"
    echo $PKG_Linux_PAM
    cd $PKG_Linux_PAM

    pushd /sources/$Linux_Kernel
        make mrproper
        make defconfig
        make menuconfig
        make
        make modules_install
    popd
    

    autoreconf -fi
    tar -xf ../Linux-PAM-1.6.1-docs.tar.xz --strip-components=1

    ./configure --prefix=/usr                        \
            --sbindir=/usr/sbin                  \
            --sysconfdir=/etc                    \
            --libdir=/usr/lib                    \
            --enable-securedir=/usr/lib/security \
            --docdir=/usr/share/doc/Linux-PAM-1.6.1 &&
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        echo "export next_pkg=$next_pkg" >> /.bashrc
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"


    install -v -m755 -d /etc/pam.d &&

    cat > /etc/pam.d/other << "EOF"
    auth     required       pam_deny.so
    account  required       pam_deny.so
    password required       pam_deny.so
    session  required       pam_deny.so
EOF

    if $DO_OPTIONNAL_TESTS; then
        # Define the path to the log file
        log_file="test_results.log"

        # Run the tests and redirect output to the log file
        make check > "$log_file" 2>&1

        # Check the exit status of the make check command
        if [ $? -ne 0 ]; then
            echo "Tests completed with errors. Check the log file: $log_file"
        else
            echo -e "$log_file $DONE"
        fi
    fi

    rm -fv /etc/pam.d/other

    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        echo "export next_pkg=$next_pkg" >> /.bashrc
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    chmod -v 4755 /usr/sbin/unix_chkpwd


    install -vdm755 /etc/pam.d &&
    cat > /etc/pam.d/system-account << "EOF" &&
    # Begin /etc/pam.d/system-account

    account   required    pam_unix.so

    # End /etc/pam.d/system-account
EOF

    cat > /etc/pam.d/system-auth << "EOF" &&
    # Begin /etc/pam.d/system-auth

    auth      required    pam_unix.so

    # End /etc/pam.d/system-auth
EOF

    cat > /etc/pam.d/system-session << "EOF" &&
    # Begin /etc/pam.d/system-session

    session   required    pam_unix.so

    # End /etc/pam.d/system-session
EOF

    cat > /etc/pam.d/system-password << "EOF"
    # Begin /etc/pam.d/system-password

    # use yescrypt hash for encryption, use shadow, and try to use any
    # previously defined authentication token (chosen password) set by any
    # prior module.
    password  required    pam_unix.so       yescrypt shadow try_first_pass

    # End /etc/pam.d/system-password
EOF

    source $build_file_path/run_during_pam_config.sh

    cat > /etc/pam.d/other << "EOF"
    # Begin /etc/pam.d/other

    auth        required        pam_warn.so
    auth        required        pam_deny.so
    account     required        pam_warn.so
    account     required        pam_deny.so
    password    required        pam_warn.so
    password    required        pam_deny.so
    session     required        pam_warn.so
    session     required        pam_deny.so

    # End /etc/pam.d/other
EOF

    source $build_file_path/run_after_pam_config.sh

    cd /sources/blfs
    rm -Rf $PKG_Linux_PAM #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_Linux_PAM "$TOOL_READY"
    next_pkg="$PKG_polkit"
fi
###********************************




###PKG_polkit: 0.1SBU
if [[ -n "$PKG_polkit" && "$next_pkg" = "$PKG_polkit" ]] ;then
    echo -e "$PKG_polkit" " 0.1 SBU"
    echo $PKG_polkit
    cd $PKG_polkit

    mkdir build &&
    cd    build &&

    cmake -D CMAKE_INSTALL_PREFIX=/usr \
        -D CMAKE_BUILD_TYPE=Release  \
        -D PHONON_BUILD_QT5=OFF      \
        .. &&
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        echo "export next_pkg=$next_pkg" >> /.bashrc
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        echo "export next_pkg=$next_pkg" >> /.bashrc
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources/blfs
    rm -Rf $PKG_polkit #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_polkit "$TOOL_READY"
    next_pkg="$"
fi
###********************************