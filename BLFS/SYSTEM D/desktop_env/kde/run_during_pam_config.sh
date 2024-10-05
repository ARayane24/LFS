#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing



###PKG_cracklib: 0.1SBU
if [[ -n "$PKG_cracklib" ]] ;then
    echo -e "$PKG_cracklib" " 0.1 SBU"
    echo $PKG_cracklib
    cd $PKG_cracklib

    ./configure --prefix=/usr    \
            --disable-static \
            --with-default-dict=/usr/lib/cracklib/pw_dict &&
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


    install -v -m644 -D    ../cracklib-words-2.10.2.xz \
                         /usr/share/dict/cracklib-words.xz    &&

    unxz -v                  /usr/share/dict/cracklib-words.xz    &&
    ln -v -sf cracklib-words /usr/share/dict/words                &&
    echo $(hostname) >>      /usr/share/dict/cracklib-extra-words &&
    install -v -m755 -d      /usr/lib/cracklib                    &&

    create-cracklib-dict     /usr/share/dict/cracklib-words \
                            /usr/share/dict/cracklib-extra-words

    make NON_ROOT_USERNAME=tester check-root
    groupadd -g 102 dummy -U tester
    chown -R tester . 
    su tester -c "make test"
    groupdel dummy

    cd /sources/blfs
    rm -Rf $PKG_cracklib #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_cracklib "$TOOL_READY"
fi
###********************************



###PKG_libpwquality: 0.1SBU
if [[ -n "$PKG_libpwquality" ]] ;then
    echo -e "$PKG_libpwquality" " 0.1 SBU"
    echo $PKG_libpwquality
    cd $PKG_libpwquality

    ./configure --prefix=/usr                      \
            --disable-static                   \
            --with-securedir=/usr/lib/security \
            --disable-python-bindings          &&
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        echo "export next_pkg=$next_pkg" >> /.bashrc
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD/python

    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        echo "export next_pkg=$next_pkg" >> /.bashrc
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    pip3 install --no-index --find-links=dist --no-cache-dir --no-user pwquality


    mv /etc/pam.d/system-password{,.orig} &&
    cat > /etc/pam.d/system-password << "EOF"
    # Begin /etc/pam.d/system-password

    # check new passwords for strength (man pam_pwquality)
    password  required    pam_pwquality.so   authtok_type=UNIX retry=1 difok=1 \
                                            minlen=8 dcredit=0 ucredit=0 \
                                            lcredit=0 ocredit=0 minclass=1 \
                                            maxrepeat=0 maxsequence=0 \
                                            maxclassrepeat=0 gecoscheck=0 \
                                            dictcheck=1 usercheck=1 \
                                            enforcing=1 badwords="" \
                                            dictpath=/usr/lib/cracklib/pw_dict

    # use yescrypt hash for encryption, use shadow, and try to use any
    # previously defined authentication token (chosen password) set by any
    # prior module.
    password  required    pam_unix.so        yescrypt shadow try_first_pass

    # End /etc/pam.d/system-password
EOF


    cd /sources/blfs
    rm -Rf $PKG_libpwquality #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_libpwquality "$TOOL_READY"
fi
###********************************