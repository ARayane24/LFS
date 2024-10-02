#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing



bash ./download.sh

###PKG_icu: 0.7SBU
if [ -n "$PKG_icu" ] ;then
    echo -e "$PKG_icu" " 0.7 SBU"
    echo $PKG_icu
    cd $PKG_icu
   
    cd source

    ./configure --prefix=/usr
    
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    make check

    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources/
    rm -Rf $PKG_icu #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_icu "$TOOL_READY"
fi
###********************************



###PKG_Valgrind: 0.5SBU
if [ -n "$PKG_Valgrind" ] ;then
    echo -e "$PKG_Valgrind" " 0.5 SBU"
    echo $PKG_Valgrind
    cd $PKG_Valgrind
   
    sed -i 's|/doc/valgrind||' docs/Makefile.in &&

    ./configure --prefix=/usr \
                --datadir=/usr/share/doc/valgrind-3.23.0 &&
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    rm -vf /usr/lib/libxml2.la && sed '/libs=/s/xml2.*/xml2"/' -i /usr/bin/xml2-config

    cd /sources/
    rm -Rf $PKG_Valgrind #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_Valgrind "$TOOL_READY"
fi
###********************************



###PKG_libxml: 0.4SBU
if [ -n "$PKG_libxml" ] ;then
    echo -e "$PKG_libxml" " 0.4 SBU"
    echo $PKG_libxml
    cd $PKG_libxml
   
    cd source

    patch -Np1 -i ../libxml2-2.13.3-upstream_fix-2.patch


    ./configure --prefix=/usr           \
            --sysconfdir=/etc       \
            --disable-static        \
            --with-history          \
            --with-icu              \
            PYTHON=/usr/bin/python3 \
            --docdir=/usr/share/doc/libxml2-2.13.3 &&
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    if $DO_OPTIONNAL_TESTS; then
        tar xf ../xmlts20130923.tar.gz
        make check-valgrind > check.log
        grep -E '^Total|expected|Ran' check.log
    fi

    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    rm -vf /usr/lib/libxml2.la && sed '/libs=/s/xml2.*/xml2"/' -i /usr/bin/xml2-config

    cd /sources/
    rm -Rf $PKG_libxml #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_libxml "$TOOL_READY"
fi
###********************************



###PKG_nghttp2: 0.4SBU
if [ -n "$PKG_nghttp2" ] ;then
    echo -e "$PKG_nghttp2" " 0.4 SBU"
    echo $PKG_nghttp2
    cd $PKG_nghttp2
   
    cd source

    patch -Np1 -i ../libxml2-2.13.3-upstream_fix-2.patch


    ./configure --prefix=/usr           \
            --sysconfdir=/etc       \
            --disable-static        \
            --with-history          \
            --with-icu              \
            PYTHON=/usr/bin/python3 \
            --docdir=/usr/share/doc/libxml2-2.13.3 &&
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    if $DO_OPTIONNAL_TESTS; then
        tar xf ../xmlts20130923.tar.gz
        make check-valgrind > check.log
        grep -E '^Total|expected|Ran' check.log
    fi

    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    rm -vf /usr/lib/libxml2.la && sed '/libs=/s/xml2.*/xml2"/' -i /usr/bin/xml2-config

    cd /sources/
    rm -Rf $PKG_libxml #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_libxml "$TOOL_READY"
fi
###********************************