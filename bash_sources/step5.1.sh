#!/bin/bash
# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing


pushd /sources/
#***************************************************************************#
   echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$START_STEP5${STEP}*   #
    ############################################### ${NO_STYLE}
    "


#extract_all_files
echo -e "$START_EXTRACTION"
extract_tar_files /sources "$OP_Man_pages      $OP_Iana_Etc                $OP_Glibc               $OP_Zlib        $OP_Bzip            $OP_Xz                  $OP_Zstd                $OP_Lz4                 $OP_File                $OP_Readline " &
extract_tar_files /sources "$OR_M4             $OP_Bc                      $OP_Flex                $OP_Tcl-src     $OP_Expect          $OP_DejaGNU             $OP_Pkgconf             $OP_Binutils            $OP_GMP                 $OP_MPFR " &
extract_tar_files /sources "$OP_MPC            $OP_Attr                    $OP_Acl                 $OP_Libcap      $OP_Libxcrypt       $OP_Shadow              $OP_GCC                 $OP_Ncurses             $OP_Sed                 $OP_Psmisc " &
extract_tar_files /sources "$OP_Gettext        $OP_Bison                   $OP_Grep                $OP_Bash        $OP_Libtool         $OP_GDBM                $OP_Gperf               $OP_Expat               $OP_Inetutils           $OP_Less " &
extract_tar_files /sources "$OP_Perl           $OP_XML                     $OP_Intltool            $OP_Autoconf    $OP_Automake        $OP_OpenSSL             $OP_Kmod                                        $OP_Libffi              $OP_Python " &
extract_tar_files /sources "                   $OP_Flit_Core               $OP_Wheel               $OP_Setuptools  $OP_Ninja           $OP_Meson               $OP_Coreutils           $OP_Check               $OP_Diffutils           $OP_Gawk " &
extract_tar_files /sources "$OP_Findutils      $OP_Groff                   $OP_GRUB                $OP_Which       $OP_Libping         $OP_Libping_patch       $OP_Harfbuzz            $OP_Freetype            $OP_Freetype_docs       $OP_Popt " &
extract_tar_files /sources "$OP_Mandoc         $OP_Efivar                  $OP_Efibootmgr          $OP_Gzip        $OP_IPRoute         $OP_Kbd                 $OP_Libpipeline         $OP_Make                $OP_Patch               $OP_Tar " &
extract_tar_files /sources "$Texinfo           $OP_Vim                     $OP_MarkupSafe          $OP_Jinja       $OP_Udev            $OP_Man_DB              $OP_Procps_ng           $OP_Util_linux          $OP_E2fsprogs           $OP_Sysklogd " &
extract_tar_files /sources "$OP_Sysvinit       $SC_LFS_Bootscripts         $SC_BLFS_Bootscripts    $OP_CrackLib    $OP_Udev            $OP_CrackLib_words      $OP_CrackLib_jhon_psw   $OP_CrackLib_cain_psw   $OP_CrackLib_500_psw    $OP_CrackLib_twitter_psw " &
extract_tar_files /sources "$OP_dhcpcd         $OP_dosfstools          " 
wait
echo -e "$DONE"



###OP_Man_pages: 0.1SBU
if [ -n "$OP_Man_pages" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Man_pages
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

debug_mode true

###OP_Iana_Etc: 0.1SBU
if [ -n "$OP_Iana_Etc" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Iana_Etc
    cd $OP_Iana_Etc

    cp services protocols /etc

    cd /sources/
    rm -Rf $OP_Iana_Etc #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Iana_Etc "$TOOL_READY"
fi
###********************************

debug_mode true

###OP_Glibc: 12SBU
if [ -n "$OP_Glibc" ] ;then
    echo -e "$START_JOB" " 12 SBU"
    echo $OP_Glibc
    cd $OP_Glibc

    patch -Np1 -i ../$OP_Glibc-fhs-1.patch
    mkdir -v build
    cd       build
    echo "rootsbindir=/usr/sbin" > configparms
    ../configure --prefix=/usr                        \
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

    # add locals 
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


cat > /etc/nsswitch.conf <<EOF
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

    for tz in etcetera southamerica northamerica europe africa antarctica asia australasia backward; do
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
debug_mode true


###OP_Zlib: 0.1SBU
if [ -n "$OP_Zlib" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Zlib
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

debug_mode true

###OP_Bzip: 0.1SBU
if [ -n "$OP_Bzip" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Bzip
    cd $OP_Bzip

    patch -Np1 -i ../$OP_Bzip-install_docs-1.patch
    sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
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

debug_mode true

###OP_Xz:0.1SBU
if [ -n "$OP_Xz" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Xz
    cd $OP_Xz

    if $STATIC_ONLY;then
        ./configure --prefix=/usr    \
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

debug_mode true

###OP_Lz4:0.1SBU
if [ -n "$OP_Lz4" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Lz4
    cd $OP_Lz4

    make BUILD_STATIC=no PREFIX=/usr
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    make -j1 check

    make BUILD_STATIC=no PREFIX=/usr install
     if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources/
    rm -Rf $OP_Lz4 #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Lz4 "$TOOL_READY"
fi
###********************************

debug_mode true

###OP_Zstd:0.4SBU
if [ -n "$OP_Zstd" ] ;then
    echo -e "$START_JOB" " 0.4 SBU"
    echo $OP_Zstd
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

debug_mode true

###OP_File:0.1SBU
if [ -n "$OP_File" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_File
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

debug_mode true

###OP_Readline:0.1SBU
if [ -n "$OP_Readline" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Readline
    cd $OP_Readline

    sed -i '/MV.*old/d' Makefile.in
    sed -i '/{OLDSUFF}/c:' support/shlib-install

    sed -i 's/-Wl,-rpath,[^ ]*//' support/shobj-conf

    if $STATIC_ONLY;then
        ./configure --prefix=/usr    \
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

debug_mode true

###OR_M4: 0.3SBU
if [ -n "$OR_M4" ] ;then
    echo -e "$START_JOB" " 0.3 SBU"
    echo $OR_M4
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

debug_mode true

###OP_Bc: 0.1SBU
if [ -n "$OP_Bc" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Bc
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

debug_mode true

###OP_Flex: 0.1SBU
if [ -n "$OP_Flex" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Flex
    cd $OP_Flex

   if $STATIC_ONLY;then
        ./configure --prefix=/usr \
                --docdir=/usr/share/doc/$OP_Flex \
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

debug_mode true

###OP_Tcl: 2.7SBU
if [ -n "$OP_Tcl" ] ;then
    echo -e "$START_JOB" " 2.7 SBU"
    echo $OP_Tcl
    cd $OP_Tcl

    SRCDIR=$(pwd)
    cd unix
    ./configure --prefix=/usr \
                --mandir=/usr/share/man \
                --disable-rpath

    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    make
    sed -e "s|$SRCDIR/unix|/usr/lib|" \
        -e "s|$SRCDIR|/usr/include|" \
        -i tclConfig.sh
    
    sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.7|/usr/lib/tdbc1.1.7|"  \
        -e "s|$SRCDIR/pkgs/tdbc1.1.7/generic|/usr/include|"     \
        -e "s|$SRCDIR/pkgs/tdbc1.1.7/library|/usr/lib/tcl8.6|"  \
        -e "s|$SRCDIR/pkgs/tdbc1.1.7|/usr/include|"             \
        -i pkgs/tdbc1.1.7/tdbcConfig.sh
    
    sed -e "s|$SRCDIR/unix/pkgs/itcl4.2.4|/usr/lib/itcl4.2.4|"  \
        -e "s|$SRCDIR/pkgs/itcl4.2.4/generic|/usr/include|"     \
        -e "s|$SRCDIR/pkgs/itcl4.2.4|/usr/include|"             \
        -i pkgs/itcl4.2.4/itclConfig.sh
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
        mkdir -v -p /usr/share/doc/tcl-8.6.14
        cp -v -r ./html/* /usr/share/doc/tcl-8.6.14
    fi

    cd /sources/
    rm -Rf $OP_Tcl #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Tcl "$TOOL_READY"
fi
###********************************

debug_mode true

###OP_Expect: 0.2SBU
if [ -n "$OP_Expect" ] ;then
    echo -e "$START_JOB" " 0.2 SBU"
    echo $OP_Expect
    cd $OP_Expect

    python3 -c 'from pty import spawn; spawn(["echo", "ok"])'
    
    patch -Np1 -i ../expect-5.45.4-gcc14-1.patch

    ./configure --prefix=/usr               \
                --with-tcl=/usr/lib         \
                --enable-shared             \
                --disable-rpath             \
                --mandir=/usr/share/man     \
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

debug_mode true

###OP_DejaGNU: 0.1SBU
if [ -n "$OP_DejaGNU" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_DejaGNU
    cd $OP_DejaGNU

    mkdir -v build
    cd       build

    ../configure --prefix=/usr
    makeinfo --html --no-split -o doc/dejagnu.html ../doc/dejagnu.texi
    makeinfo --plaintext -o doc/dejagnu.txt ../doc/dejagnu.texi

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

debug_mode true

###OP_Pkgconf: 0.1SBU
if [ -n "$OP_Pkgconf" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Pkgconf
    cd $OP_Pkgconf

     if $STATIC_ONLY;then
        ./configure --prefix=/usr \
                --docdir=/usr/share/doc/$OP_Pkgconf \
                --disable-shared 
    else
        ./configure --prefix=/usr               \
            --docdir=/usr/share/doc/$OP_Pkgconf \
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
debug_mode true

###OP_Binutils: 2.2SBU
if [ -n "$OP_Binutils" ] ;then
    echo -e "$START_JOB" " 2.2 SBU"
    echo $OP_Binutils
    cd $OP_Binutils

    mkdir -v build
    cd       build

    ../configure --prefix=/usr      \
                --sysconfdir=/etc   \
                --enable-gold       \
                --enable-ld=default \
                --enable-plugins    \
                --enable-shared     \
                --disable-werror    \
                --enable-64-bit-bfd \
                --enable-new-dtags  \
                --with-system-zlib  \
                --enable-default-hash-style=gnu

    make tooldir=/usr
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    make -k check
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

debug_mode true

###OP_GMP: 0.3SBU
if [ -n "$OP_GMP" ] ;then
    echo -e "$START_JOB" " 0.3 SBU"
    echo $OP_GMP
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
                                            --docdir=/usr/share/doc/$OP_GMP \
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

    make install && make install-html
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources/
    rm -Rf $OP_GMP #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_GMP "$TOOL_READY"
fi
###********************************

debug_mode true

###OP_MPFR: 0.3SBU
if [ -n "$OP_MPFR" ] ;then
    echo -e "$START_JOB" " 0.2 SBU"
    echo $OP_MPFR
    cd $OP_MPFR

     if $STATIC_ONLY;then
        ./configure --prefix=/usr \
                --enable-thread-safe \
                --docdir=/usr/share/doc/$OP_MPFR \
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

debug_mode true

###OP_MPC: 0.1SBU
if [ -n "$OP_MPC" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_MPC
    cd $OP_MPC

     if $STATIC_ONLY;then
        ./configure --prefix=/usr \
                --docdir=/usr/share/doc/$OP_MPC \
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

debug_mode true

###OP_Attr: 0.1SBU
if [ -n "$OP_Attr" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Attr
    cd $OP_Attr

     if $STATIC_ONLY;then
        ./configure --prefix=/usr \
                --sysconfdir=/etc \
                --docdir=/usr/share/doc/$OP_Attr \
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

debug_mode true

###OP_Acl part 1: 0.1SBU
if [ -n "$OP_Acl" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Acl
    cd $OP_Acl

    if $STATIC_ONLY;then
        ./configure --prefix=/usr         \
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
    rm -Rf $OP_Acl #rm extracted pkg( run make check after the Coreutils package has been built.)
    echo -e "$DONE" 
    echo -e $OP_Acl "$TOOL_READY"
fi
###********************************

debug_mode true

###OP_Libcap: 0.1SBU
if [ -n "$OP_Libcap" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Libcap
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

debug_mode true

###OP_Libxcrypt: 0.1SBU
if [ -n "$OP_Libxcrypt" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Libxcrypt
    cd $OP_Libxcrypt

    if $STATIC_ONLY;then
        ./configure --prefix=/usr                \
                    --enable-hashes=strong,glibc \
                    --enable-obsolete-api=no     \
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

debug_mode true

###OP_Shadow: 0.1SBU
if [ -n "$OP_Shadow" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Shadow
    cd $OP_Shadow

    sed -i 's/groups$(EXEEXT) //' src/Makefile.in
    find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
    find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
    find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;

    sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD YESCRYPT:' \
        -e 's:/var/spool/mail:/var/mail:'                   \
        -e '/PATH=/{s@/sbin:@@;s@/bin:@@}'                  \
        -i etc/login.defs

    touch /usr/bin/passwd
    if $STATIC_ONLY;then
        ./configure --sysconfdir=/etc   \
            --disable-shared \
            --with-{b,yes}crypt \
            --without-libbsd    \
            --with-group-name-max-length=32
    else
       ./configure --sysconfdir=/etc   \
            --disable-static    \
            --with-{b,yes}crypt \
            --without-libbsd    \
            --with-group-name-max-length=32
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

    passwd $My_ROOT #change password of Root user

    cd /sources/
    rm -Rf $OP_Shadow #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Shadow "$TOOL_READY"
fi
###********************************


sleep_before_complite
debug_mode true


###OP_GCC: 42SBU
if [ -n "$OP_GCC" ] ;then
    echo -e "$START_JOB" " 42 SBU"
    echo $OP_GCC
    cd $OP_GCC

    case $(uname -m) in
    x86_64)
        sed -e '/m64=/s/lib64/lib/'  -i.orig gcc/config/i386/t-linux64
    ;;
    esac

    mkdir -v build
    cd       build

    ../configure --prefix=/usr            \
                LD=ld                    \
                --enable-languages=c,c++ \
                --enable-default-pie     \
                --enable-default-ssp     \
                --enable-host-pie        \
                --disable-multilib       \
                --disable-bootstrap      \
                --disable-fixincludes    \
                --with-system-zlib
    make && ulimit -s -H unlimited
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    sed -e '/cpython/d'               -i ../gcc/testsuite/gcc.dg/plugin/plugin.exp
    sed -e 's/no-pic /&-no-pie /'     -i ../gcc/testsuite/gcc.target/i386/pr113689-1.c
    sed -e 's/300000/(1|300000)/'     -i ../libgomp/testsuite/libgomp.c-c++-common/pr109062.c
    sed -e 's/{ target nonpic } //' \
        -e '/GOTPCREL/d'              -i ../gcc/testsuite/gcc.target/i386/fentryname3.c

    chown -R tester .
    su tester -c "PATH=$PATH make -k check"
    ../contrib/test_summary

    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    chown -v -R root:root \
    /usr/lib/gcc/$(gcc -dumpmachine)/$GCC_V/include{,-fixed}

    ln -svr /usr/bin/cpp /usr/lib

    ln -sv gcc.1 /usr/share/man/man1/cc.1 
    ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/$GCC_V/liblto_plugin.so /usr/lib/bfd-plugins/
    
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

    grep -E -o '/usr/lib.*/S?crt[1in].*succeeded' dummy.log
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
debug_mode true


###OP_Ncurses: 0.2SBU
if [ -n "$OP_Ncurses" ] ;then
    echo -e "$START_JOB" " 0.2SBU"
    echo $OP_Ncurses
    cd $OP_Ncurses
    
    ./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --with-cxx-shared       \
            --enable-pc-files       \
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

    if $ADD_OPTIONNAL_DOCS; then
        cp -v -R doc -T /usr/share/doc/$OP_Ncurses
    fi

    cd /sources/
    rm -Rf $OP_Ncurses #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Ncurses "$TOOL_READY"
fi
###********************************

debug_mode true

###OP_Sed: 0.3SBU
if [ -n "$OP_Sed" ] ;then
    echo -e "$START_JOB" " 0.3 SBU"
    echo $OP_Sed
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

debug_mode true

###OP_Psmisc: 0.1SBU
if [ -n "$OP_Psmisc" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Psmisc
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

debug_mode true

###OP_Gettext: 1.4SBU
if [ -n "$OP_Gettext" ] ;then
    echo -e "$START_JOB" " 1.4 SBU"
    echo $OP_Gettext
    cd $OP_Gettext

    if $STATIC_ONLY;then
        ./configure --prefix=/usr \
                --docdir=/usr/share/doc/$OP_Gettext \
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

debug_mode true

###OP_Bison: 2.3SBU
if [ -n "$OP_Bison" ] ;then
    echo -e "$START_JOB" " 2.3 SBU"
    echo $OP_Bison
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
debug_mode true

###OP_Grep: 0.4SBU
if [ -n "$OP_Grep" ] ;then
    echo -e "$START_JOB" " 0.4 SBU"
    echo $OP_Grep
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

debug_mode true

###OP_Bash: 1.2SBU
if [ -n "$OP_Bash" ] ;then
    echo -e "$START_JOB"
    echo $OP_Bash
    cd $OP_Bash

    ./configure --prefix=/usr         \
            --without-bash-malloc     \
            --with-installed-readline \
            bash_cv_strtold_broken=no \
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
    bash ./step5.2.sh"
fi
