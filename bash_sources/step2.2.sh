#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

source ~/.bashrc
source ./terminal_params/_util_methodes.sh
source ./terminal_params/_pakages_names.sh


rm /bin/sh
ln -s /usr/bin/bash /bin/sh
rm /usr/bin/awk
ln -s /usr/bin/gawk /usr/bin/awk
rm /usr/bin/yacc
ln -s /usr/bin/bison /usr/bin/yacc
echo -e "$DONE"


echo -e "$N_THREADS $(nproc)"
if [ -z "${LFS_TGT+x}" ]; then
    echo "Variable is not defined. Exiting."
    exit 1
fi
cd $LFS/sources/

#extract_all_files
echo -e "$START_EXTRACTION"
extract_tar_files_and_mkdir $LFS/sources "$Binutils_P1   $GCC_P1     $Linux_Kernel   $Glibc_Tool     $Libstdc_Tool   $M4_Tool    $Ncurses_Tool   $Bash_Tool  $Coreutils_Tool $Diffutils_Tool $File_Tool $Findutils_Tool" &
extract_tar_files_and_mkdir $LFS/sources "$Gawk_Tool     $Grep_Tool  $Gzip_Tool      $Make_Tool      $Patch_Tool     $Sed_Tool   $Tar_Tool       $Xz_Tool"
wait
echo -e "$DONE"

#############################################################
echo -e "${PROCESS}Compiling a Cross-Toolchain...${NO_STYLE}"
#############################################################
# native toolchain : build == host == target
# cross-compilation toolchain : build == host != target
# canadian cross-compilation toolchain : build != host != target
# key :
#   - build  : is the machine where we build programs (Default OS on pc NOTE: debian)
#   - host   : is the machine/system where the built programs will run ie: where to run the compiler
#   - target : is only used for compilers. It is the machine the compiler produces code for 

###binutils 1 : assambly -> bin
echo -e "$START_JOB" " 1 SBU"
echo $Binutils_P1

time {
    cd $Binutils_P1/build
    # "--prefix=$LFS/tools" install the Binutils programs in the $LFS/tools directory.
    # "--with-sysroot=$LFS" look in $LFS for the target system libraries as needed.
    # "--target=$LFS_TGT" target tuple 

    ../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror    \
             --enable-new-dtags  \
             --enable-default-hash-style=gnu

    make  && make install 
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd $LFS/sources/
    rm -Rf $Binutils_P1 #rm extracted pkg
    echo " 1 SBU = " 
}
echo -e "$DONE" 
echo -e $Binutils_P1 "$TOOL_READY"
###********************************

# debug_mode true

###GCC: Source code -> assambly (NOTE: is not a compiler it drives the compilation op only -the compiler is cc1-)
echo -e "$START_JOB" " 3.2 SBU"
echo $GCC_P1" 1 SBU"
cd $GCC_P1
tar -xf ../$GCC_P1_mpfr.tar.xz
mv -v $GCC_P1_mpfr mpfr
tar -xf ../$GCC_P1_gmp.tar.xz
mv -v $GCC_P1_gmp gmp
tar -xf ../$GCC_P1_mpc.tar.gz
mv -v $GCC_P1_mpc mpc

#If the system's architecture is x86_64, it modifies the gcc/config/i386/t-linux64 file by replacing lib64 with lib on any line that contains m64=. The original file is backed up with the extension .orig.
# It adjusts the configuration to ensure that certain libraries are found in the correct directory,
case $CPU_SELECTED_ARCH in
x86_64)
    sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
;;
esac

cd  build

../configure                  \
    --target=$LFS_TGT         \
    --prefix=$LFS/tools       \
    --with-glibc-version=2.40 \
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

make  && make install 
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include/limits.h

cd $LFS/sources/
rm -Rf $GCC_P1
echo -e "$DONE"
echo -e $GCC_P1"$TOOL_READY"
###********************************

# debug_mode true

###Linux-6 headers
echo -e "$START_JOB" " 0.1 SBU"
echo $Linux_Kernel
cd $Linux_Kernel

make mrproper   && make headers 
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr

cd $LFS/sources/
rm -Rf $Linux_Kernel
echo -e "$DONE" 
echo -e $Linux_Kernel "$TOOL_READY"
###********************************

# debug_mode true

###glibc (or uClibc/uClibc-ng :only for linux and suports ARM)
echo -e "$START_JOB" " 1.3 SBU"
echo $Glibc_Tool
cd $Glibc_Tool

case $CPU_SELECTED_ARCH in
    i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
    ;;
esac

patch -Np1 -i ../$Glibc_Tool-fhs-1.patch

cd   build
echo "rootsbindir=/usr/sbin" > configparms

../configure                             \
      --prefix=/usr                      \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=4.19               \
      --with-headers=$LFS/usr/include    \
      --disable-nscd                     \
      libc_cv_slibdir=/usr/lib

make  && make DESTDIR=$LFS install 
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd

#test
echo -e "$START_TEST"
echo 'int main(){}' | $LFS_TGT-gcc -xc -
echo -e "$EXPECT_OUTPUT"
echo "[Requesting program interpreter: /lib64/ld-linux-x86-64.so.2] or for 32-bit machines, the interpreter name will be /lib/ld-linux.so.2"
# Check the program interpreter using readelf and grep for ld-linux
output=$(readelf -l a.out | grep ld-linux)
echo -e "\n$REAL_OUTPUT"
echo $output

# Expected output format check
if echo "$output" | grep -E '/lib(64)?/ld-linux(-x86-64)?\.so\.2'; then
    echo -e "$TEST_PASS"
else
    exit 1
fi
rm -v a.out

cd $LFS/sources/
rm -Rf $Glibc_Tool
echo -e "$DONE" 
echo -e $Glibc_Tool "$TOOL_READY"
###********************************

# debug_mode true

### $Libstdc_Tool
echo -e "$START_JOB"
echo $GCC_P1
extract_tar_files_and_mkdir $LFS/sources "$GCC_P1"
cd $GCC_P1/build

../$Libstdc_Tool-v3/configure           \
    --host=$LFS_TGT                 \
    --build=$(../config.guess)      \
    --prefix=/usr                   \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/$GCC_V

make  && make DESTDIR=$LFS install 
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

# debug_mode true
echo -e "${DONE}"

########################
###** Start chap 6 **###
########################

#############################################################
echo -e "${PROCESS}Cross Compiling Temporary Tools...${NO_STYLE}"
#############################################################
### M4
echo -e "$START_JOB" " 0.1 SBU"
echo $M4_Tool
cd $M4_Tool

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make  && make DESTDIR=$LFS install 
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

cd $LFS/sources/
rm -Rf $M4_Tool
echo -e "$DONE" 
echo -e $M4_Tool "$TOOL_READY"
###********************************

# debug_mode true

### Ncurses
echo -e "$START_JOB" " 0.4 SBU"
echo $Ncurses_Tool
cd $Ncurses_Tool

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
            --disable-stripping

make  && make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install 
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

ln -sv libncursesw.so $LFS/usr/lib/libncurses.so
sed -e 's/^#if.*XOPEN.*$/#if 1/' -i $LFS/usr/include/curses.h

cd $LFS/sources/
rm -Rf $Ncurses_Tool
echo -e "$DONE"
echo -e $Ncurses_Tool "$TOOL_READY"
###********************************

# debug_mode true

### Bash
echo -e "$START_JOB" " 0.2 SBU"
echo $Bash_Tool
cd $Bash_Tool

./configure --prefix=/usr                       \
            --build=$(sh support/config.guess)  \
            --host=$LFS_TGT                     \
            --without-bash-malloc               \
            bash_cv_strtold_broken=no

make  && make DESTDIR=$LFS install 
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

ln -sv bash $LFS/bin/sh

cd $LFS/sources/
rm -Rf $Bash_Tool
echo -e "$DONE" 
echo -e $Bash_Tool "$TOOL_READY"
###********************************

# debug_mode true

### Coreutils
echo -e "$START_JOB" " 0.3 SBU"
echo $Coreutils_Tool
cd $Coreutils_Tool

./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime

make  && make DESTDIR=$LFS install 
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
rm -Rf $Coreutils_Tool
echo -e "$DONE" $Coreutils_Tool
echo -e $Coreutils_Tool "$TOOL_READY"
###********************************

# debug_mode true

### Diffutils
echo -e "$START_JOB" " 0.1 SBU"
echo $Diffutils_Tool
cd $Diffutils_Tool

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)

make  && make DESTDIR=$LFS install 
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

cd $LFS/sources/
rm -Rf $Diffutils_Tool
echo -e "$DONE" 
echo -e $Diffutils_Tool "$TOOL_READY"
###********************************

# debug_mode true

### File
echo -e "$START_JOB" " 0.1 SBU" 
echo $File_Tool
cd $File_Tool
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
rm -Rf $File_Tool
echo -e "$DONE" 
echo -e $File_Tool "$TOOL_READY"
###********************************

# debug_mode true

### Findutils
echo -e "$START_JOB" " 0.2 SBU"
echo $Findutils_Tool
cd $Findutils_Tool

./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$LFS_TGT                 \
            --build=$(build-aux/config.guess)

make  && make DESTDIR=$LFS install 
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

cd $LFS/sources/
rm -Rf $Findutils_Tool
echo -e "$DONE" 
echo -e $Findutils_Tool "$TOOL_READY"
###********************************

# debug_mode true

### Gawk
echo -e "$START_JOB" " 0.1 SBU"
echo $Gawk_Tool
cd $Gawk_Tool

sed -i 's/extras//' Makefile.in
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make  && make DESTDIR=$LFS install 
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

cd $LFS/sources/
rm -Rf $Gawk_Tool
echo -e "$DONE"
echo -e  $Gawk_Tool "$TOOL_READY"
###********************************

# debug_mode true

### Grep
echo -e "$START_JOB" " 0.1 SBU"
echo $Grep_Tool
cd $Grep_Tool

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)

make  && make DESTDIR=$LFS install 
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

cd $LFS/sources/
rm -Rf $Grep_Tool
echo -e "$DONE" 
echo -e  $Grep_Tool "$TOOL_READY"
###********************************

# debug_mode true

### Gzip
echo -e "$START_JOB" " 0.1 SBU"
echo $Gzip_Tool
cd $Gzip_Tool

./configure --prefix=/usr --host=$LFS_TGT

make  && make DESTDIR=$LFS install 
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

cd $LFS/sources/
rm -Rf $Gzip_Tool
echo -e "$DONE" 
echo -e $Gzip_Tool "$TOOL_READY"
###********************************

# debug_mode true

### Make
echo -e "$START_JOB" " 0.1 SBU"
echo $Make_Tool
cd $Make_Tool

./configure --prefix=/usr   \
            --without-guile \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make  && make DESTDIR=$LFS install 
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

cd $LFS/sources/
rm -Rf $Make_Tool
echo -e "$DONE" 
echo -e $Make_Tool "$TOOL_READY"
###********************************

# debug_mode true

### Patch
echo -e "$START_JOB" " 0.1 SBU"
echo $Patch_Tool
cd $Patch_Tool

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make  && make DESTDIR=$LFS install 
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

cd $LFS/sources/
rm -Rf $Patch_Tool
echo -e "$DONE"
echo -e  $Patch_Tool "$TOOL_READY"
###********************************

# debug_mode true

### Sed
echo -e "$START_JOB" " 0.1 SBU"
echo $Sed_Tool
cd $Sed_Tool

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)

make  && make DESTDIR=$LFS install 
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

cd $LFS/sources/
rm -Rf $Sed_Tool
echo -e "$DONE" 
echo -e $Sed_Tool "$TOOL_READY"
###********************************

# debug_mode true

### Tar
echo -e "$START_JOB" " 0.1 SBU"
echo $Tar_Tool
cd $Tar_Tool

./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess)

make  && make DESTDIR=$LFS install 
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

cd $LFS/sources/
rm -Rf $Tar_Tool
echo -e "$DONE" 
echo -e $Tar_Tool "$TOOL_READY"
###********************************

# debug_mode true

### Xz
echo -e "$START_JOB" " 0.1 SBU"
echo $Xz_Tool
cd $Xz_Tool

./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/$Xz_Tool

make  && make DESTDIR=$LFS install 
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

rm -v $LFS/usr/lib/liblzma.la

cd $LFS/sources/
rm -Rf $Xz_Tool
echo -e "$DONE" 
echo -e $Xz_Tool "$TOOL_READY"
###********************************

# debug_mode true

### Binutils_P2
echo -e "$START_JOB" " 0.4 SBU"
echo $Binutils_P2
extract_tar_files_and_mkdir $LFS/sources "$Binutils_P2"
cd $Binutils_P2

sed '6009s/$add_dir//' -i ltmain.sh
cd    build

../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --enable-gprofng=no        \
    --disable-werror           \
    --enable-64-bit-bfd        \
    --enable-new-dtags         \
    --enable-default-hash-style=gnu

make  && make DESTDIR=$LFS install 
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

# debug_mode true

### GCC 2
echo -e "$START_JOB" " 4.2 SBU"
echo $GCC_P2
extract_tar_files_and_mkdir $LFS/sources "$GCC_P2"
cd $GCC_P2

tar -xf ../$GCC_P2_mpfr.tar.xz
mv -v $GCC_P2_mpfr mpfr
tar -xf ../$GCC_P2_gmp.tar.xz
mv -v $GCC_P2_gmp gmp
tar -xf ../$GCC_P2_mpc.tar.gz
mv -v $GCC_P2_mpc mpc
case $CPU_SELECTED_ARCH in
    x86_64)
        sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
    ;;
esac
sed '/thread_header =/s/@.*@/gthr-posix.h/' -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in

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

make  && make DESTDIR=$LFS install 
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
# debug_mode true


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
echo -e "STEP2_ENDED=$STEP2_ENDED"
echo -e "$SWICH_TO_ROOT"

# debug_mode true

