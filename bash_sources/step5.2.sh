#!/bin/bash
# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

cd /LFS/bash_sources
source /.bashrc

source ./terminal_params/_util_methodes.sh
source ./terminal_params/_pakages_names.sh

pushd /sources/
###********************************

sleep_before_complite

###OP_Libtool: 0.6SBU
if [ -n "$OP_Libtool" ] ;then
    echo -e "$START_JOB" " 0.6 SBU"
    echo $OP_Libtool
    cd $OP_Libtool

   ./configure --prefix=/usr
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    make -k check    

    make install
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
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_GDBM
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
    rm -Rf $OP_GDBM #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_GDBM "$TOOL_READY"
fi
###********************************



###OP_Gperf: 0.1SBU
if [ -n "$OP_Gperf" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Gperf
    cd $OP_Gperf

    ./configure --prefix=/usr --docdir=/usr/share/doc/$OP_Gperf
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    make -j1 check

    make install
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
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Expat
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
    echo -e "$START_JOB" " 0.2 SBU"
    echo $OP_Inetutils
    cd $OP_Inetutils

    sed -i 's/def HAVE_TERMCAP_TGETENT/ 1/' telnet/telnet.c

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
    
    mv -v /usr/{,s}bin/ifconfig

    cd /sources/
    rm -Rf $OP_Inetutils #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Inetutils "$TOOL_READY"
fi
###********************************



###OP_Less: 0.1SBU
if [ -n "$OP_Less" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Less
    cd $OP_Less

    ./configure --prefix=/usr --sysconfdir=/etc
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
    rm -Rf $OP_Less #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Less "$TOOL_READY"
fi
###********************************



###OP_Perl: 1.5 SBU
if [ -n "$OP_Perl" ] ;then
    echo -e "$START_JOB" " 1.5 SBU"
    echo $OP_Perl
    cd $OP_Perl

    export BUILD_ZLIB=False
    export BUILD_BZIP2=0

    sh Configure -des                                          \
             -D prefix=/usr                                \
             -D vendorprefix=/usr                          \
             -D privlib=/usr/lib/perl5/$Perl_V/core_perl      \
             -D archlib=/usr/lib/perl5/$Perl_V/core_perl      \
             -D sitelib=/usr/lib/perl5/$Perl_V/site_perl      \
             -D sitearch=/usr/lib/perl5/$Perl_V/site_perl     \
             -D vendorlib=/usr/lib/perl5/$Perl_V/vendor_perl  \
             -D vendorarch=/usr/lib/perl5/$Perl_V/vendor_perl \
             -D man1dir=/usr/share/man/man1                \
             -D man3dir=/usr/share/man/man3                \
             -D pager="/usr/bin/less -isR"                 \
             -D useshrplib                                 \
             -D usethreads

    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    TEST_JOBS=$(nproc) make test_harness

    make install
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
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_XML
    cd $OP_XML

    perl Makefile.PL
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
    rm -Rf $OP_XML #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_XML "$TOOL_READY"
fi
###********************************



###OP_Intltool: 0.1SBU
if [ -n "$OP_Intltool" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Intltool
    cd $OP_Intltool

    sed -i 's:\\\${:\\\$\\{:' intltool-update.in
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
    
    install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/$OP_Intltool/I18N-HOWTO

    cd /sources/
    rm -Rf $OP_Intltool #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Intltool "$TOOL_READY"
fi
###********************************



###OP_Autoconf: 0.1SBU
if [ -n "$OP_Autoconf" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Autoconf
    cd $OP_Autoconf

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
    rm -Rf $OP_Autoconf #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Autoconf "$TOOL_READY"
fi
###********************************

sleep_before_complite

###OP_Automake: 0.1SBU
if [ -n "$OP_Automake" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Automake
    cd $OP_Automake

   ./configure --prefix=/usr --docdir=/usr/share/doc/$OP_Automake
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    make -j$(($(nproc)>4?$(nproc):4)) check

    make install
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
    echo -e "$START_JOB" " 1.8SBU"
    echo $OP_OpenSSL
    cd $OP_OpenSSL

    ./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    HARNESS_JOBS=$(nproc) make test

    sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
    make MANSUFFIX=ssl install
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
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Kmod
    cd $OP_Kmod

   ./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-openssl    \
            --with-xz         \
            --with-zstd       \
            --with-zlib       \
            --disable-manpages
    make  && make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    for target in depmod insmod modinfo modprobe rmmod; do
        ln -sfv ../bin/kmod /usr/sbin/$target
        rm -fv /usr/bin/$target
    done

    cd /sources/
    rm -Rf $OP_Kmod #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Kmod "$TOOL_READY"
fi
###********************************

sleep_before_complite

###OP_Libelf: 0.3SBU
if [ -n "$OP_Libelf" ] ;then 
    echo -e "$START_JOB" " 0.3 SBU"
    echo $OP_Libelf
    cd $OP_Libelf

   ./configure --prefix=/usr            \
            --disable-debuginfod         \
            --enable-libdebuginfod=dummy
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    make check

    make -C libelf install
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
    echo -e "$START_JOB" " 1.8 SBU"
    echo $OP_Libffi
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
    rm -Rf $OP_Libffi #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Libffi "$TOOL_READY"
fi
###********************************



###OP_Python: 1.8SBU
if [ -n "$OP_Python" ] ;then
    echo -e "$START_JOB" " 1.8 SBU"
    echo $OP_Python
    cd $OP_Python

   ./configure --prefix=/usr        \
            --enable-shared      \
            --with-system-expat  \
            --enable-optimizations
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    make test TESTOPTS="--timeout 120"

    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cat > /etc/pip.conf <<EOF
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
    echo -e "$START_JOB" " 0.1SBU"
    echo $OP_Flit_Core
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
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Wheel
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
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Setuptools
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
    echo -e "$START_JOB" " 0.3 SBU"
    echo $OP_Ninja
    cd $OP_Ninja

    export NINJAJOBS=8

    sed -i '/int Guess/a \
    int   j = 0;\
    char* jobs = getenv( "NINJAJOBS" );\
    if ( jobs != NULL ) j = atoi( jobs );\
    if ( j > 0 ) return j;\
    ' src/ninja.cc
    python3 configure.py --bootstrap

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
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Meson
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
    echo -e "$START_JOB" " 1 SBU"
    echo $OP_Coreutils
    cd $OP_Coreutils

    patch -Np1 -i ../$OP_Coreutils-i18n-1.patch

    sed -e '/n_out += n_hold/,+4 s|.*bufsize.*|//&|' \
    -i src/split.c

    autoreconf -fiv
    FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime
    make 
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    if $DO_OPTIONNAL_TESTS; then
        make NON_ROOT_USERNAME=tester check-root
        groupadd -g 102 dummy -U tester
        chown -R tester . 
        su tester -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"
        groupdel dummy
    fi

    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    mv -v /usr/bin/chroot /usr/sbin
    mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
    sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8


    cd /sources/
    rm -Rf $OP_Coreutils #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Coreutils "$TOOL_READY"
fi
###********************************



###OP_Acl part 2: 0.1SBU
if [ -n "$OP_Acl" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Acl
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
    rm -Rf $OP_Acl #rm extracted pkg( run make check after the Coreutils package has been built.)
    echo -e "$DONE" 
    echo -e $OP_Acl "$TOOL_READY"
fi
###********************************



###OP_Check: 0.1
if [ -n "$OP_Check" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Check
    cd $OP_Check

    if $STATIC_ONLY;then
       ./configure --prefix=/usr \
                --enable-static \
                --disable-shared 
    else
        ./configure --prefix=/usr --disable-static
    fi
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    make check

    make docdir=/usr/share/doc/$OP_Check install
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
    echo -e "$START_JOB" " 0.3 SBU"
    echo $OP_Diffutils
    cd $OP_Diffutils

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
    rm -Rf $OP_Diffutils #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Diffutils "$TOOL_READY"
fi
###********************************

sleep_before_complite

###OP_Gawk: 0.1SBU
if [ -n "$OP_Gawk" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Gawk
    cd $OP_Gawk

    sed -i 's/extras//' Makefile.in

   ./configure --prefix=/usr
    make 
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    chown -R tester .
    su tester -c "PATH=$PATH make check"
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
    echo -e "$START_JOB" " 0.4 SBU"
    echo $OP_Findutils
    cd $OP_Findutils

    ./configure --prefix=/usr --localstatedir=/var/lib/locate
    make 
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
    
    cd /sources/
    rm -Rf $OP_Findutils #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Findutils "$TOOL_READY"
fi
###********************************



###OP_Groff: 0.2SBU
if [ -n "$OP_Groff" ] ;then
    echo -e "$START_JOB" " 0.2 SBU"
    echo $OP_Groff
    cd $OP_Groff

    PAGE=A4 ./configure --prefix=/usr
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
    rm -Rf $OP_Groff #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Groff "$TOOL_READY"
fi
###********************************

sleep_before_complite

###OP_GRUB (NO_UEFI): 0.3SBU
if [ -n "$OP_GRUB" ] && ! $UEFI;then
    echo -e "$START_JOB" " 0.3 SBU"
    echo $OP_GRUB
    cd $OP_GRUB

    unset {C,CPP,CXX,LD}FLAGS

    echo depends bli part_gpt > grub-core/extra_deps.lst
    ./configure --prefix=/usr          \
        --sysconfdir=/etc      \
        --disable-efiemu       \
        --disable-werror

    make && make install
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

if [ -n "$OP_GRUB" ] && $UEFI;then
    source /LFS/bash_sources/step5_grub_uefi_requirement.sh

    ###OP_GRUB (WITH_UEFI BLFS): 
    echo -e "$START_JOB" " 0.4 SBU"
    echo $OP_GRUB
    cd $OP_GRUB

    mkdir -pv /usr/share/fonts/unifont &&
    gunzip -c ../unifont-15.1.05.pcf.gz > /usr/share/fonts/unifont/unifont.pcf
    unset {C,CPP,CXX,LD}FLAGS

    echo depends bli part_gpt > grub-core/extra_deps.lst

    if [ "$CPU_SELECTED_ARCH" == "x86_64" ] && [ "$(uname -m)" == "i?86" ] ; then
        tar xf ../gcc-14.2.0.tar.xz
        mkdir gcc-14.2.0/build
        pushd gcc-14.2.0/build
            ../configure --prefix=$PWD/../../x86_64-gcc \
                        --target=x86_64-linux-gnu      \
                        --with-system-zlib             \
                        --enable-languages=c,c++       \
                        --with-ld=/usr/bin/ld
            make all-gcc
            make install-gcc
        popd
        export TARGET_CC=$PWD/x86_64-gcc/bin/x86_64-linux-gnu-gcc
    fi
    
    ./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --disable-efiemu     \
            --enable-grub-mkfont \
            --with-platform=efi  \
            --target=x86_64      \
            --disable-werror
    unset TARGET_CC && make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    make install &&
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
    echo -e "$START_JOB" " 0.3 SBU"
    echo $OP_Gzip
    cd $OP_Gzip

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
    rm -Rf $OP_Gzip #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Gzip "$TOOL_READY"
fi
###********************************



###OP_IPRoute: 0.1SBU
if [ -n "$OP_IPRoute" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_IPRoute
    cd $OP_IPRoute

    sed -i /ARPD/d Makefile
    rm -fv man/man8/arpd.8
    make NETNS_RUN_DIR=/run/netns && make SBINDIR=/usr/sbin install
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
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Kbd
    cd $OP_Kbd

    patch -Np1 -i ../$OP_Kbd-backspace-1.patch
    sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
    sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
    ./configure --prefix=/usr --disable-vlock

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
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Libpipeline
    cd $OP_Libpipeline

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
    rm -Rf $OP_Libpipeline #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Libpipeline "$TOOL_READY"
fi
###********************************



###OP_Make: 0.5SBU
if [ -n "$OP_Make" ] ;then
    echo -e "$START_JOB" " 0.5 SBU"
    echo $OP_Make
    cd $OP_Make

   ./configure --prefix=/usr
    make 
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

    cd /sources/
    rm -Rf $OP_Make #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Make "$TOOL_READY"
fi
###********************************



###OP_Patch: 0.1SBU
if [ -n "$OP_Patch" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Patch
    cd $OP_Patch

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
    rm -Rf $OP_Patch #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Patch "$TOOL_READY"
fi
###********************************



###OP_Tar: 0.5SBU
if [ -n "$OP_Tar" ] ;then
    echo -e "$START_JOB" " 0.5 SBU"
    echo $OP_Tar
    cd $OP_Tar

    FORCE_UNSAFE_CONFIGURE=1  \
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
    echo -e "$START_JOB" " 0.3 SBU"
    echo $Texinfo
    cd $Texinfo

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

    make TEXMF=/usr/share/texmf install-tex
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
    echo -e "$START_JOB" " 2.5 SBU"
    echo $OP_Vim
    cd $OP_Vim

    echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
    ./configure --prefix=/usr
    make
    chown -R tester .
    su tester -c "TERM=xterm-256color LANG=en_US.UTF-8 make -j1 test"  &> vim-test.log

    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    ln -sv vim /usr/bin/vi
    for L in  /usr/share/man/{,*/}man1/vim.1; do
        ln -sv vim.1 $(dirname $L)/vi.1
    done
    ln -sv ../vim/vim91/doc /usr/share/doc/$OP_Vim

    cat > /etc/vimrc <<EOF
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
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_MarkupSafe
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
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Jinja
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
    echo -e "$START_JOB" " 0.2 SBU"
    echo $OP_Udev
    cd $OP_Udev

    sed -i -e 's/GROUP="render"/GROUP="video"/' \
       -e 's/GROUP="sgx", //' rules.d/50-udev-default.rules.in

    sed '/systemd-sysctl/s/^/#/' -i rules.d/99-systemd.rules.in
    sed '/NETWORK_DIRS/s/systemd/udev/' -i src/basic/path-lookup.h

    mkdir -p build
    cd       build

    meson setup ..                  \
        --prefix=/usr             \
        --buildtype=release       \
        -D mode=release           \
        -D dev-kvm-mode=0660      \
        -D link-udev-shared=false \
        -D logind=false           \
        -D vconsole=false

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
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    tar -xf ../../systemd-man-pages-256.4.tar.xz                            \
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
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Man_DB
    cd $OP_Man_DB

    ./configure --prefix=/usr                         \
            --docdir=/usr/share/doc/man-db-2.12.1 \
            --sysconfdir=/etc                     \
            --disable-setuid                      \
            --enable-cache-owner=bin              \
            --with-browser=/usr/bin/lynx          \
            --with-vgrind=/usr/bin/vgrind         \
            --with-grap=/usr/bin/grap             \
            --with-systemdtmpfilesdir=            \
            --with-systemdsystemunitdir=
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
    rm -Rf $OP_Man_DB #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Man_DB "$TOOL_READY"
fi
###********************************



###OP_Procps_ng: 0.1SBU
if [ -n "$OP_Procps_ng" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Procps_ng
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
    
    make
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

    cd /sources/
    rm -Rf $OP_Procps_ng #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Procps_ng "$TOOL_READY"
fi
###********************************



###OP_Util_linux: 0.5SBU
if [ -n "$OP_Util_linux" ] ;then
    echo -e "$START_JOB" " 0.5 SBU"
    echo $OP_Util_linux
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
        ./configure --bindir=/usr/bin     \
            --libdir=/usr/lib     \
            --runstatedir=/run    \
            --sbindir=/usr/sbin   \
            --disable-chfn-chsh   \
            --disable-login       \
            --disable-nologin     \
            --disable-su          \
            --disable-setpriv     \
            --disable-runuser     \
            --disable-pylibmount  \
            --disable-liblastlog2 \
            --disable-static      \
            --without-python      \
            --without-systemd     \
            --without-systemdsystemunitdir        \
            ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --docdir=/usr/share/doc/$OP_Util_linux
    fi
    
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


    cd /sources/
    rm -Rf $OP_Util_linux #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Util_linux "$TOOL_READY"
fi
###********************************

sleep_before_complite

###OP_E2fsprogs: 0.4SBU
if [ -n "$OP_E2fsprogs" ] ;then
    echo -e "$START_JOB" " 0.4 SBU"
    echo $OP_E2fsprogs
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
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Sysklogd
    cd $OP_Sysklogd

    ./configure --prefix=/usr      \
            --sysconfdir=/etc  \
            --runstatedir=/run \
            --without-logger
    make && make install
     if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

   cat > /etc/syslog.conf <<EOF
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# Do not open any internet ports.
secure_mode 2

# End /etc/syslog.conf
EOF

    cd /sources/
    rm -Rf $OP_Sysklogd #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Sysklogd "$TOOL_READY"
fi
###********************************



###OP_Sysvinit: 0.1 SBU
if [ -n "$OP_Sysvinit" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_Sysvinit
    cd $OP_Sysvinit

    patch -Np1 -i ../$OP_Sysvinit-consolidated-1.patch
    make && make install
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

export USING_CRACKLIB=false

###OP_CrackLib (BLFS): 0.1SBU
if [ -n "$OP_CrackLib" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $OP_CrackLib
    cd $OP_CrackLib

    ./configure --prefix=/usr    \
            --disable-static \
            --with-default-dict=/usr/lib/cracklib/pw_dict
    
    make && make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    install -v -m644 -D    ../$OP_CrackLib_words.xz \
        /usr/share/dict/cracklib-words.xz    &&

    unxz -v                  /usr/share/dict/cracklib-words.xz    &&
    ln -v -sf cracklib-words /usr/share/dict/words                &&
    echo $(hostname) >>      /usr/share/dict/cracklib-extra-words &&
    install -v -m755 -d      /usr/lib/cracklib                    &&

    create-cracklib-dict     /usr/share/dict/cracklib-words \
                            /usr/share/dict/cracklib-extra-words

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

    if $DO_OPTIONNAL_TESTS; then
        make test
    fi

    USING_CRACKLIB=true
    cd /sources/
    rm -Rf $OP_CrackLib #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_CrackLib "$TOOL_READY"
fi
###********************************



###OP_Shadow: 0.1SBU
if [ -n "$OP_Shadow" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
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

    passwd $My_ROOT #change password of Root user

    cd /sources/
    rm -Rf $OP_Shadow #rm extracted pkg
    echo -e "$DONE" 
    echo -e $OP_Shadow "$TOOL_READY"
fi
###********************************



popd
    STEP4_ENDED=true
    echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$END_STEP5${STEP}*     #
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
echo "$SAVE" >> /.bashrc

if ! $KEEP_DEBUG_FILES; then
    source /LFS/bash_sources/step6.sh
fi

source /LFS/bash_sources/step7.sh
