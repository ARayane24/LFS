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

if [ -z "$START_STEP5" ]; then
  exit 1
fi

###OP_Man_pages: 0.1SBU
if [ -n "$OP_Man_pages" ] ;then
    echo -e "$START_JOB"
    echo $OP_Man_pages
    tar -xf $OP_Man_pages.tar.xz
    cd $OP_Man_pages
   
    rm -v man3/crypt*
    make prefix=/usr install
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
    make 
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi

    make check

    touch /etc/ld.so.conf
    sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile

    make install
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

    make localedata/install-locales
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
    sed -i 's@\(ln -f \)$(PREFIX)/bin/@\1@' Makefile
    sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

    make -f Makefile-libbz2_so && make clean && make && make PREFIX=/usr install
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

    make prefix=/usr
     if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    make check

    make prefix=/usr install
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
        make && make install
    else
        ./configure --prefix=/usr    \
                --disable-static \
                --with-curses    \
                --docdir=/usr/share/doc/$OP_Readline
        make SHLIB_LIBS="-lncursesw" && make SHLIB_LIBS="-lncursesw" install
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
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    make test 

    make install
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
    tar -xf $OP_Tcl-src.tar.gz
    cd $OP_Tcl

    SRCDIR=$(pwd)
    cd unix
    ./configure --prefix=/usr           \
                --mandir=/usr/share/man

    make
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


    make test

    make install
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
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    make test

    make install
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
    make check
    
    make install
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
                --docdir=/usr/share/doc/$OP_Pkgconf\
                --enable-static \
                --disable-shared 
    else
        ./configure --prefix=/usr \
            --docdir=/usr/share/doc/$OP_Pkgconf\
            --disable-static
    fi  
    make && make install
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

    make tooldir=/usr
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    make -ks check
    grep '^FAIL:' $(find -name '*.log')

    make tooldir=/usr install
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
       MY_CONFIG_PARAM="\ --host=none-linux-gnu" #don't optimize for the host
    fi

    if $STATIC_ONLY;then
        $CPU_ARCH_IS_32BIT_X86 ./configure --prefix=/usr \
                                            --enable-cxx     \
                                            --docdir=/usr/share/doc/$OP_GMP\
                                            --enable-static \
                                            --disable-shared $MY_CONFIG_PARAM
    else
        $CPU_ARCH_IS_32BIT_X86 ./configure --prefix=/usr \
                                            --enable-cxx     \
                                            --docdir=/usr/share/doc/$OP_GMP \
                                            --disable-static $MY_CONFIG_PARAM
    fi
    make && make html
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    make check 2>&1 | tee gmp-check-log
    awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log
    make install
    make install-html

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
    make && make html
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    make check
    make install && make install-html
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

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
    make && make html
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    make check 
    make install && make install-html
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

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
    make && make install
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
    make prefix=/usr lib=lib
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    make test

    make prefix=/usr lib=lib install
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
        ./configure --prefix=/usr                \
                    --enable-hashes=strong,glibc \
                    --enable-obsolete-api=no     \
                    --disable-static             \
                    --disable-failure-tokens
    fi
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
    rm -Rf $OP_Libxcrypt #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Libxcrypt "$TOOL_READY"
fi
###********************************

export USING_CRACKLIB=false

###OP_Shadow: 0.1SBU
if [ -n "$OP_Shadow" ] ;then
    echo -e "$START_JOB"
    echo $OP_Shadow
    tar -xf $OP_Shadow.tar.xz
    cd $OP_Shadow

    OPTIONNAL_HIGH_SECURITY=""
    if $USING_CRACKLIB; then
        OPTIONNAL_HIGH_SECURITY=" \ --with-libcrack"
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
            --with-group-name-max-length=32
            $OPTIONNAL_HIGH_SECURITY
    else
       ./configure --sysconfdir=/etc   \
            --disable-static    \
            --with-{b,yes}crypt \
            --without-libbsd    \
            --with-group-name-max-length=32
            $OPTIONNAL_HIGH_SECURITY
    fi
    make && make exec_prefix=/usr install && make -C man install-man
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
    make && ulimit -s 32768
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    chown -R tester .
    su tester -c "PATH=$PATH make -k check -j$(nproc)"
    ../contrib/test_summary

    make install
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
    echo -e "\n$REAL_OUTPUT"
    # Check the program interpreter using readelf and grep for ld-linux
    output=$(readelf -l a.out | grep ld-linux)
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

    make && make DESTDIR=$PWD/dest install
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
    make && make html
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    chown -R tester .
    su tester -c "PATH=$PATH make check"
    
    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

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

    ./configure --prefix=/usr --docdir=/usr/share/doc/$OP_Bison
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
    make
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

    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    popd
    exec /usr/bin/bash --login -c "
    rm -Rf \"$OP_Bash\"; 
    echo -e \"$DONE\";
    echo -e \"$OP_Bash $TOOL_READY\";
    bash ./step5.2.sh
"
fi
