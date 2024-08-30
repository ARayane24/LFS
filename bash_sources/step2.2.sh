#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

source ~/.bashrc
source ./terminal_params/_util_methodes.sh
source ./terminal_params/_pakages_names.sh

echo -e "$N_THREADS $(nproc)"
if [ -z "${LFS_TGT+x}" ]; then
    echo "Variable is not defined. Exiting."
    exit 1
fi
echo -e "$N_THREADS $(nproc)"
cd $LFS/sources/

#extract_all_files
echo -e "$START_EXTRACTION"
extract_tar_files $LFS/sources/ "$Binutils_P1 $GCC_P1 $Linux $Glibc $Libstdc $M4 $Ncurses $Bash $Coreutils $Diffutils $File $Findutils $Gawk $Grep $Gzip $Make $Patch $Sed $Tar $Xz"
echo -e "$DONE"

#############################################################
echo -e "${PROCESS}Compiling a Cross-Toolchain...${NO_STYLE}"
#############################################################
###binutils 1 :
echo -e "$START_JOB"
echo $Binutils_P1
cd $Binutils_P1/build
 # "-prefix=$LFS/tools" install the Binutils programs in the $LFS/tools directory.
 # "--with-sysroot=$LFS" look in $LFS for the target system libraries as needed.

../configure --prefix=$LFS/tools \
            --with-sysroot=$LFS \
            --target=$LFS_TGT   \
            --disable-nls       \
            --enable-gprofng=no \
            --disable-werror    \
            --enable-default-hash-style=gnu
make --silent && make install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
cd $LFS/sources/
rm -Rf $Binutils_P1 #rm extracted pkg
echo -e "$DONE" 
echo -e $Binutils_P1 "$TOOL_READY"
###********************************



###GCC
echo -e "$START_JOB"
echo $GCC_P1
cd $GCC_P1
tar -xf ../$GCC_P1_mpfr.tar.xz
mv -v $GCC_P1_mpfr mpfr
tar -xf ../$GCC_P1_gmp.tar.xz
mv -v $GCC_P1_gmp gmp
tar -xf ../$GCC_P1_mpc.tar.gz
mv -v $GCC_P1_mpc mpc

#If the system's architecture is x86_64, it modifies the gcc/config/i386/t-linux64 file by replacing lib64 with lib on any line that contains m64=. The original file is backed up with the extension .orig.
# It adjusts the configuration to ensure that certain libraries are found in the correct directory,
case $(uname -m) in
x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
;;
esac

cd  build

../configure --target=$LFS_TGT         \
             --prefix=$LFS/tools       \
             --with-glibc-version=2.39 \
             --with-sysroot=$LFS       \
             --with-newlib             \
             --without-headers         \
             --enable-default-pie      \
             --enable-default-ssp      \
             --disable-nls             \
             --disable-shared          \
             --disable-multilib        \
             --disable-threads         \
             --disable-libatomic       \
             --disable-libgomp         \
             --disable-libquadmath     \
             --disable-libssp          \
             --disable-libvtv          \
             --disable-libstdcxx       \
             --enable-languages=c,c++ 
make --silent && make install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include/limits.h
cd $LFS/sources/
rm -Rf $GCC_P1
echo -e "$DONE"
echo -e $GCC_P1"$TOOL_READY"
###********************************



###Linux-6 headers
echo -e "$START_JOB"
echo $Linux
cd $Linux
make mrproper  --silent && make headers --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr
cd $LFS/sources/
rm -Rf $Linux
echo -e "$DONE" 
echo -e $Linux "$TOOL_READY"
###********************************



###glibc
echo -e "$START_JOB"
echo $Glibc
cd $Glibc
case $(uname -m) in
    i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
    ;;
esac

patch -Np1 -i ../$Glibc-fhs-1.patch

cd   build
echo "rootsbindir=/usr/sbin" > configparms

../configure \
    --prefix=/usr                      \
    --host=$LFS_TGT                    \
    --build=$(../scripts/config.guess) \
    --enable-kernel=4.19               \
    --with-headers=$LFS/usr/include    \
    --disable-nscd                     \
    libc_cv_slibdir=/usr/lib
make --silent && make DESTDIR=$LFS install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd

#test
echo -e "$START_TEST"
echo 'int main(){}' | $LFS_TGT-gcc -xc -
readelf -l a.out | grep ld-linux
echo -e "$EXPECT_OUTPUT"
echo "[Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]"
# Check the program interpreter using readelf and grep for ld-linux
output=$(readelf -l a.out | grep ld-linux)
echo -e "\n$REAL_OUTPUT"
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
cd $LFS/sources/
rm -Rf $Glibc
echo -e "$DONE" 
echo -e $Glibc "$TOOL_READY"
###********************************



### $Libstdc
echo -e "$START_JOB"
echo $GCC_P1
tar -xf "$GCC_P1.tar.xz"
mkdir -v $GCC_P1/build
cd $GCC_P1/build
../$Libstdc-v3/configure           \
    --host=$LFS_TGT                 \
    --build=$(../config.guess)      \
    --prefix=/usr                   \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/13.2.0 && \
make --silent && make DESTDIR=$LFS install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
rm -v $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la
cd $LFS/sources/
rm -Rf $GCC_P1
echo -e "${DONE}" 
echo -e $GCC_P1 "$TOOL_READY"
###********************************

echo -e "${DONE}"

#############################################################
echo -e "${PROCESS}Cross Compiling Temporary Tools...${NO_STYLE}"
#############################################################
### M4
echo -e "$START_JOB"
echo $M4
cd $M4
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make --silent && make DESTDIR=$LFS install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
cd $LFS/sources/
rm -Rf $M4
echo -e "$DONE" 
echo -e $M4 "$TOOL_READY"
###********************************



### Ncurses
echo -e "$START_JOB"
echo $Ncurses
cd $Ncurses
sed -i s/mawk// configure
pushd build
  ../configure
  make -C include
  make -C progs tic
popd
./configure --prefix=/usr                \
            --host=$LFS_TGT              \
            --build=$(./config.guess)    \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --with-shared                \
            --without-normal             \
            --with-cxx-shared            \
            --without-debug              \
            --without-ada                \
            --disable-stripping          \
            --enable-widec
make --silent && make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
ln -sv libncursesw.so $LFS/usr/lib/libncurses.so
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
    -i $LFS/usr/include/curses.h
cd $LFS/sources/
rm -Rf $Ncurses
echo -e "$DONE"
echo -e $Ncurses "$TOOL_READY"
###********************************



### Bash
echo -e "$START_JOB"
echo $Bash
cd $Bash
./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$LFS_TGT                    \
            --without-bash-malloc
make --silent && make DESTDIR=$LFS install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
ln -sv bash $LFS/bin/sh
cd $LFS/sources/
rm -Rf $Bash
echo -e "$DONE" 
echo -e $Bash "$TOOL_READY"
###********************************



### Coreutils
echo -e "$START_JOB"
echo $Coreutils
cd $Coreutils
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime
make --silent && make DESTDIR=$LFS install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
mv -v $LFS/usr/bin/chroot              $LFS/usr/sbin
mkdir -pv $LFS/usr/share/man/man8
mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/'                    $LFS/usr/share/man/man8/chroot.8
cd $LFS/sources/
rm -Rf $Coreutils
echo -e "$DONE" $Coreutils
echo -e $Coreutils "$TOOL_READY"
###********************************



### Diffutils
echo -e "$START_JOB"
echo $Diffutils
cd $Diffutils
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)
make --silent && make DESTDIR=$LFS install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
cd $LFS/sources/
rm -Rf $Diffutils
echo -e "$DONE" 
echo -e $Diffutils "$TOOL_READY"
###********************************



### File
echo -e "$START_JOB"
echo $File
cd $File
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make
  if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
  fi
    echo -e "$BUILD_SUCCEEDED"
popd
./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)
make FILE_COMPILE=$(pwd)/build/src/file && make DESTDIR=$LFS install
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
rm -v $LFS/usr/lib/libmagic.la
cd $LFS/sources/
rm -Rf $File
echo -e "$DONE" 
echo -e $File "$TOOL_READY"
###********************************



### Findutils
echo -e "$START_JOB"
echo $Findutils
cd $Findutils
./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$LFS_TGT                 \
            --build=$(build-aux/config.guess)
make --silent && make DESTDIR=$LFS install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
cd $LFS/sources/
rm -Rf $Findutils
echo -e "$DONE" 
echo -e $Findutils "$TOOL_READY"
###********************************



### Gawk
echo -e "$START_JOB"
echo $Gawk
cd $Gawk
sed -i 's/Fileextras//' Makefile.in
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make --silent && make DESTDIR=$LFS install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
cd $LFS/sources/
rm -Rf $Gawk
echo -e "$DONE"
echo -e  $Gawk "$TOOL_READY"
###********************************



### Grep
echo -e "$START_JOB"
echo $Grep
cd $Grep
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)
make --silent && make DESTDIR=$LFS install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
cd $LFS/sources/
rm -Rf $Grep
echo -e "$DONE" 
echo -e  $Grep "$TOOL_READY"
###********************************



### Gzip
echo -e "$START_JOB"
echo $Gzip
cd $Gzip
./configure --prefix=/usr --host=$LFS_TGT
make --silent && make DESTDIR=$LFS install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
cd $LFS/sources/
rm -Rf $Gzip
echo -e "$DONE" 
echo -e $Gzip "$TOOL_READY"
###********************************



### Make
echo -e "$START_JOB"
echo $Make
cd $Make
./configure --prefix=/usr   \
            --without-guile \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make --silent && make DESTDIR=$LFS install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
cd $LFS/sources/
rm -Rf $Make
echo -e "$DONE" 
echo -e $Make "$TOOL_READY"
###********************************



### Patch
echo -e "$START_JOB"
echo $Patch
cd $Patch
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make --silent && make DESTDIR=$LFS install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
cd $LFS/sources/
rm -Rf $Patch
echo -e "$DONE" $Patch
echo -e  $Patch "$TOOL_READY"
###********************************



### Sed
echo -e "$START_JOB"
echo $Sed
cd $Sed
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)
make --silent && make DESTDIR=$LFS install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
cd $LFS/sources/
rm -Rf $Sed
echo -e "$DONE" 
echo -e $Sed "$TOOL_READY"
###********************************



### Tar
echo -e "$START_JOB"
echo $Tar
cd $Tar
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess)
make --silent && make DESTDIR=$LFS install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
cd $LFS/sources/
rm -Rf $Tar
echo -e "$DONE" 
echo -e $Tar "$TOOL_READY"
###********************************



### Xz
echo -e "$START_JOB"
echo $Xz
cd $Xz
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/$Xz
make --silent && make DESTDIR=$LFS install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
rm -v $LFS/usr/lib/liblzma.la
cd $LFS/sources/
rm -Rf $Xz
echo -e "$DONE" 
echo -e $Xz "$TOOL_READY"
###********************************



### Binutils_P2
echo -e "$START_JOB"
echo $Binutils_P2
tar -xf "$Binutils_P2.tar.xz"
cd $Binutils_P2
sed '6009s/$add_dir//' -i ltmain.sh
mkdir build
cd       build
../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --enable-gprofng=no        \
    --disable-werror           \
    --enable-64-bit-bfd        \
    --enable-default-hash-style=gnu
make --silent && make DESTDIR=$LFS install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}
cd $LFS/sources/
rm -Rf $Binutils_P2
echo -e "$DONE" 
echo -e $Binutils_P2 "$TOOL_READY"
###********************************



### GCC 2
echo -e "$START_JOB"
echo $GCC_P2
tar -xf "$GCC_P2.tar.xz"
cd $GCC_P2
tar -xf ../$GCC_P2_mpfr.tar.xz
mv -v $GCC_P2_mpfr mpfr
tar -xf ../$GCC_P2_gmp.tar.xz
mv -v $GCC_P2_gmp gmp
tar -xf ../$GCC_P2_mpc.tar.gz
mv -v $GCC_P2_mpc mpc
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac
sed '/thread_header =/s/@.*@/gthr-posix.h/' \
    -i libgcc/Makefile.in $Libstdc-v3/include/Makefile.in
mkdir build
cd       build
../configure                                       \
    --build=$(../config.guess)                     \
    --host=$LFS_TGT                                \
    --target=$LFS_TGT                              \
    LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc      \
    --prefix=/usr                                  \
    --with-build-sysroot=$LFS                      \
    --enable-default-pie                           \
    --enable-default-ssp                           \
    --disable-nls                                  \
    --disable-multilib                             \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libquadmath                          \
    --disable-libsanitizer                         \
    --disable-libssp                               \
    --disable-libvtv                               \
    --enable-languages=c,c++
make --silent && make DESTDIR=$LFS install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"
ln -sv gcc $LFS/usr/bin/cc
cd $LFS/sources/
rm -Rf $GCC_P2
echo -e "$DONE"
echo -e $GCC_P2 "$TOOL_READY"
###********************************

echo -e "${DONE}"


STEP2_ENDED=true
    echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$END_STEP2${STEP}*     #
    ############################################### ${NO_STYLE}
    "



#save to SHARED_FILE
SAVE="

#${STEP}
###############################################
#   *${NO_STYLE}$START_STEP2${STEP}*     #
############################################### ${NO_STYLE}

### copied vars to other user
export STEP2_ENDED=$STEP2_ENDED
export NEXT_STEP=$LFS/LFS/bash_sources/step3.sh
export TIMEZONES=\"$(timedatectl list-timezones)\" #needed in step 5

"
echo "$SAVE" >> $SHARED_FILE
if ! [ -n "$STEP3_ENDED" ] || ! $STEP3_ENDED; then
    echo -e "$DONE"
    echo -e "STEP2_ENDED=$STEP2_ENDED"
    echo -e "$RUN_CMD_TO_START_NEXT_STEP"
    echo "bash \$NEXT_STEP"
    echo -e "$SWICH_TO_ROOT"

    su #root
fi

