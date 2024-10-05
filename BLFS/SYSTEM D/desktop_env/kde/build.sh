#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing



bash ./download.sh

# shellcheck source=../../../../bash_sources/terminal_params/_pakages_names.sh
source ../../../../bash_sources/terminal_params/_pakages_names.sh
# shellcheck source=/dev/null
source ../../../../bash_sources/terminal_params/_util_methodes.sh
# shellcheck source=/dev/null
source /.bashrc

#extract_all_files
echo -e "$START_EXTRACTION"
extract_tar_files /sources "${PKG_icu}4c-75_1-src      $PKG_Valgrind    $PKG_libxml             $PKG_nghttp2                $PKG_libuv          $PKG_libarchive     $PKG_libunistring    $PKG_libidn2   $PKG_libpsl          $PKG_curl   " &
extract_tar_files /sources "$PKG_curl                  $PKG_CMake       $PKG_Extra_cmake        $PKG_xcb_proto              $PKG_util_macros    $PKG_xorg_proto     $PKG_libxau          $PKG_libXdmcp  $PKG_Fontconfig      $PKG_Qt   " &
extract_tar_files /sources "$PKG_Packaging             $PKG_Glib        $PKG_shared_mime_info   $PKG_desktop_file_utils     $PKG_phonon         $PKG_vlc            $PKG_phonon_backend  " &

extract_tar_files /sources "$PKG_Linux_PAM             $PKG_polkit      $PKG_cracklib           $PKG_libpwquality           $PKG_shadow  $    $  $   $   $   " &
extract_tar_files /sources "$     $    $     $   $  $    $  $   $   $   " &

wait
echo -e "$DONE"

export build_file_path=$(pwd)


###PKG_icu: 0.7SBU
if [[ -n "$PKG_icu" && -z "$next_pkg" ]] ;then
    echo -e "$PKG_icu" " 0.7 SBU"
    echo $PKG_icu
    cd $PKG_icu
   
    cd source

    ./configure --prefix=/usr
    
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

    cd /sources/blfs
    rm -Rf $PKG_icu #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_icu "$TOOL_READY"
    next_pkg="$PKG_Valgrind"
fi
###********************************



###PKG_Valgrind: 0.5SBU
if [[ -n "$PKG_Valgrind" && "$next_pkg" = "$PKG_Valgrind" ]] ;then
    echo -e "$PKG_Valgrind" " 0.5 SBU"
    echo $PKG_Valgrind
    cd $PKG_Valgrind
   
    sed -i 's|/doc/valgrind||' docs/Makefile.in &&

    ./configure --prefix=/usr \
                --datadir=/usr/share/doc/$PKG_Valgrind
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        echo "export next_pkg=$next_pkg" >> /.bashrc
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    sed -e 's@prereq:.*@prereq: false@' \
    -i {helgrind,drd}/tests/pth_cond_destroy_busy.vgtest

    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        echo "export next_pkg=$next_pkg" >> /.bashrc
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    
    cd /sources/blfs
    rm -Rf $PKG_Valgrind #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_Valgrind "$TOOL_READY"
    next_pkg="$PKG_libxml"
fi
###********************************



###PKG_libxml: 0.4SBU
if [[ -n "$PKG_libxml" && "$next_pkg" = "$PKG_libxml" ]] ;then
    echo -e "$PKG_libxml" " 0.4 SBU"
    echo $PKG_libxml
    cd $PKG_libxml
   
    patch -Np1 -i ../$PKG_libxml-upstream_fix-2.patch

    ./configure --prefix=/usr           \
            --sysconfdir=/etc       \
            --disable-static        \
            --with-history          \
            --with-icu              \
            PYTHON=/usr/bin/python3 \
            --docdir=/usr/share/doc/$PKG_libxml &&
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        echo "export next_pkg=$next_pkg" >> /.bashrc
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
        echo "export next_pkg=$next_pkg" >> /.bashrc
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    rm -vf /usr/lib/libxml2.la && sed '/libs=/s/xml2.*/xml2"/' -i /usr/bin/xml2-config

    cd /sources/blfs
    rm -Rf $PKG_libxml #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_libxml "$TOOL_READY"
    next_pkg="$PKG_nghttp2"
fi
###********************************



###PKG_nghttp2: 0.4SBU
if [[ -n "$PKG_nghttp2" && "$next_pkg" = "$PKG_nghttp2" ]] ;then
    echo -e "$PKG_nghttp2" " 0.4 SBU"
    echo $PKG_nghttp2
    cd $PKG_nghttp2
   
    ./configure --prefix=/usr     \
                --disable-static  \
                --enable-lib-only \
                --docdir=/usr/share/doc/$PKG_libxml &&
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

    cd /sources/blfs
    rm -Rf $PKG_libxml #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_libxml "$TOOL_READY"
    next_pkg="$PKG_libuv"
fi
###********************************



###PKG_libuv: 0.1SBU
if [[ -n "$PKG_libuv" && "$next_pkg" = "$PKG_libuv" ]] ;then
    echo -e "$PKG_libuv" " 0.1 SBU"
    echo $PKG_libuv
    cd $PKG_libuv

    # Save the current value of ACLOCAL
    ORIGINAL_ACLOCAL="$ACLOCAL"

    # Unset ACLOCAL
    unset ACLOCAL
   
    sh autogen.sh                             
    ./configure --prefix=/usr --disable-static
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        echo "export next_pkg=$next_pkg" >> /.bashrc
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    if $DO_OPTIONNAL_TESTS; then
        make NON_ROOT_USERNAME=tester check-root
        groupadd -g 102 dummy -U tester
        chown -R tester . 
        su tester -c "make check"
        groupdel dummy
    fi

    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        echo "export next_pkg=$next_pkg" >> /.bashrc
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    install -Dm644 docs/build/man/libuv.1 /usr/share/man/man1

    export ACLOCAL="$ORIGINAL_ACLOCAL"

    cd /sources/blfs
    rm -Rf $PKG_libuv #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_libuv "$TOOL_READY"
    next_pkg="$PKG_libarchive"
fi
###********************************



###PKG_libarchive: 0.4SBU
if [[ -n "$PKG_libarchive" && "$next_pkg" = "$PKG_libarchive" ]] ;then
    echo -e "$PKG_libarchive" " 0.4 SBU"
    echo $PKG_libarchive
    cd $PKG_libarchive

    ./configure --prefix=/usr --disable-static --without-expat &&
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        echo "export next_pkg=$next_pkg" >> /.bashrc
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    if $DO_OPTIONNAL_TESTS; then
        LC_ALL=C.UTF-8 make check
    fi

    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        echo "export next_pkg=$next_pkg" >> /.bashrc
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    
    cd /sources/blfs
    rm -Rf $PKG_libarchive #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_libarchive "$TOOL_READY"
    next_pkg="$PKG_libunistring"
fi
###********************************



###PKG_libunistring: 0.5SBU
if [[ -n "$PKG_libunistring" && "$next_pkg" = "$PKG_libunistring" ]] ;then
    echo -e "$PKG_libunistring" " 0.5 SBU"
    echo $PKG_libunistring
    cd $PKG_libunistring

    ./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/$PKG_libunistring &&
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

    
    cd /sources/blfs
    rm -Rf $PKG_libunistring #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_libunistring "$TOOL_READY"
    next_pkg="$PKG_libidn2"
fi
###********************************



###PKG_libidn2: 0.1SBU
if [[ -n "$PKG_libidn2" && "$next_pkg" = "$PKG_libidn2" ]] ;then
    echo -e "$PKG_libidn2" " 0.1 SBU"
    echo $PKG_libidn2
    cd $PKG_libidn2

    ./configure --prefix=/usr --disable-static &&
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

    
    cd /sources/blfs
    rm -Rf $PKG_libidn2 #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_libidn2 "$TOOL_READY"
    next_pkg="$PKG_libpsl"
fi
###********************************



###PKG_libpsl: 0.1SBU
if [[ -n "$PKG_libpsl" && "$next_pkg" = "$PKG_libpsl" ]] ;then
    echo -e "$PKG_libpsl" " 0.1 SBU"
    echo $PKG_libpsl
    cd $PKG_libpsl

    mkdir build &&
    cd    build &&

    meson setup --prefix=/usr --buildtype=release &&

    ninja

    if $DO_OPTIONNAL_TESTS; then
        ninja test
    fi

    ninja install
    
    cd /sources/blfs
    rm -Rf $PKG_libpsl #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_libpsl "$TOOL_READY"
    next_pkg="$PKG_curl"
fi
###********************************



###PKG_curl: 0.2SBU
if [[ -n "$PKG_curl" && "$next_pkg" = "$PKG_curl" ]] ;then
    echo -e "$PKG_curl" " 0.2 SBU"
    echo $PKG_curl
    cd $PKG_curl

    ./configure --prefix=/usr                           \
                --disable-static                        \
                --with-openssl                          \
                --enable-threaded-resolver              \
                --with-ca-path=/etc/ssl/certs &&
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        echo "export next_pkg=$next_pkg" >> /.bashrc
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"


    if $DO_OPTIONNAL_TESTS; then
         make test
    fi

    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        echo "export next_pkg=$next_pkg" >> /.bashrc
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    rm -rf docs/examples/.deps &&

    find docs \( -name Makefile\* -o  \
                -name \*.1       -o  \
                -name \*.3       -o  \
                -name CMakeLists.txt \) -delete &&

    cp -v -R docs -T /usr/share/doc/$PKG_curl
    
    cd /sources/blfs
    rm -Rf $PKG_curl #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_curl "$TOOL_READY"
    next_pkg="$PKG_CMake"
fi
###********************************



###PKG_CMake: 3SBU
if [[ -n "$PKG_CMake" && "$next_pkg" = "$PKG_CMake" ]] ;then
    echo -e "$PKG_CMake" " 3 SBU"
    echo $PKG_CMake
    cd $PKG_CMake

    sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake &&

    ./bootstrap --prefix=/usr        \
                --system-libs        \
                --mandir=/share/man  \
                --no-system-jsoncpp  \
                --no-system-cppdap   \
                --no-system-librhash \
                --docdir=/share/doc/$PKG_CMake &&
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        echo "export next_pkg=$next_pkg" >> /.bashrc
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"


    if $DO_OPTIONNAL_TESTS; then
         LC_ALL=en_US.UTF-8 bin/ctest -j$(nproc) -O cmake-3.30.2-test.log
    fi

    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        echo "export next_pkg=$next_pkg" >> /.bashrc
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"
    
    cd /sources/blfs
    rm -Rf $PKG_curl #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_CMake "$TOOL_READY"
    next_pkg="$PKG_Extra_cmake"
fi
###********************************



###PKG_Extra_cmake: 3SBU
if [[ -n "$PKG_Extra_cmake" && "$next_pkg" = "$PKG_Extra_cmake" ]] ;then
    echo -e "$PKG_Extra_cmake" " 3 SBU"
    echo $PKG_Extra_cmake
    cd $PKG_Extra_cmake

    sed -i '/"lib64"/s/64//' kde-modules/KDEInstallDirsCommon.cmake &&

    sed -e '/PACKAGE_INIT/i set(SAVE_PACKAGE_PREFIX_DIR "${PACKAGE_PREFIX_DIR}")' \
        -e '/^include/a set(PACKAGE_PREFIX_DIR "${SAVE_PACKAGE_PREFIX_DIR}")' \
        -i ECMConfig.cmake.in &&

    mkdir build &&
    cd    build &&

    cmake -D CMAKE_INSTALL_PREFIX=/usr .. &&
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
    rm -Rf $PKG_Extra_cmake #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_Extra_cmake "$TOOL_READY"
    next_pkg="$PKG_xcb_proto"
fi
###********************************



###PKG_Extra_cmake: 3SBU
if [[ -n "$PKG_Extra_cmake" && "$next_pkg" = "$PKG_Extra_cmake" ]] ;then
    echo -e "$PKG_Extra_cmake" " 3 SBU"
    echo $PKG_Extra_cmake
    cd $PKG_Extra_cmake
    

    sed -i '/"lib64"/s/64//' kde-modules/KDEInstallDirsCommon.cmake &&

    sed -e '/PACKAGE_INIT/i set(SAVE_PACKAGE_PREFIX_DIR "${PACKAGE_PREFIX_DIR}")' \
        -e '/^include/a set(PACKAGE_PREFIX_DIR "${SAVE_PACKAGE_PREFIX_DIR}")' \
        -i ECMConfig.cmake.in &&

    mkdir build &&
    cd    build &&

    cmake -D CMAKE_INSTALL_PREFIX=/usr .. &&
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
    rm -Rf $PKG_Extra_cmake #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_Extra_cmake "$TOOL_READY"
    next_pkg="$PKG_xcb_proto"
fi
###********************************


#Setting up the Xorg Build Environment
export XORG_PREFIX="/usr"

export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
--localstatedir=/var --disable-static"

cat > /etc/profile.d/xorg.sh << EOF
XORG_PREFIX="$XORG_PREFIX"
XORG_CONFIG="--prefix=\$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
export XORG_PREFIX XORG_CONFIG
EOF
chmod 644 /etc/profile.d/xorg.sh


###PKG_xcb_proto: 3SBU
if [[ -n "$PKG_xcb_proto" && "$next_pkg" = "$PKG_xcb_proto" ]] ;then
    echo -e "$PKG_xcb_proto" " 3 SBU"
    echo $PKG_xcb_proto
    cd $PKG_xcb_proto


    PYTHON=python3 ./configure $XORG_CONFIG
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

    rm -f $XORG_PREFIX/lib/pkgconfig/xcb-proto.pc
    
    cd /sources/blfs
    rm -Rf $PKG_xcb_proto #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_xcb_proto "$TOOL_READY"
    next_pkg="$PKG_util_macros"
fi
###********************************



###PKG_util_macros: 3SBU
if [[ -n "$PKG_util_macros" && "$next_pkg" = "$PKG_util_macros" ]] ;then
    echo -e "$PKG_util_macros" " 3 SBU"
    echo $PKG_util_macros
    cd $PKG_util_macros

    ./configure $XORG_CONFIG

    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        echo "export next_pkg=$next_pkg" >> /.bashrc
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    
    cd /sources/blfs
    rm -Rf $PKG_util_macros #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_util_macros "$TOOL_READY"
    next_pkg="$PKG_xorg_proto"
fi
###********************************



###PKG_xorg_proto: 0.1SBU
if [[ -n "$PKG_xorg_proto" && "$next_pkg" = "$PKG_xorg_proto" ]] ;then
    echo -e "$PKG_xorg_proto" " 0.1 SBU"
    echo $PKG_xorg_proto
    cd $PKG_xorg_proto

    mkdir build &&
    cd    build &&

    meson setup --prefix=$XORG_PREFIX .. &&
    ninja

    ninja install &&
    
    mv -v $XORG_PREFIX/share/doc/xorgproto{,-2024.1}
    
    cd /sources/blfs
    rm -Rf $PKG_xorg_proto #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_xorg_proto "$TOOL_READY"
    next_pkg="$PKG_libxau"
fi
###********************************



###PKG_libxau: 0.1SBU
if [[ -n "$PKG_libxau" && "$next_pkg" = "$PKG_libxau" ]] ;then
    echo -e "$PKG_libxau" " 0.1 SBU"
    echo $PKG_libxau
    cd $PKG_libxau

    ./configure $XORG_CONFIG &&
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

    cd /sources/blfs
    rm -Rf $PKG_libxau #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_libxau "$TOOL_READY"
    next_pkg="$PKG_libXdmcp"
fi
###********************************



###PKG_libXdmcp: 0.1SBU
if [[ -n "$PKG_libXdmcp" && "$next_pkg" = "$PKG_libXdmcp" ]] ;then
    echo -e "$PKG_libXdmcp" " 0.1 SBU"
    echo $PKG_libXdmcp
    cd $PKG_libXdmcp

    ./configure $XORG_CONFIG --docdir=/usr/share/doc/$PKG_libXdmcp &&
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

    cd /sources/blfs
    rm -Rf $PKG_libXdmcp #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_libXdmcp "$TOOL_READY"
    next_pkg="$PKG_Fontconfig"
fi
###********************************


if ! $IS_UEFI; then
    pushd $build_file_path
        source ../../../../bash_sources/step5_grub_uefi_requirement.sh ## the same required packges
    popd
fi



###PKG_Fontconfig: 0.1SBU
if [[ -n "$PKG_Fontconfig" && "$next_pkg" = "$PKG_Fontconfig" ]] ;then
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
fi
###********************************



###PKG_Xorg_lib: 0.1SBU
if [[ -n "$PKG_Xorg_lib" && "$next_pkg" = "$PKG_Xorg_lib" ]] ;then
    echo -e "$PKG_Xorg_lib" " 0.1 SBU"
    echo $PKG_Xorg_lib
    cd $PKG_Xorg_lib

    as_root()
    {
        if   [ $EUID = 0 ];        then $*
        elif [ -x /usr/bin/sudo ]; then sudo $*
        else                            su -c \\"$*\\"
        fi
    }

    export -f as_root


    bash -e "$build_file_path/build_xorg_libs.sh"

    cd /sources/blfs
    #rm -Rf $PKG_Xorg_lib #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_Xorg_lib "$TOOL_READY"
    next_pkg="$PKG_Qt"
fi
###********************************



###PKG_Qt: 0.1SBU
if [[ -n "$PKG_Qt" && "$next_pkg" = "$PKG_Qt" ]] ;then
    echo -e "$PKG_Qt" " 0.1 SBU"
    echo $PKG_Qt
    cd $PKG_Qt

    export QT6PREFIX=/opt/qt6
    mkdir -pv /opt/qt-6.7.2
    ln -sfnv qt-6.7.2 /opt/qt6


    if [ "$CPU_SELECTED_ARCH" == "i686" ]; then
        sed -e "/^#elif defined(Q_CC_GNU_ONLY)/s/.*/& \&\& 0/" \
            -i qtbase/src/corelib/global/qtypes.h
    fi

    ./configure -prefix $QT6PREFIX      \
            -sysconfdir /etc/xdg    \
            -dbus-linked            \
            -openssl-linked         \
            -system-sqlite          \
            -nomake examples        \
            -no-rpath               \
            -journald               \
            -skip qt3d              \
            -skip qtquick3dphysics  \
            -skip qtwebengine       \
            -W no-dev               &&
    ninja

    ninja install

    find $QT6PREFIX/ -name \*.prl \
   -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;

   pushd qttools/src &&
        install -v -Dm644 assistant/assistant/images/assistant-128.png       \
                        /usr/share/pixmaps/assistant-qt6.png               &&

        install -v -Dm644 designer/src/designer/images/designer.png          \
                        /usr/share/pixmaps/designer-qt6.png                &&

        install -v -Dm644 linguist/linguist/images/icons/linguist-128-32.png \
                        /usr/share/pixmaps/linguist-qt6.png                &&

        install -v -Dm644 qdbus/qdbusviewer/images/qdbusviewer-128.png       \
                        /usr/share/pixmaps/qdbusviewer-qt6.png             &&
    popd &&


    cat > /usr/share/applications/assistant-qt6.desktop << EOF
    [Desktop Entry]
    Name=Qt6 Assistant
    Comment=Shows Qt6 documentation and examples
    Exec=$QT6PREFIX/bin/assistant
    Icon=assistant-qt6.png
    Terminal=false
    Encoding=UTF-8
    Type=Application
    Categories=Qt;Development;Documentation;
EOF

    cat > /usr/share/applications/designer-qt6.desktop << EOF
    [Desktop Entry]
    Name=Qt6 Designer
    GenericName=Interface Designer
    Comment=Design GUIs for Qt6 applications
    Exec=$QT6PREFIX/bin/designer
    Icon=designer-qt6.png
    MimeType=application/x-designer;
    Terminal=false
    Encoding=UTF-8
    Type=Application
    Categories=Qt;Development;
EOF

    cat > /usr/share/applications/linguist-qt6.desktop << EOF
    [Desktop Entry]
    Name=Qt6 Linguist
    Comment=Add translations to Qt6 applications
    Exec=$QT6PREFIX/bin/linguist
    Icon=linguist-qt6.png
    MimeType=text/vnd.trolltech.linguist;application/x-linguist;
    Terminal=false
    Encoding=UTF-8
    Type=Application
    Categories=Qt;Development;
EOF

    cat > /usr/share/applications/qdbusviewer-qt6.desktop << EOF
    [Desktop Entry]
    Name=Qt6 QDbusViewer
    GenericName=D-Bus Debugger
    Comment=Debug D-Bus applications
    Exec=$QT6PREFIX/bin/qdbusviewer
    Icon=qdbusviewer-qt6.png
    Terminal=false
    Encoding=UTF-8
    Type=Application
    Categories=Qt;Development;Debugger;
EOF

    cat >> /etc/ld.so.conf << EOF
    # Begin Qt addition

    /opt/qt6/lib

    # End Qt addition
EOF

    ldconfig

    cat > /etc/profile.d/qt6.sh << "EOF"
    # Begin /etc/profile.d/qt6.sh

    QT6DIR=/opt/qt6

    pathappend $QT6DIR/bin           PATH
    pathappend $QT6DIR/lib/pkgconfig PKG_CONFIG_PATH

    export QT6DIR

    # End /etc/profile.d/qt6.sh
EOF

    cd /sources/blfs
    rm -Rf $PKG_Qt #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_Qt "$TOOL_READY"
    next_pkg="$PKG_Packaging"
fi
###********************************



###PKG_Packaging: 0.1SBU
if [[ -n "$PKG_Packaging" && "$next_pkg" = "$PKG_Packaging" ]] ;then
    echo -e "$PKG_Packaging" " 0.1 SBU"
    echo $PKG_Packaging
    cd $PKG_Packaging

    pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
    pip3 install --no-index --find-links=dist --no-cache-dir --no-user packaging

    cd /sources/blfs
    rm -Rf $PKG_Packaging #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_Packaging "$TOOL_READY"
    next_pkg="$PKG_Glib"
fi
###********************************



###PKG_Glib: 0.1SBU
if [[ -n "$PKG_Glib" && "$next_pkg" = "$PKG_Glib" ]] ;then
    echo -e "$PKG_Glib" " 0.1 SBU"
    echo $PKG_Glib
    cd $PKG_Glib

    export GLIB_LOG_LEVEL=4
    patch -Np1 -i ../glib-skip_warnings-1.patch

    mkdir build &&
    cd    build &&

    meson setup ..                  \
        --prefix=/usr             \
        --buildtype=release       \
        -D introspection=disabled \
        -D man-pages=enabled      &&
    ninja

    ninja install

    tar xf ../../gobject-introspection-1.80.1.tar.xz &&

    meson setup gobject-introspection-1.80.1 gi-build \
                --prefix=/usr --buildtype=release     &&
    ninja -C gi-build

    if $DO_OPTIONNAL_TESTS; then
        ninja -C gi-build test
    fi

    ninja -C gi-build install
    meson configure -D introspection=enabled &&
    ninja

    ninja install

    source $build_file_path/run_befor_glib_test.sh

    make NON_ROOT_USERNAME=tester check-root
    groupadd -g 102 dummy -U tester
    chown -R tester . 
    su tester -c "LC_ALL=C ninja test "
    groupdel dummy

    cd /sources/blfs
    rm -Rf $PKG_Glib #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_Glib "$TOOL_READY"
    next_pkg="$PKG_phonon"
fi
###********************************



###PKG_phonon: 0.1SBU
if [[ -n "$PKG_phonon" && "$next_pkg" = "$PKG_phonon" ]] ;then
    echo -e "$PKG_phonon" " 0.1 SBU"
    echo $PKG_phonon
    cd $PKG_phonon

    mkdir build &&
    cd    build &&

    cmake -D CMAKE_INSTALL_PREFIX=/usr \
        -D CMAKE_BUILD_TYPE=Release  \
        -D PHONON_BUILD_QT5=OFF      \
        -W no-dev .. &&
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
    rm -Rf $PKG_phonon #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_phonon "$TOOL_READY"
    next_pkg="$PKG_vlc"
fi
###********************************



###PKG_vlc: 0.1SBU
if [[ -n "$PKG_vlc" && "$next_pkg" = "$PKG_vlc" ]] ;then
    echo -e "$PKG_vlc" " 0.1 SBU"
    echo $PKG_vlc
    cd $PKG_vlc

    patch -Np1 -i ../$PKG_vlc-taglib-1.patch         &&
    patch -Np1 -i ../$PKG_vlc-fedora_ffmpeg7-1.patch

    BUILDCC=gcc ./configure --prefix=/usr --disable-libplacebo &&
    make
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        echo "export next_pkg=$next_pkg" >> /.bashrc
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    make docdir=/usr/share/doc/$PKG_vlc install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        echo "export next_pkg=$next_pkg" >> /.bashrc
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources/blfs
    rm -Rf $PKG_phonon #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_phonon "$TOOL_READY"
    next_pkg="$PKG_phonon_backend"
fi
###********************************



###PKG_phonon_backend: 0.1SBU
if [[ -n "$PKG_phonon_backend" && "$next_pkg" = "$PKG_phonon_backend" ]] ;then
    echo -e "$PKG_phonon_backend" " 0.1 SBU"
    echo $PKG_phonon_backend
    cd $PKG_PKG_phonon_backendvlc

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
    rm -Rf $PKG_phonon_backend #rm extracted pkg
    echo -e "$DONE" 
    echo -e $PKG_phonon_backend "$TOOL_READY"
    next_pkg="$PKG_Linux_PAM"
fi
###********************************

cd $build_file_path
source ./build_2.sh