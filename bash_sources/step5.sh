#!/bin/bash
# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

source ./terminal_params/_util_methodes.sh
source ./terminal_params/_pakages_names.sh


pushd /sources/
#***************************************************************************#
   echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$START_STEP5${STEP}*   #
    ############################################### ${NO_STYLE}
    "
###OP_Man_pages: 0.1SBU
if [ -n "$OP_Man_pages" ] ;then
    echo -e "$START_JOB"
    echo $OP_Man_pages
    tar -xf $OP_Man_pages.tar.xz
    cd $OP_Man_pages
   
    rm -v man3/crypt*
    make -s prefix=/usr install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi

    echo -e "$BUILD_SUCCEEDED"
    cd /sources/
    rm -Rf $OP_Man_pages #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Man_pages "$TOOL_READY"
fi
###********************************




###OP_Iana_Etc: 0.1SBU
if [ -n "$OP_Iana_Etc" ] ;then
    echo -e "$START_JOB"
    echo $OP_Iana_Etc
    tar -xf $OP_Iana_Etc.tar.gz
    cd $OP_Iana_Etc

    cp -v services protocols /etc

    cd /sources/
    rm -Rf $OP_Iana_Etc #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Iana_Etc "$TOOL_READY"
fi
###********************************



###OP_Glibc: 12SBU
if [ -n "$OP_Glibc" ] ;then
    echo -e "$START_JOB"
    echo $OP_Glibc
    tar -xf $OP_Glibc.tar.xz
    cd $OP_Glibc

    patch -Np1 -i ../$OP_Glibc-fhs-1.patch
    mkdir -v build
    cd       build
    echo "rootsbindir=/usr/sbin" > configparms
    ../configure --prefix=/usr                            \
             --disable-werror                         \
             --enable-kernel=4.19                     \
             --enable-stack-protector=strong          \
             --disable-nscd                           \
             libc_cv_slibdir=/usr/lib
    make -s && make -s check
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    touch /etc/ld.so.conf
    sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile

    make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd

    mkdir -pv /usr/lib/locale
    # add locals :
    localedef -i ar_DZ -f UTF-8 ar_DZ.UTF-8
    localedef -i C -f UTF-8 C.UTF-8
    localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
    localedef -i de_DE -f ISO-8859-1 de_DE
    localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
    localedef -i de_DE -f UTF-8 de_DE.UTF-8
    localedef -i el_GR -f ISO-8859-7 el_GR
    localedef -i en_GB -f ISO-8859-1 en_GB
    localedef -i en_GB -f UTF-8 en_GB.UTF-8
    localedef -i en_HK -f ISO-8859-1 en_HK
    localedef -i en_PH -f ISO-8859-1 en_PH
    localedef -i en_US -f ISO-8859-1 en_US
    localedef -i en_US -f UTF-8 en_US.UTF-8
    localedef -i es_ES -f ISO-8859-15 es_ES@euro
    localedef -i es_MX -f ISO-8859-1 es_MX
    localedef -i fa_IR -f UTF-8 fa_IR
    localedef -i fr_FR -f ISO-8859-1 fr_FR
    localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
    localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
    localedef -i is_IS -f ISO-8859-1 is_IS
    localedef -i is_IS -f UTF-8 is_IS.UTF-8
    localedef -i it_IT -f ISO-8859-1 it_IT
    localedef -i it_IT -f ISO-8859-15 it_IT@euro
    localedef -i it_IT -f UTF-8 it_IT.UTF-8
    localedef -i ja_JP -f EUC-JP ja_JP
    localedef -i ja_JP -f SHIFT_JIS ja_JP.SJIS 2> /dev/null || true
    localedef -i ja_JP -f UTF-8 ja_JP.UTF-8
    localedef -i nl_NL@euro -f ISO-8859-15 nl_NL@euro
    localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
    localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
    localedef -i se_NO -f UTF-8 se_NO.UTF-8
    localedef -i ta_IN -f UTF-8 ta_IN.UTF-8
    localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
    localedef -i zh_CN -f GB18030 zh_CN.GB18030
    localedef -i zh_HK -f BIG5-HKSCS zh_HK.BIG5-HKSCS
    localedef -i zh_TW -f UTF-8 zh_TW.UTF-8

    make -s localedata/install-locales
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    # re-add them here
    localedef -i ar_DZ -f UTF-8 ar_DZ.UTF-8
    localedef -i C -f UTF-8 C.UTF-8
    localedef -i ja_JP -f SHIFT_JIS ja_JP.SJIS 2> /dev/null || true


    cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

    tar -xf ../../tzdata2024a.tar.gz

    ZONEINFO=/usr/share/zoneinfo
    mkdir -pv $ZONEINFO/{posix,right}

    for tz in etcetera southamerica northamerica europe africa antarctica  \
            asia australasia backward; do
        zic -L /dev/null   -d $ZONEINFO       ${tz}
        zic -L /dev/null   -d $ZONEINFO/posix ${tz}
        zic -L leapseconds -d $ZONEINFO/right ${tz}
    done

    cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
    zic -d $ZONEINFO -p America/New_York
    unset ZONEINFO
    tzselect
    TIMEZONES=$(timedatectl list-timezones)
    while true; do
        read -p "$INPUT_TZ_VALUE" TZ_VALUE
        if echo "$TIMEZONES" | grep -q "^$TZ_VALUE$"; then
            echo -e "$VALID_TZ $TZ_VALUE"
            break
        fi
        echo -e "$NOT_VALID_TZ"
    done
    ln -sfv /usr/share/zoneinfo/$TZ_VALUE /etc/localtime

    cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib
# Add an include directory
include /etc/ld.so.conf.d/*.conf
EOF
    mkdir -pv /etc/ld.so.conf.d

    cd /sources/
    rm -Rf $OP_Glibc #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Glibc "$TOOL_READY"
fi
###********************************

sleep_before_complite


###OP_Zlib: 0.1SBU
if [ -n "$OP_Zlib" ] ;then
    echo -e "$START_JOB"
    echo $OP_Zlib
    tar -xf $OP_Zlib.tar.gz
    cd $OP_Zlib

    ./configure --prefix=/usr
    make -s && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    rm -fv /usr/lib/libz.a

    cd /sources/
    rm -Rf $OP_Zlib #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Zlib "$TOOL_READY"
fi
###********************************



###OP_Bzip: 0.1SBU
if [ -n "$OP_Bzip" ] ;then
    echo -e "$START_JOB"
    echo $OP_Bzip
    tar -xf $OP_Bzip.tar.gz
    cd $OP_Bzip

    patch -Np1 -i ../$OP_Bzip-install_docs-1.patch
    sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
    sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

    make -fs Makefile-libbz2_so && make -s clean && make -s && make -s PREFIX=/usr install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cp -av libbz2.so.* /usr/lib
    ln -sv libbz2.so.1.0.8 /usr/lib/libbz2.so

    cp -v bzip2-shared /usr/bin/bzip2
    for i in /usr/bin/{bzcat,bunzip2}; do
        ln -sfv bzip2 $i
    done    
    rm -fv /usr/lib/libbz2.a

    cd /sources/
    rm -Rf $OP_Bzip #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Bzip "$TOOL_READY"
fi
###********************************



###OP_Xz:0.1SBU
if [ -n "$OP_Xz" ] ;then
    echo -e "$START_JOB"
    echo $OP_Xz
    tar -xf $OP_Xz.tar.xz
    cd $OP_Xz

    if $STATIC_ONLY;then
        ./configure --prefix=/usr    \
                --enable-static \
                --disable-shared \
                --docdir=/usr/share/doc/$OP_Xz
    else
        ./configure --prefix=/usr    \
                --disable-static \
                --docdir=/usr/share/doc/$OP_Xz
    fi
    make -s && make -s check && make -s install
     if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources/
    rm -Rf $OP_Xz #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Xz "$TOOL_READY"
fi
###********************************



###OP_Zstd:0.5SBU
if [ -n "$OP_Zstd" ] ;then
    echo -e "$START_JOB"
    echo $OP_Zstd
    tar -xf $OP_Zstd.tar.gz
    cd $OP_Zstd

    make -s prefix=/usr && make -s check && make -s prefix=/usr install
     if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    rm -v /usr/lib/libzstd.a

    cd /sources/
    rm -Rf $OP_Zstd #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Zstd "$TOOL_READY"
fi
###********************************



###OP_File:0.1SBU
if [ -n "$OP_File" ] ;then
    echo -e "$START_JOB"
    echo $OP_File
    tar -xf $OP_File.tar.gz
    cd $OP_File

    ./configure --prefix=/usr
    make -s && make -s check && make -s install
     if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    cd /sources/
    rm -Rf $OP_File #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_File "$TOOL_READY"
fi
###********************************



###OP_Readline:0.1SBU
if [ -n "$OP_Readline" ] ;then
    echo -e "$START_JOB"
    echo $OP_Readline
    tar -xf $OP_Readline.tar.gz
    cd $OP_Readline

    sed -i '/MV.*old/d' Makefile.in
    sed -i '/{OLDSUFF}/c:' support/shlib-install

    patch -Np1 -i ../$OP_Readline-upstream_fixes-3.patch

    if $STATIC_ONLY;then
        ./configure --prefix=/usr    \
                --enable-static \
                --disable-shared \
                --with-curses    \
                --docdir=/usr/share/doc/$OP_Readline
        make -s && make -s install
    else
        ./configure --prefix=/usr    \
                --disable-static \
                --with-curses    \
                --docdir=/usr/share/doc/$OP_Readline
        make -s SHLIB_LIBS="-lncursesw" && make -s SHLIB_LIBS="-lncursesw" install
    fi
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
        echo -e "$BUILD_SUCCEEDED"

    if $ADD_OPTIONNAL_DOCS; then
        install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/$OP_Readline
    fi
    
    cd /sources/
    rm -Rf $OP_Readline #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Readline "$TOOL_READY"
fi
###********************************



###OR_M4: 0.3SBU
if [ -n "$OR_M4" ] ;then
    echo -e "$START_JOB"
    echo $OR_M4
    tar -xf $OR_M4.tar.xz
    cd $OR_M4

   ./configure --prefix=/usr
    make -s && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    cd /sources/
    rm -Rf $OR_M4 #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OR_M4 "$TOOL_READY"
fi
###********************************



###OP_Bc: 0.1SBU
if [ -n "$OP_Bc" ] ;then
    echo -e "$START_JOB"
    echo $OP_Bc
    tar -xf $OP_Bc.tar.xz
    cd $OP_Bc

    CC=gcc ./configure --prefix=/usr -G -O3 -r
    make -s && make -s test && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    cd /sources/
    rm -Rf $OP_Bc #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Bc "$TOOL_READY"
fi
###********************************



###OP_Flex: 0.1SBU
if [ -n "$OP_Flex" ] ;then
    echo -e "$START_JOB"
    echo $OP_Flex
    tar -xf $OP_Flex.tar.gz
    cd $OP_Flex

    if $STATIC_ONLY;then
        ./configure --prefix=/usr \
                --docdir=/usr/share/doc/$OP_Flex \
                --enable-static \
                --disable-shared 
    else
        ./configure --prefix=/usr \
            --docdir=/usr/share/doc/$OP_Flex \
            --disable-static
    fi
    make -s && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    ln -sv flex   /usr/bin/lex
    ln -sv flex.1 /usr/share/man/man1/lex.1

    cd /sources/
    rm -Rf $OP_Flex #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Flex "$TOOL_READY"
fi
###********************************



###OP_Tcl: 2.7SBU
if [ -n "$OP_Tcl" ] ;then
    echo -e "$START_JOB"
    echo $OP_Tcl
    tar -xf $OP_Tcl.tar.gz
    cd $OP_Tcl

    SRCDIR=$(pwd)
    cd unix
    ./configure --prefix=/usr           \
                --mandir=/usr/share/man

    make -s
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    sed -e "s|$SRCDIR/unix|/usr/lib|" \
        -e "s|$SRCDIR|/usr/include|"  \
        -i tclConfig.sh

    sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.5|/usr/lib/tdbc1.1.5|" \
        -e "s|$SRCDIR/pkgs/tdbc1.1.5/generic|/usr/include|"    \
        -e "s|$SRCDIR/pkgs/tdbc1.1.5/library|/usr/lib/tcl8.6|" \
        -e "s|$SRCDIR/pkgs/tdbc1.1.5|/usr/include|"            \
        -i pkgs/tdbc1.1.5/tdbcConfig.sh

    sed -e "s|$SRCDIR/unix/pkgs/itcl4.2.3|/usr/lib/itcl4.2.3|" \
        -e "s|$SRCDIR/pkgs/itcl4.2.3/generic|/usr/include|"    \
        -e "s|$SRCDIR/pkgs/itcl4.2.3|/usr/include|"            \
        -i pkgs/itcl4.2.3/itclConfig.sh

    unset SRCDIR


    make -s test && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    chmod -v u+w /usr/lib/libtcl8.6.so
    make install-private-headers
    ln -sfv tclsh8.6 /usr/bin/tclsh
    mv /usr/share/man/man3/{Thread,Tcl_Thread}.3

    if $ADD_OPTIONNAL_DOCS; then
        cd ..
        tar -xf ../$OP_Tcl-html.tar.gz --strip-components=1
        mkdir -v -p /usr/share/doc/$OP_Tcl
        cp -v -r  ./html/* /usr/share/doc/$OP_Tcl
    fi

    cd /sources/
    rm -Rf $OP_Tcl #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Tcl "$TOOL_READY"
fi
###********************************



###OP_Expect: 0.2SBU
if [ -n "$OP_Expect" ] ;then
    echo -e "$START_JOB"
    echo $OP_Expect
    tar -xf $OP_Expect.tar.gz
    cd $OP_Expect

    python3 -c 'from pty import spawn; spawn(["echo", "ok"])'
    ./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include
    make -s && make -s test && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    ln -svf $OP_Expect/libexpect5.45.4.so /usr/lib

    cd /sources/
    rm -Rf $OP_Expect #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Expect "$TOOL_READY"
fi
###********************************



###OP_DejaGNU: 0.1SBU
if [ -n "$OP_DejaGNU" ] ;then
    echo -e "$START_JOB"
    echo $OP_DejaGNU
    tar -xf $OP_DejaGNU.tar.gz
    cd $OP_DejaGNU

    mkdir -v build
    cd       build

    ../configure --prefix=/usr
    makeinfo --html --no-split -o doc/dejagnu.html ../doc/dejagnu.texi
    makeinfo --plaintext       -o doc/dejagnu.txt  ../doc/dejagnu.texi
    make -s check && make -s install
     if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    install -v -dm755  /usr/share/doc/$OP_DejaGNU
    install -v -m644   doc/dejagnu.{html,txt} /usr/share/doc/$OP_DejaGNU

    cd /sources/
    rm -Rf $OP_DejaGNU #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_DejaGNU "$TOOL_READY"
fi
###********************************



###OP_Pkgconf: 0.1SBU
if [ -n "$OP_Pkgconf" ] ;then
    echo -e "$START_JOB"
    echo $OP_Pkgconf
    tar -xf $OP_Pkgconf.tar.xz
    cd $OP_Pkgconf

     if $STATIC_ONLY;then
        ./configure --prefix=/usr \
                --docdir=/usr/share/doc/$OP_Pkgconf \
                --enable-static \
                --disable-shared 
    else
        ./configure --prefix=/usr \
            --docdir=/usr/share/doc/$OP_Pkgconf \
            --disable-static
    fi  
    make -s && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    ln -sv pkgconf   /usr/bin/pkg-config
    ln -sv pkgconf.1 /usr/share/man/man1/pkg-config.1

    cd /sources/
    rm -Rf $OP_Pkgconf #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Pkgconf "$TOOL_READY"
fi
###********************************



###OP_Pkgconf: 0.1SBU
if [ -n "$OP_Pkgconf" ] ;then
    echo -e "$START_JOB"
    echo $OP_Pkgconf
    tar -xf $OP_Pkgconf.tar.xz
    cd $OP_Pkgconf

     if $STATIC_ONLY;then
        ./configure --prefix=/usr \
                --docdir=/usr/share/doc/$OP_Pkgconf\
                --enable-static \
                --disable-shared 
    else
        ./configure --prefix=/usr \
            --docdir=/usr/share/doc/$OP_Pkgconf\
            --disable-static
    fi  
    make -s && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    ln -sv pkgconf   /usr/bin/pkg-config
    ln -sv pkgconf.1 /usr/share/man/man1/pkg-config.1

    cd /sources/
    rm -Rf $OP_Pkgconf #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Pkgconf "$TOOL_READY"
fi
###********************************

sleep_before_complite

###OP_Binutils: 2.2SBU
if [ -n "$OP_Binutils" ] ;then
    echo -e "$START_JOB"
    echo $OP_Binutils
    tar -xf $OP_Binutils.tar.xz
    cd $OP_Binutils

    mkdir -v build
    cd       build

    ../configure --prefix=/usr       \
             --sysconfdir=/etc   \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --with-system-zlib  \
             --enable-default-hash-style=gnu

    make -s tooldir=/usr && make -ks check
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    grep '^FAIL:' $(find -name '*.log')

    make -s tooldir=/usr install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    rm -fv /usr/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.a

    cd /sources/
    rm -Rf $OP_Binutils #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Binutils "$TOOL_READY"
fi
###********************************



###OP_GMP: 0.3SBU
if [ -n "$OP_GMP" ] ;then
    echo -e "$START_JOB"
    echo $OP_GMP
    tar -xf $OP_GMP.tar.xz
    cd $OP_GMP

    CPU_ARCH_IS_32BIT_X86=""
    if [ "i686" == "$CPU_SELECTED_ARCH" ]; then
       CPU_ARCH_IS_32BIT_X86="ABI=32" #for 32bit targets
    fi

    MY_CONFIG_PARAM=""
    if [ "$(uname -m)" != "$CPU_SELECTED_ARCH" ]; then
       MY_CONFIG_PARAM="--host=none-linux-gnu" #don't optimize for the host
    fi

    if $STATIC_ONLY;then
        $CPU_ARCH_IS_32BIT_X86 ./configure --prefix=/usr \
                                            --enable-cxx     \
                                            --docdir=/usr/share/doc/$OP_GMP\
                                            --enable-static \
                                            --disable-shared \ $MY_CONFIG_PARAM
    else
        $CPU_ARCH_IS_32BIT_X86 ./configure --prefix=/usr \
                                            --enable-cxx     \
                                            --docdir=/usr/share/doc/$OP_GMP \
                                            --disable-static \ $MY_CONFIG_PARAM
    fi
    make -s && make -s html
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    make check 2>&1 | tee gmp-check-log
    awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log
    make -s install
    make -s install-html

    cd /sources/
    rm -Rf $OP_GMP #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_GMP "$TOOL_READY"
fi
###********************************



###OP_MPFR: 0.3SBU
if [ -n "$OP_MPFR" ] ;then
    echo -e "$START_JOB"
    echo $OP_MPFR
    tar -xf $OP_MPFR.tar.xz
    cd $OP_MPFR

     if $STATIC_ONLY;then
        ./configure --prefix=/usr \
                --enable-thread-safe \
                --docdir=/usr/share/doc/$OP_MPFR\
                --enable-static \
                --disable-shared 
    else
        ./configure --prefix=/usr \
            --enable-thread-safe \
            --docdir=/usr/share/doc/$OP_MPFR \
            --disable-static
    fi
    make -s && make -s html
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    make -s check && make -s install && make -s install-html

    cd /sources/
    rm -Rf $OP_MPFR #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_MPFR "$TOOL_READY"
fi
###********************************



###OP_MPC: 0.1SBU
if [ -n "$OP_MPC" ] ;then
    echo -e "$START_JOB"
    echo $OP_MPC
    tar -xf $OP_MPC.tar.gz
    cd $OP_MPC

     if $STATIC_ONLY;then
        ./configure --prefix=/usr \
                --docdir=/usr/share/doc/$OP_MPC\
                --enable-static \
                --disable-shared 
    else
        ./configure --prefix=/usr \
            --docdir=/usr/share/doc/$OP_MPC \
            --disable-static
    fi
    make -s && make -s html
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    make -s check && make -s install && make -s install-html

    cd /sources/
    rm -Rf $OP_MPC #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_MPC "$TOOL_READY"
fi
###********************************



###OP_Attr: 0.1SBU
if [ -n "$OP_Attr" ] ;then
    echo -e "$START_JOB"
    echo $OP_Attr
    tar -xf $OP_Attr.tar.gz
    cd $OP_Attr

     if $STATIC_ONLY;then
        ./configure --prefix=/usr \
                --sysconfdir=/etc \
                --docdir=/usr/share/doc/$OP_Attr\
                --enable-static \
                --disable-shared 
    else
        ./configure --prefix=/usr \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/$OP_Attr \
            --disable-static
    fi
    make -s && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources/
    rm -Rf $OP_Attr #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Attr "$TOOL_READY"
fi
###********************************



###OP_Acl part 1: 0.1SBU
if [ -n "$OP_Acl" ] ;then
    echo -e "$START_JOB"
    echo $OP_Acl
    tar -xf $OP_Acl.tar.xz
    cd $OP_Acl

    if $STATIC_ONLY;then
        ./configure --prefix=/usr         \
            --enable-static \
            --disable-shared \
            --docdir=/usr/share/doc/$OP_Acl
    else
        ./configure --prefix=/usr         \
            --disable-static      \
            --docdir=/usr/share/doc/$OP_Acl       
    fi
    make -s && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources/
    #rm -Rf $OP_Acl #rm extracted pkg( run make check after the Coreutils package has been built.)
    echo -e "$DONE" 
    echo -e $OP_Acl "$TOOL_READY"
fi
###********************************


###OP_Libcap: 0.1SBU
if [ -n "$OP_Libcap" ] ;then
    echo -e "$START_JOB"
    echo $OP_Libcap
    tar -xf $OP_Libcap.tar.xz
    cd $OP_Libcap

    sed -i '/install -m.*STA/d' libcap/Makefile
    make -s prefix=/usr lib=lib && make -s test && make -s prefix=/usr lib=lib install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    cd /sources/
    rm -Rf $OP_Libcap #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Libcap "$TOOL_READY"
fi
###********************************



###OP_Libxcrypt: 0.1SBU
if [ -n "$OP_Libxcrypt" ] ;then
    echo -e "$START_JOB"
    echo $OP_Libxcrypt
    tar -xf $OP_Libxcrypt.tar.xz
    cd $OP_Libxcrypt

    if $STATIC_ONLY;then
        ./configure --prefix=/usr                \
                    --enable-hashes=strong,glibc \
                    --enable-obsolete-api=no     \
                    --enable-static \
                    --disable-shared \
                    --disable-failure-tokens
    else
        ./configure ---prefix=/usr                \
                    --enable-hashes=strong,glibc \
                    --enable-obsolete-api=no     \
                    --disable-static             \
                    --disable-failure-tokens
    fi
    make -s && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources/
    rm -Rf $OP_Libxcrypt #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Libxcrypt "$TOOL_READY"
fi
###********************************



###OP_CrackLib (BLFS): 0.1SBU
USING_CRACKLIB=false
if [ -n "$OP_Shadow" ] ;then
    echo -e "$START_JOB"
    echo $OP_CrackLib
    tar -xf $OP_CrackLib.tar.xz
    cd $OP_CrackLib

    autoreconf -fiv &&

    PYTHON=python3               \
    ./configure --prefix=/usr    \
                --disable-static \
                --with-default-dict=/usr/lib/cracklib/pw_dict &&
    make -s && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    install -v -m644 -D    ../$OP_CrackLib_words \
                         /usr/share/dict/cracklib-words.xz    &&

    unxz -v                  /usr/share/dict/cracklib-words.xz    &&
    ln -v -sf cracklib-words /usr/share/dict/words                &&
    echo $(hostname) >>      /usr/share/dict/cracklib-extra-words &&
    install -v -m755 -d      /usr/lib/cracklib                    &&

    cd /sources/
    # ADD passwords lists
    bunzip2 -k $OP_CrackLib_jhon_psw.txt.bz2
    mv $OP_CrackLib_jhon_psw.txt /usr/share/dict/$OP_CrackLib_jhon_psw.txt

    bunzip2 -k $OP_CrackLib_cain_psw.txt.bz2
    mv $OP_CrackLib_cain_psw.txt /usr/share/dict/$OP_CrackLib_cain_psw.txt
    
    bunzip2 -k $OP_CrackLib_500_psw.txt.bz2
    mv $OP_CrackLib_500_psw.txt /usr/share/dict/$OP_CrackLib_500_psw.txt
    
    bunzip2 -k $OP_CrackLib_twitter_psw.txt.bz2
    mv $OP_CrackLib_twitter_psw.txt /usr/share/dict/$OP_CrackLib_twitter_psw.txt

    # update cracklib
    create-cracklib-dict /usr/share/dict/cracklib-words \
                            /usr/share/dict/cracklib-extra-words \
                            /usr/share/dict/$OP_CrackLib_jhon_psw.txt \
                            /usr/share/dict/$OP_CrackLib_cain_psw.txt \
                            /usr/share/dict/$OP_CrackLib_500_psw.txt \
                            /usr/share/dict/$OP_CrackLib_twitter_psw.txt

    make -s test
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    USING_CRACKLIB=true
    cd /sources/
    rm -Rf $OP_CrackLib #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_CrackLib "$TOOL_READY"
fi
###********************************

###OP_Shadow: 0.1SBU
if [ -n "$OP_Shadow" ] ;then
    echo -e "$START_JOB"
    echo $OP_Shadow
    tar -xf $OP_Shadow.tar.xz
    cd $OP_Shadow

    OPTIONNAL_HIGH_SECURITY=""
    if $USING_CRACKLIB; then
        OPTIONNAL_HIGH_SECURITY="--with-libcrack"
    fi

    sed -i 's/groups$(EXEEXT) //' src/Makefile.in
    find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
    find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
    find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;
    sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD YESCRYPT:' \
    -e 's:/var/spool/mail:/var/mail:'                   \
    -e '/PATH=/{s@/sbin:@@;s@/bin:@@}'                  \
    -i etc/login.defs

    if $USING_CRACKLIB; then
        sed -i 's:DICTPATH.*:DICTPATH\t/lib/cracklib/pw_dict:' etc/login.defs
    fi

    touch /usr/bin/passwd
    if $STATIC_ONLY;then
        ./configure --sysconfdir=/etc   \
            --enable-static \
            --disable-shared \
            --with-{b,yes}crypt \
            --without-libbsd    \
            --with-group-name-max-length=32 \
            $OPTIONNAL_HIGH_SECURITY
    else
       ./configure --sysconfdir=/etc   \
            --disable-static    \
            --with-{b,yes}crypt \
            --without-libbsd    \
            --with-group-name-max-length=32 \
            $OPTIONNAL_HIGH_SECURITY
    fi
    make -s && make -s exec_prefix=/usr install && make -Cs man install-man
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    pwconv
    grpconv
    mkdir -p /etc/default
    useradd -D --gid 999
    sed -i '/MAIL/s/yes/no/' /etc/default/useradd

    passwd root

    cd /sources/
    rm -Rf $OP_Shadow #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Shadow "$TOOL_READY"
fi
###********************************


sleep_before_complite


###OP_GCC: 42SBU
if [ -n "$OP_GCC" ] ;then
    echo -e "$START_JOB"
    echo $OP_GCC
    tar -xf $OP_GCC.tar.xz
    cd $OP_GCC

    case $(uname -m) in
    x86_64)
        sed -e '/m64=/s/lib64/lib/' \
            -i.orig gcc/config/i386/t-linux64
    ;;
    esac

    mkdir -v build
    cd       build

    ../configure --prefix=/usr            \
             LD=ld                    \
             --enable-languages=c,c++ \
             --enable-default-pie     \
             --enable-default-ssp     \
             --disable-multilib       \
             --disable-bootstrap      \
             --disable-fixincludes    \
             --with-system-zlib
    make -s && ulimit -s 32768
    chown -R tester .
    su tester -c "PATH=$PATH make -k check -j$(nproc)"
    ../contrib/test_summary

    make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    chown -v -R root:root \
    /usr/lib/gcc/$(gcc -dumpmachine)/13.2.0/include{,-fixed}

    ln -svr /usr/bin/cpp /usr/lib

    ln -sv gcc.1 /usr/share/man/man1/cc.1 
    ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/13.2.0/liblto_plugin.so \
        /usr/lib/bfd-plugins/
    
    #test
    echo -e "$START_TEST"
    echo 'int main(){}' > dummy.c
    cc dummy.c -v -Wl,--verbose &> dummy.log

    echo -e "$EXPECT_OUTPUT"
    echo "[Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]"
    # Check the program interpreter using readelf and grep for ld-linux
    output=$(readelf -l a.out | grep ld-linux)
    echo -e "\n$REAL_OUTPUT"
    echo $output
    grep -E -o '/usr/lib.*/S?crt[1in].*succeeded' dummy.log


    # Expected output format check
    if echo "$output" | grep -E '/lib(64)?/ld-linux(-x86-64)?\.so\.2'; then
        echo -e "$TEST_PASS"
        # Clean up
        rm -v a.out
    else
        echo -e "Interpreter "
        # Clean up and exit with an error
        rm -v a.out
        exit 1
    fi

    grep -B4 '^ /usr/include' dummy.log
    grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
    grep "/lib.*/libc.so.6 " dummy.log
    grep found dummy.log
    rm -v dummy.c a.out dummy.log

    mkdir -pv /usr/share/gdb/auto-load/usr/lib
    mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

    cd /sources/
    rm -Rf $OP_GCC #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_GCC "$TOOL_READY"
fi
###********************************

sleep_before_complite

###OP_Ncurses: 0.2SBU
if [ -n "$OP_Ncurses" ] ;then
    echo -e "$START_JOB"
    echo $OP_Ncurses
    tar -xf $OP_Ncurses.tar.xz
    cd $OP_Ncurses
    
    ./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --with-cxx-shared       \
            --enable-pc-files       \
            --enable-widec          \
            --with-pkg-config-libdir=/usr/lib/pkgconfig

    make -s && make -s DESTDIR=$PWD/dest install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    
    install -vm755 dest/usr/lib/libncursesw.so.6.4 /usr/lib
    rm -v  dest/usr/lib/libncursesw.so.6.4
    sed -e 's/^#if.*XOPEN.*$/#if 1/' \
        -i dest/usr/include/curses.h
    cp -av dest/* /

    for lib in ncurses form panel menu ; do
        ln -sfv lib${lib}w.so /usr/lib/lib${lib}.so
        ln -sfv ${lib}w.pc    /usr/lib/pkgconfig/${lib}.pc
    done

    ln -sfv libncursesw.so /usr/lib/libcurses.so

    cp -v -R doc -T /usr/share/doc/$OP_Ncurses

    cd /sources/
    rm -Rf $OP_Ncurses #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Ncurses "$TOOL_READY"
fi
###********************************



###OP_Sed: 0.3SBU
if [ -n "$OP_Sed" ] ;then
    echo -e "$START_JOB"
    echo $OP_Sed
    tar -xf $OP_Sed.tar.xz
    cd $OP_Sed

    ./configure --prefix=/usr
    make -s && make -s html
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    chown -R tester .
    su tester -c "PATH=$PATH make -s check"
    
    make -s install
    install -d -m755           /usr/share/doc/$OP_Sed
    install -m644 doc/sed.html /usr/share/doc/$OP_Sed

    cd /sources/
    rm -Rf $OP_Sed #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Sed "$TOOL_READY"
fi
###********************************



###OP_Psmisc: 0.1SBU
if [ -n "$OP_Psmisc" ] ;then
    echo -e "$START_JOB"
    echo $OP_Psmisc
    tar -xf $OP_Psmisc.tar.xz
    cd $OP_Psmisc

    ./configure --prefix=/usr
    make -s  && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    cd /sources/
    rm -Rf $OP_Psmisc #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Psmisc "$TOOL_READY"
fi
###********************************



###OP_Gettext: 1.4SBU
if [ -n "$OP_Gettext" ] ;then
    echo -e "$START_JOB"
    echo $OP_Gettext
    tar -xf $OP_Gettext.tar.xz
    cd $OP_Gettext

    if $STATIC_ONLY;then
        ./configure --prefix=/usr \
                --docdir=/usr/share/doc/$OP_Gettext\
                --enable-static \
                --disable-shared 
    else
        ./configure --prefix=/usr \
            --docdir=/usr/share/doc/$OP_Gettext \
            --disable-static
    fi
    make -s && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    chmod -v 0755 /usr/lib/preloadable_libintl.so

    cd /sources/
    rm -Rf $OP_Gettext #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Gettext "$TOOL_READY"
fi
###********************************



###OP_Bison: 2.3SBU
if [ -n "$OP_Bison" ] ;then
    echo -e "$START_JOB"
    echo $OP_Bison
    tar -xf $OP_Bison.tar.xz
    cd $OP_Bison

    ./configure --prefix=/usr --docdir=/usr/share/doc/$START_JOB
    make -s  && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    cd /sources/
    rm -Rf $OP_Bison #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Bison "$TOOL_READY"
fi
###********************************

sleep_before_complite

###OP_Grep: 0.4SBU
if [ -n "$OP_Grep" ] ;then
    echo -e "$START_JOB"
    echo $OP_Grep
    tar -xf $OP_Grep.tar.xz
    cd $OP_Grep

    sed -i "s/echo/#echo/" src/egrep.sh
    ./configure --prefix=/usr
    make -s  && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    cd /sources/
    rm -Rf $OP_Grep #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Grep "$TOOL_READY"
fi
###********************************



###OP_Bash: 1.2SBU
if [ -n "$OP_Bash" ] ;then
    echo -e "$START_JOB"
    echo $OP_Bash
    tar -xf $OP_Bash.tar.gz
    cd $OP_Bash

    patch -Np1 -i ../$OP_Bash.-upstream_fixes-1.patch
    ./configure --prefix=/usr             \
            --without-bash-malloc     \
            --with-installed-readline \
            --docdir=/usr/share/doc/$OP_Bash
    make -s
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    if $DO_OPTIONNAL_TESTS; then    
        chown -R tester .
        su -s /usr/bin/expect tester << "EOF"
set timeout -1
spawn make tests
expect eof
lassign [wait] _ _ _ value
exit $value
EOF
    fi

    make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    exec /usr/bin/bash --login

    cd /sources/
    rm -Rf $OP_Bash #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Bash "$TOOL_READY"
fi
###********************************

sleep_before_complite

###OP_Libtool: 0.6SBU
if [ -n "$OP_Libtool" ] ;then
    echo -e "$START_JOB"
    echo $OP_Libtool
    tar -xf $OP_Libtool.tar.xz
    cd $OP_Libtool

   ./configure --prefix=/usr
    make -s  && make -ks check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    rm -fv /usr/lib/libltdl.a

    cd /sources/
    rm -Rf $OP_Libtool #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Libtool "$TOOL_READY"
fi
###********************************



###OP_GDBM: 0.1SBU
if [ -n "$OP_GDBM" ] ;then
    echo -e "$START_JOB"
    echo $OP_GDBM
    tar -xf $OP_GDBM.tar.gz
    cd $OP_GDBM

    if $STATIC_ONLY;then
        ./configure --prefix=/usr \
                --enable-libgdbm-compat \
                --enable-static \
                --disable-shared 
    else
        ./configure --prefix=/usr \
            --enable-libgdbm-compat \
            --disable-static
    fi
    make -s && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources/
    rm -Rf $OP_GDBM #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_GDBM "$TOOL_READY"
fi
###********************************



###OP_Gperf: 0.1SBU
if [ -n "$OP_Gperf" ] ;then
    echo -e "$START_JOB"
    echo $OP_Gperf
    tar -xf $OP_Gperf.tar.gz
    cd $OP_Gperf

    ./configure --prefix=/usr --docdir=/usr/share/doc/$OP_Gperf
    make -s  && make -sj1 check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    cd /sources/
    rm -Rf $OP_Gperf #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Gperf "$TOOL_READY"
fi
###********************************



###OP_Expat: 0.1SBU
if [ -n "$OP_Expat" ] ;then
    echo -e "$START_JOB"
    echo $OP_Expat
    tar -xf $OP_Expat.tar.xz
    cd $OP_Expat

    if $STATIC_ONLY;then
        ./configure --prefix=/usr \
                    --docdir=/usr/share/doc/$OP_Expat \
                    --enable-static \
                    --disable-shared 
    else
        ./configure --prefix=/usr \
                    --docdir=/usr/share/doc/$OP_Expat \
                    --disable-static
    fi
    make -s && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    if $ADD_OPTIONNAL_DOCS; then
        install -v -m644 doc/*.{html,css} /usr/share/doc/$OP_Expat
    fi

    cd /sources/
    rm -Rf $OP_Expat #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Expat "$TOOL_READY"
fi
###********************************



###OP_Inetutils: 0.2SBU
if [ -n "$OP_Inetutils" ] ;then
    echo -e "$START_JOB"
    echo $OP_Inetutils
    tar -xf $OP_Inetutils.tar.xz
    cd $OP_Inetutils

    ./configure --prefix=/usr        \
            --bindir=/usr/bin    \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers
    make -s  && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    mv -v /usr/{,s}bin/ifconfig

    cd /sources/
    rm -Rf $OP_Inetutils #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Inetutils "$TOOL_READY"
fi
###********************************



###OP_Less: 0.1SBU
if [ -n "$OP_Less" ] ;then
    echo -e "$START_JOB"
    echo $OP_Less
    tar -xf $OP_Less.tar.gz
    cd $OP_Less

    ./configure --prefix=/usr --sysconfdir=/etc
    make -s  && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    cd /sources/
    rm -Rf $OP_Less #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Less "$TOOL_READY"
fi
###********************************



###OP_Perl: 1.5 SBU
if [ -n "$OP_Perl" ] ;then
    echo -e "$START_JOB"
    echo $OP_Perl
    tar -xf $OP_Perl.tar.xz
    cd $OP_Perl

    export BUILD_ZLIB=False
    export BUILD_BZIP2=0

    sh Configure -des                                         \
             -Dprefix=/usr                                \
             -Dvendorprefix=/usr                          \
             -Dprivlib=/usr/lib/perl5/5.38/core_perl      \
             -Darchlib=/usr/lib/perl5/5.38/core_perl      \
             -Dsitelib=/usr/lib/perl5/5.38/site_perl      \
             -Dsitearch=/usr/lib/perl5/5.38/site_perl     \
             -Dvendorlib=/usr/lib/perl5/5.38/vendor_perl  \
             -Dvendorarch=/usr/lib/perl5/5.38/vendor_perl \
             -Dman1dir=/usr/share/man/man1                \
             -Dman3dir=/usr/share/man/man3                \
             -Dpager="/usr/bin/less -isR"                 \
             -Duseshrplib                                 \
             -Dusethreads

    make -s  && TEST_JOBS=$(nproc) make test_harness && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    unset BUILD_ZLIB BUILD_BZIP2

    cd /sources/
    rm -Rf $OP_Perl #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Perl "$TOOL_READY"
fi
###********************************



###OP_XML: 0.1SBU
if [ -n "$OP_XML" ] ;then
    echo -e "$START_JOB"
    echo $OP_XML
    tar -xf $OP_XML.tar.gz
    cd $OP_XML

    perl Makefile.PL
    make -s  && make -s test && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    cd /sources/
    rm -Rf $OP_XML #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_XML "$TOOL_READY"
fi
###********************************



###OP_Intltool: 0.1SBU
if [ -n "$OP_Intltool" ] ;then
    echo -e "$START_JOB"
    echo $OP_Intltool
    tar -xf $OP_Intltool.tar.gz
    cd $OP_Intltool

    sed -i 's:\\\${:\\\$\\{:' intltool-update.in
   ./configure --prefix=/usr
    make -s  && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/$OP_Intltool/I18N-HOWTO

    cd /sources/
    rm -Rf $OP_Intltool #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Intltool "$TOOL_READY"
fi
###********************************



###OP_Autoconf: 0.1SBU
if [ -n "$OP_Autoconf" ] ;then
    echo -e "$START_JOB"
    echo $OP_Autoconf
    tar -xf $OP_Autoconf.tar.xz
    cd $OP_Autoconf

   ./configure --prefix=/usr
    make -s  && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    

    cd /sources/
    rm -Rf $OP_Autoconf #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Autoconf "$TOOL_READY"
fi
###********************************

sleep_before_complite

###OP_Automake: 0.1SBU
if [ -n "$OP_Automake" ] ;then
    echo -e "$START_JOB"
    echo $OP_Automake
    tar -xf $OP_Automake.tar.xz
    cd $OP_Automake

   ./configure --prefix=/usr --docdir=/usr/share/doc/$OP_Automake
    make -s  && make -sj$(($(nproc)>4?$(nproc):4)) check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    

    cd /sources/
    rm -Rf $OP_Automake #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Automake "$TOOL_READY"
fi
###********************************



###OP_OpenSSL: 1.8SBU
if [ -n "$OP_OpenSSL" ] ;then
    echo -e "$START_JOB"
    echo $OP_OpenSSL
    tar -xf $OP_OpenSSL.tar.gz
    cd $OP_OpenSSL

   ./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic
    make -s  && HARNESS_JOBS=$(nproc) make -s test
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
    make -s MANSUFFIX=ssl install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    mv -v /usr/share/doc/openssl /usr/share/doc/$OP_OpenSSL
    cp -vfr doc/* /usr/share/doc/$OP_OpenSSL
    cd /sources/
    rm -Rf $OP_OpenSSL #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_OpenSSL "$TOOL_READY"
fi
###********************************



###OP_Kmod: 0.1SBU
if [ -n "$OP_Kmod" ] ;then
    echo -e "$START_JOB"
    echo $OP_Kmod
    tar -xf $OP_Kmod.tar.xz
    cd $OP_Kmod

   ./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --with-openssl         \
            --with-xz              \
            --with-zstd            \
            --with-zlib
    make -s  && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    for target in depmod insmod modinfo modprobe rmmod; do
        ln -sfv ../bin/kmod /usr/sbin/$target
    done

    ln -sfv kmod /usr/bin/lsmod

    cd /sources/
    rm -Rf $OP_Kmod #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Kmod "$TOOL_READY"
fi
###********************************

sleep_before_complite

###OP_Libelf: 0.3SBU
if [ -n "$OP_Libelf" ] ;then
    echo -e "$START_JOB"
    echo $OP_Libelf
    tar -xf $OP_Libelf.tar.bz2
    cd $OP_Libelf

   ./configure --prefix=/usr            \
            --disable-debuginfod         \
            --enable-libdebuginfod=dummy
    make -s && make -s check  && make -Cs libelf install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    install -vm644 config/libelf.pc /usr/lib/pkgconfig
    rm /usr/lib/libelf.a

    cd /sources/
    rm -Rf $OP_Libelf #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Libelf "$TOOL_READY"
fi
###********************************



###OP_Libffi: 1.8SBU
if [ -n "$OP_Libffi" ] ;then
    echo -e "$START_JOB"
    echo $OP_Libffi
    tar -xf $OP_Libffi.tar.gz
    cd $OP_Libffi

    if $STATIC_ONLY;then
        ./configure --prefix=/usr          \
                --enable-static \
                --disable-shared \
                --with-gcc-arch=$CPU_SELECTED_ARCH #optimize for the selected cpu
    else
        ./configure --prefix=/usr          \
                --disable-static       \
                --with-gcc-arch=$CPU_SELECTED_ARCH #optimize for the selected cpu
    fi
    make -s && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources/
    rm -Rf $OP_Libffi #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Libffi "$TOOL_READY"
fi
###********************************



###OP_Python: 1.8SBU
if [ -n "$OP_Python" ] ;then
    echo -e "$START_JOB"
    echo $OP_Python
    tar -xf $OP_Python.tar.xz
    cd $OP_Python

   ./configure --prefix=/usr        \
            --enable-shared      \
            --with-system-expat  \
            --enable-optimizations
    make -s && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    cat > /etc/pip.conf << EOF
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF

    if $ADD_OPTIONNAL_DOCS; then
        install -v -dm755 /usr/share/doc/$OP_Python_docs/html

        tar --no-same-owner \
            -xvf ../$OP_Python_docs-docs-html.tar.bz2
        cp -R --no-preserve=mode $OP_Python_docs-docs-html/* \
            /usr/share/doc/$OP_Python_docs/html
    fi

    cd /sources/
    rm -Rf $OP_Python #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Python "$TOOL_READY"
fi
###********************************



###OP_Flit_Core: 0.1SBU
if [ -n "$OP_Flit_Core" ] ;then
    echo -e "$START_JOB"
    echo $OP_Flit_Core
    tar -xf $OP_Flit_Core.tar.gz
    cd $OP_Flit_Core

    pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
    pip3 install --no-index --no-user --find-links dist flit_core

    cd /sources/
    rm -Rf $OP_Flit_Core #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Flit_Core "$TOOL_READY"
fi
###********************************

sleep_before_complite

###OP_Wheel: 0.1SBU
if [ -n "$OP_Wheel" ] ;then
    echo -e "$START_JOB"
    echo $OP_Wheel
    tar -xf $OP_Wheel.tar.gz
    cd $OP_Wheel

    pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
    pip3 install --no-index --find-links=dist wheel

    cd /sources/
    rm -Rf $OP_Wheel #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Wheel "$TOOL_READY"
fi
###********************************



###OP_Setuptools: 0.1SBU
if [ -n "$OP_Setuptools" ] ;then
    echo -e "$START_JOB"
    echo $OP_Setuptools
    tar -xf $OP_Setuptools.tar.gz
    cd $OP_Setuptools

    pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
    pip3 install --no-index --find-links dist setuptools

    cd /sources/
    rm -Rf $OP_Setuptools #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Setuptools "$TOOL_READY"
fi
###********************************



###OP_Ninja: 0.3SBU
if [ -n "$OP_Ninja" ] ;then
    echo -e "$START_JOB"
    echo $OP_Ninja
    tar -xf $OP_Ninja.tar.gz
    cd $OP_Ninja

    export NINJAJOBS=8

    sed -i '/int Guess/a \
    int   j = 0;\
    char* jobs = getenv( "NINJAJOBS" );\
    if ( jobs != NULL ) j = atoi( jobs );\
    if ( j > 0 ) return j;\
    ' src/ninja.cc

    python3 configure.py --bootstrap

    ./ninja ninja_test
    ./ninja_test --gtest_filter=-SubprocessTest.SetWithLots
    install -vm755 ninja /usr/bin/
    install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
    install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja

    cd /sources/
    rm -Rf $OP_Ninja #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Ninja "$TOOL_READY"
fi
###********************************



###OP_Meson: 0.1SBU
if [ -n "$OP_Meson" ] ;then
    echo -e "$START_JOB"
    echo $OP_Meson
    tar -xf $OP_Meson.tar.gz
    cd $OP_Meson

    pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

    pip3 install --no-index --find-links dist meson
    install -vDm644 data/shell-completions/bash/meson /usr/share/bash-completion/completions/meson
    install -vDm644 data/shell-completions/zsh/_meson /usr/share/zsh/site-functions/_meson

    cd /sources/
    rm -Rf $OP_Meson #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Meson "$TOOL_READY"
fi
###********************************



###OP_Coreutils: 1SBU
if [ -n "$OP_Coreutils" ] ;then
    echo -e "$START_JOB"
    echo $OP_Coreutils
    tar -xf $OP_Coreutils.tar.xz
    cd $OP_Coreutils

    patch -Np1 -i ../$OP_Coreutils-i18n-1.patch

    sed -e '/n_out += n_hold/,+4 s|.*bufsize.*|//&|' \
    -i src/split.c

    autoreconf -fiv
    FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime
    make -s 
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    if DO_OPTIONNAL_TESTS; then
        make -s NON_ROOT_USERNAME=tester check-root
        groupadd -g 102 dummy -U tester
        chown -R tester . 
        su tester -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"
        groupdel dummy
    fi

    make -s install

    mv -v /usr/bin/chroot /usr/sbin
    mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
    sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8

    # complite unfinsihed tasks
        cd $OP_Acl
        make check
        cd /sources/
        rm -Rf $OP_Acl
    #####

    cd /sources/
    rm -Rf $OP_Coreutils #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Coreutils "$TOOL_READY"
fi
###********************************



###OP_Check: 0.1
if [ -n "$OP_Check" ] ;then
    echo -e "$START_JOB"
    echo $OP_Check
    tar -xf $OP_Check.tar.gz
    cd $OP_Check

    if $STATIC_ONLY;then
       ./configure --prefix=/usr \
                --enable-static \
                --disable-shared 
    else
        ./configure --prefix=/usr --disable-static
    fi
    make -s && make -s check && make -s docdir=/usr/share/doc/$OP_Check install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources/
    rm -Rf $OP_Check #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Check "$TOOL_READY"
fi
###********************************



###OP_Diffutils: 0.3SBU
if [ -n "$OP_Diffutils" ] ;then
    echo -e "$START_JOB"
    echo $OP_Diffutils
    tar -xf $OP_Diffutils.tar.xz
    cd $OP_Diffutils

    ./configure --prefix=/usr
    make -s && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources/
    rm -Rf $OP_Diffutils #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Diffutils "$TOOL_READY"
fi
###********************************

sleep_before_complite

###OP_Gawk: 0.1SBU
if [ -n "$OP_Gawk" ] ;then
    echo -e "$START_JOB"
    echo $OP_Gawk
    tar -xf $OP_Gawk.tar.xz
    cd $OP_Gawk

   sed -i 's/extras//' Makefile.in

   ./configure --prefix=/usr
    make -s 
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    chown -R tester .
    su tester -c "PATH=$PATH make -s check"
    rm -f /usr/bin/$OP_Gawk
    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    ln -sv gawk.1 /usr/share/man/man1/awk.1

    if $ADD_OPTIONNAL_DOCS; then
        mkdir -pv                                   /usr/share/doc/$OP_Gawk
        cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/$OP_Gawk
    fi
    cd /sources/
    rm -Rf $OP_Gawk #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Gawk "$TOOL_READY"
fi
###********************************



###OP_Findutils: 0.4SBU
if [ -n "$OP_Findutils" ] ;then
    echo -e "$START_JOB"
    echo $OP_Findutils
    tar -xf $OP_Findutils.tar.xz
    cd $OP_Findutils

    ./configure --prefix=/usr --localstatedir=/var/lib/locate
    make -s 
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    chown -R tester .
    su tester -c "PATH=$PATH make -s check"

    make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    cd /sources/
    rm -Rf $OP_Findutils #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Findutils "$TOOL_READY"
fi
###********************************



###OP_Groff: 0.2SBU
if [ -n "$OP_Groff" ] ;then
    echo -e "$START_JOB"
    echo $OP_Groff
    tar -xf $OP_Groff.tar.gz
    cd $OP_Groff

    PAGE=A4 ./configure --prefix=/usr
     make -s && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources/
    rm -Rf $OP_Groff #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Groff "$TOOL_READY"
fi
###********************************

sleep_before_complite

###OP_GRUB (NO_UEFI): 
if [ -n "$OP_GRUB" ] && ! UEFI;then
    echo -e "$START_JOB"
    echo $OP_GRUB
    tar -xf $OP_GRUB.tar.xz
    cd $OP_GRUB

    echo depends bli part_gpt > grub-core/extra_deps.lst
    ./configure --prefix=/usr          \
        --sysconfdir=/etc      \
        --disable-efiemu       \
        --disable-werror

    make -s && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions
   

    cd /sources/
    rm -Rf $OP_GRUB #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_GRUB "$TOOL_READY"
fi
###********************************

if [ -n "$OP_GRUB" ] && UEFI;then
    source /LFS/bash_sources/step5_grub_uefi_requirement.sh

    ###OP_GRUB (WITH_UEFI BLFS): 
    echo -e "$START_JOB"
    echo $OP_GRUB
    tar -xf $OP_GRUB.tar.xz
    cd $OP_GRUB

    mkdir -pv /usr/share/fonts/unifont &&
    gunzip -c ../unifont-15.1.04.pcf.gz > /usr/share/fonts/unifont/unifont.pcf
    unset {C,CPP,CXX,LD}FLAGS

    echo depends bli part_gpt > grub-core/extra_deps.lst

    if [ "$CPU_SELECTED_ARCH" == "x86_64" ] && [ "$(uname -m)" == "i?86" ] ; then
        case $(uname -m) in i?86 )
        tar xf ../$OP_GCC.tar.xz
        mkdir $OP_GCC/build
        pushd $OP_GCC/build
            ../configure --prefix=$PWD/../../x86_64-gcc \
                        --target=x86_64-linux-gnu      \
                        --with-system-zlib             \
                        --enable-languages=c,c++       \
                        --with-ld=/usr/bin/ld
            make all-gcc
            make install-gcc
        popd
        export TARGET_CC=$PWD/x86_64-gcc/bin/x86_64-linux-gnu-gcc
        esac

        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED" 
    fi

    if [ "$(uname -m)" == "x86_64" ]
        ./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --disable-efiemu     \
            --enable-grub-mkfont \
            --with-platform=efi  \
            --target=x86_64      \
            --disable-werror     &&
        unset TARGET_CC
        make -s && make -s install

        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"   
    fi
    
    mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions

    cd /sources/
    rm -Rf $OP_GRUB #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_GRUB "$TOOL_READY"
fi
###********************************

sleep_before_complite

###OP_Gzip: 0.3 SBU
if [ -n "$OP_Gzip" ] ;then
    echo -e "$START_JOB"
    echo $OP_Gzip
    tar -xf $OP_Gzip.tar.xz
    cd $OP_Gzip

    ./configure --prefix=/usr

    make -s && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"


    cd /sources/
    rm -Rf $OP_Gzip #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Gzip "$TOOL_READY"
fi
###********************************



###OP_IPRoute: 0.1SBU
if [ -n "$OP_IPRoute" ] ;then
    echo -e "$START_JOB"
    echo $OP_IPRoute
    tar -xf $OP_IPRoute.tar.xz
    cd $OP_IPRoute

    sed -i /ARPD/d Makefile
    rm -fv man/man8/arpd.8
    make -s NETNS_RUN_DIR=/run/netns && mmake -s SBINDIR=/usr/sbin install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    mkdir -pv             /usr/share/doc/$OP_IPRoute
    cp -v COPYING README* /usr/share/doc/$OP_IPRoute

    cd /sources/
    rm -Rf $OP_IPRoute #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_IPRoute "$TOOL_READY"
fi
###********************************



###OP_Kbd: 0.1SBU
if [ -n "$OP_Kbd" ] ;then
    echo -e "$START_JOB"
    echo $OP_Kbd
    tar -xf $OP_Kbd.tar.xz
    cd $OP_Kbd

    patch -Np1 -i ../$OP_Kbd-backspace-1.patch
    sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
    sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
    ./configure --prefix=/usr --disable-vlock

    make -s && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    if $ADD_OPTIONNAL_DOCS; then
        cp -R -v docs/doc -T /usr/share/doc/$OP_Kbd
    fi

    cd /sources/
    rm -Rf $OP_Kbd #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Kbd "$TOOL_READY"
fi
###********************************

sleep_before_complite

###OP_Libpipeline: 0.1SBU
if [ -n "$OP_Libpipeline" ] ;then
    echo -e "$START_JOB"
    echo $OP_Libpipeline
    tar -xf $OP_Libpipeline.tar.gz
    cd $OP_Libpipeline

   ./configure --prefix=/usr

    make -s && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources/
    rm -Rf $OP_Libpipeline #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Libpipeline "$TOOL_READY"
fi
###********************************



###OP_Make: 0.5SBU
if [ -n "$OP_Make" ] ;then
    echo -e "$START_JOB"
    echo $OP_Make
    tar -xf $OP_Make.tar.gz
    cd $OP_Make

   ./configure --prefix=/usr
    make -s && make -s check 
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    chown -R tester .
    su tester -c "PATH=$PATH make -s check"
    make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources/
    rm -Rf $OP_Make #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Make "$TOOL_READY"
fi
###********************************



###OP_Patch: 0.1SBU
if [ -n "$OP_Patch" ] ;then
    echo -e "$START_JOB"
    echo $OP_Patch
    tar -xf $OP_Patch.tar.xz
    cd $OP_Patch

    ./configure --prefix=/usr

    make -s && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources/
    rm -Rf $OP_Patch #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Patch "$TOOL_READY"
fi
###********************************



###OP_Tar: 0.5SBU
if [ -n "$OP_Tar" ] ;then
    echo -e "$START_JOB"
    echo $OP_Tar
    tar -xf $OP_Tar.tar.xz
    cd $OP_Tar

    FORCE_UNSAFE_CONFIGURE=1  \
    ./configure --prefix=/usr

    make -s && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    make -C doc install-html docdir=/usr/share/doc/$OP_Tar

    cd /sources/
    rm -Rf $OP_Tar #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Tar "$TOOL_READY"
fi
###********************************

sleep_before_complite

###Texinfo: 0.3SBU
if [ -n "$Texinfo" ] ;then
    echo -e "$START_JOB"
    echo $Texinfo
    tar -xf $Texinfo.tar.xz
    cd $Texinfo

    ./configure --prefix=/usr

    make -s && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    make -s TEXMF=/usr/share/texmf install-tex
    pushd /usr/share/info
        rm -v dir
        for f in *
            do install-info $f dir 2>/dev/null
        done
    popd

    cd /sources/
    rm -Rf $Texinfo #rm extracted pkg
    echo -e "$DONE" 
    echo -e $Texinfo "$TOOL_READY"
fi
###********************************



###OP_Vim: 2.5SBU
if [ -n "$OP_Vim" ] ;then
    echo -e "$START_JOB"
    echo $OP_Vim
    tar -xf $OP_Vim.tar.gz
    cd $OP_Vim

    echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
    ./configure --prefix=/usr
    make -s
    chown -R tester .
    su tester -c "TERM=xterm-256color LANG=en_US.UTF-8 make -sj1 test" \
   &> vim-test.log

    grep 'ALL DONE' vim-test.log

    make -s install
    ln -sv vim /usr/bin/vi
    for L in  /usr/share/man/{,*/}man1/vim.1; do
        ln -sv vim.1 $(dirname $L)/vi.1
    done
    ln -sv ../vim/vim91/doc /usr/share/doc/$OP_Vim

    cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF

    cd /sources/
    rm -Rf $OP_Vim #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Vim "$TOOL_READY"
fi
###********************************



###OP_MarkupSafe: 0.1SBU
if [ -n "$OP_MarkupSafe" ] ;then
    echo -e "$START_JOB"
    echo $OP_MarkupSafe
    tar -xf $OP_MarkupSafe.tar.gz
    cd $OP_MarkupSafe

    pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
    pip3 install --no-index --no-user --find-links dist Markupsafe

    cd /sources/
    rm -Rf $OP_MarkupSafe #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_MarkupSafe "$TOOL_READY"
fi
###********************************

sleep_before_complite

###OP_Jinja: 0.1SBU
if [ -n "$OP_Jinja" ] ;then
    echo -e "$START_JOB"
    echo $OP_Jinja
    tar -xf $OP_Jinja.tar.gz
    cd $OP_Jinja

    pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
    pip3 install --no-index --no-user --find-links dist Jinja2

    cd /sources/
    rm -Rf $OP_Jinja #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Jinja "$TOOL_READY"
fi
###********************************



###OP_Udev: 0.2SBU
if [ -n "$OP_Udev" ] ;then
    echo -e "$START_JOB"
    echo $OP_Udev
    tar -xf $OP_Udev.tar.gz
    cd $OP_Udev

    sed -i -e 's/GROUP="render"/GROUP="video"/' \
       -e 's/GROUP="sgx", //' rules.d/50-udev-default.rules.in

    sed '/systemd-sysctl/s/^/#/' -i rules.d/99-systemd.rules.in
    sed '/NETWORK_DIRS/s/systemd/udev/' -i src/basic/path-lookup.h

    mkdir -p build
    cd       build

    meson setup \
        --prefix=/usr                 \
        --buildtype=release           \
        -Dmode=release                \
        -Ddev-kvm-mode=0660           \
        -Dlink-udev-shared=false      \
        -Dlogind=false                \
        -Dvconsole=false              \
        ..

    export udev_helpers=$(grep "'name' :" ../src/udev/meson.build | \
                      awk '{print $3}' | tr -d ",'" | grep -v 'udevadm')
    
    ninja udevadm systemd-hwdb                                           \
      $(ninja -n | grep -Eo '(src/(lib)?udev|rules.d|hwdb.d)/[^ ]*') \
      $(realpath libudev.so --relative-to .)                         \
      $udev_helpers

    install -vm755 -d {/usr/lib,/etc}/udev/{hwdb.d,rules.d,network}
    install -vm755 -d /usr/{lib,share}/pkgconfig
    install -vm755 udevadm                             /usr/bin/
    install -vm755 systemd-hwdb                        /usr/bin/udev-hwdb
    ln      -svfn  ../bin/udevadm                      /usr/sbin/udevd
    cp      -av    libudev.so{,*[0-9]}                 /usr/lib/
    install -vm644 ../src/libudev/libudev.h            /usr/include/
    install -vm644 src/libudev/*.pc                    /usr/lib/pkgconfig/
    install -vm644 src/udev/*.pc                       /usr/share/pkgconfig/
    install -vm644 ../src/udev/udev.conf               /etc/udev/
    install -vm644 rules.d/* ../rules.d/README         /usr/lib/udev/rules.d/
    install -vm644 $(find ../rules.d/*.rules \
                        -not -name '*power-switch*') /usr/lib/udev/rules.d/
    install -vm644 hwdb.d/*  ../hwdb.d/{*.hwdb,README} /usr/lib/udev/hwdb.d/
    install -vm755 $udev_helpers                       /usr/lib/udev
    install -vm644 ../network/99-default.link          /usr/lib/udev/network

    tar -xvf ../../udev-lfs-20230818.tar.xz
    make -f udev-lfs-20230818/Makefile.lfs install


    tar -xf ../../systemd-man-pages-255.tar.xz                            \
    --no-same-owner --strip-components=1                              \
    -C /usr/share/man --wildcards '*/udev*' '*/libudev*'              \
                                  '*/systemd.link.5'                  \
                                  '*/systemd-'{hwdb,udevd.service}.8

    sed 's|systemd/network|udev/network|'                                 \
        /usr/share/man/man5/systemd.link.5                                \
    > /usr/share/man/man5/udev.link.5

    sed 's/systemd\(\\\?-\)/udev\1/' /usr/share/man/man8/systemd-hwdb.8   \
                                > /usr/share/man/man8/udev-hwdb.8

    sed 's|lib.*udevd|sbin/udevd|'                                        \
        /usr/share/man/man8/systemd-udevd.service.8                       \
    > /usr/share/man/man8/udevd.8

    rm /usr/share/man/man*/systemd*

    unset udev_helpers
    udev-hwdb update

    cd /sources/
    rm -Rf $OP_Udev #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Udev "$TOOL_READY"
fi
###********************************



###OP_Man_DB: 0.1SBU
if [ -n "$OP_Man_DB" ] ;then
    echo -e "$START_JOB"
    echo $OP_Man_DB
    tar -xf $OP_Man_DB.tar.xz
    cd $OP_Man_DB

    ./configure --prefix=/usr                         \
            --docdir=/usr/share/doc/man-db-2.12.0 \
            --sysconfdir=/etc                     \
            --disable-setuid                      \
            --enable-cache-owner=bin              \
            --with-browser=/usr/bin/lynx          \
            --with-vgrind=/usr/bin/vgrind         \
            --with-grap=/usr/bin/grap             \
            --with-systemdtmpfilesdir=            \
            --with-systemdsystemunitdir=
    make -s && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources/
    rm -Rf $OP_Man_DB #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Man_DB "$TOOL_READY"
fi
###********************************



###OP_Procps_ng: 0.1SBU
if [ -n "$OP_Procps_ng" ] ;then
    echo -e "$START_JOB"
    echo $OP_Procps_ng
    tar -xf $OP_Procps_ng.tar.xz
    cd $OP_Procps_ng

    if $STATIC_ONLY;then
        ./configure --prefix=/usr                 \
                    --docdir=/usr/share/doc/$OP_Procps_ng \
                    --enable-static \
                    --disable-shared \
                    --disable-kill
    else
        ./configure --prefix=/usr                           \
                    --docdir=/usr/share/doc/$OP_Procps_ng \
                    --disable-static                        \
                    --disable-kill
    fi
    
    make -s && make -ks check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources/
    rm -Rf $OP_Procps_ng #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Procps_ng "$TOOL_READY"
fi
###********************************



###OP_Util_linux: 0.5SBU
if [ -n "$OP_Util_linux" ] ;then
    echo -e "$START_JOB"
    echo $OP_Util_linux
    tar -xf $OP_Util_linux.tar.xz
    cd $OP_Util_linux

    sed -i '/test_mkfds/s/^/#/' tests/helpers/Makemodule.am

    if $STATIC_ONLY;then
        ./configure --bindir=/usr/bin    \
            --libdir=/usr/lib    \
            --runstatedir=/run   \
            --sbindir=/usr/sbin  \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --enable-static \
            --disable-shared \
            --without-python     \
            --without-systemd    \
            --without-systemdsystemunitdir        \
            ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --docdir=/usr/share/doc/$OP_Util_linux
    else
        ./configure --bindir=/usr/bin    \
            --libdir=/usr/lib    \
            --runstatedir=/run   \
            --sbindir=/usr/sbin  \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python     \
            --without-systemd    \
            --without-systemdsystemunitdir        \
            ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --docdir=/usr/share/doc/$OP_Util_linux
    fi
    
    make -s 
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    if DO_OPTIONNAL_TESTS; then
        chown -R tester .
        su tester -c "make -k check"
    fi  

    make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"



    cd /sources/
    rm -Rf $OP_Util_linux #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Util_linux "$TOOL_READY"
fi
###********************************

sleep_before_complite

###OP_E2fsprogs: 0.4SBU
if [ -n "$OP_E2fsprogs" ] ;then
    echo -e "$START_JOB"
    echo $OP_E2fsprogs
    tar -xf $OP_E2fsprogs.tar.gz
    cd $OP_E2fsprogs

    mkdir -v build
    cd       build
   ../configure --prefix=/usr           \
             --sysconfdir=/etc       \
             --enable-elf-shlibs     \
             --disable-libblkid      \
             --disable-libuuid       \
             --disable-uuidd         \
             --disable-fsck
    
    make -s && make -s check && make -s install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    rm -fv /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
    gunzip -v /usr/share/info/libext2fs.info.gz
    install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info


    makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
    install -v -m644 doc/com_err.info /usr/share/info
    install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info

    if $ADD_OPTIONNAL_DOCS; then
        makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
        install -v -m644 doc/com_err.info /usr/share/info
        install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
    fi

    cd /sources/
    rm -Rf $OP_E2fsprogs #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_E2fsprogs "$TOOL_READY"
fi
###********************************

sleep_before_complite

###OP_Sysklogd: 0.1SBU
if [ -n "$OP_Sysklogd" ] ;then
    echo -e "$START_JOB"
    echo $OP_Sysklogd
    tar -xf $OP_Sysklogd.tar.gz
    cd $OP_Sysklogd

    sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
    sed -i 's/union wait/int/' syslogd.c
    make -s && make -s BINDIR=/sbin install
     if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cat > /etc/syslog.conf << "EOF"
# Begin /etc/syslog.confcat > /etc/syslog.conf << "EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# End /etc/syslog.conf
EOF

    cd /sources/
    rm -Rf $OP_Sysklogd #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Sysklogd "$TOOL_READY"
fi
###********************************



###OP_Sysvinit:
if [ -n "$OP_Sysvinit" ] ;then
    echo -e "$START_JOB"
    echo $OP_Sysvinit
    tar -xf $OP_Sysvinit.tar.xz
    cd $OP_Sysvinit

    patch -Np1 -i ../$OP_Sysvinit-consolidated-1.patch
    make -s && make -s install
     if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources/
    rm -Rf $OP_Sysvinit #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Sysvinit "$TOOL_READY"
fi
###********************************



popd
    STEP4_ENDED=true
    echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$END_STEP5${STEP}*       #
    ############################################### ${NO_STYLE}
    "


#save to SHARED_FILE
SAVE="

#${STEP}
###############################################
#   *${NO_STYLE}$START_STEP5${STEP}*     #
############################################### ${NO_STYLE}

### copied vars to other user
export STEP5_ENDED=$STEP5_ENDED

"
echo "$SAVE" >> $SHARED_FILE

if ! $KEEP_DEBUG_FILES; then
    source /LFS/bash_sources/step6.sh
fi

source /LFS/bash_sources/step7.sh