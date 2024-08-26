#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing


#***************************************************************************#

cd /sources 

### Gettext
tar -xf "$Gettext.tar.xz"
cd $Gettext
./configure --disable-shared
make --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
cd /sources 
rm -Rf $Gettext
echo -e "$DONE"
echo -e $Gettext "$TOOL_READY"
#-------------------



### Bison
tar -xf "$Bison.tar.xz"
cd $Bison
./configure --prefix=/usr \
            --docdir=/usr/share/doc/$Bison
make --silent && make install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
cd /sources 
rm -Rf $Bison
echo -e "$DONE"
echo -e $Bison "$TOOL_READY"
#-------------------



### Perl
tar -xf "$Perl.tar.xz"
cd $Perl

sh Configure -des                                        \
             -Dprefix=/usr                               \
             -Dvendorprefix=/usr                         \
             -Duseshrplib                                \
             -Dprivlib=/usr/lib/perl5/5.38/core_perl     \
             -Darchlib=/usr/lib/perl5/5.38/core_perl     \
             -Dsitelib=/usr/lib/perl5/5.38/site_perl     \
             -Dsitearch=/usr/lib/perl5/5.38/site_perl    \
             -Dvendorlib=/usr/lib/perl5/5.38/vendor_perl \
             -Dvendorarch=/usr/lib/perl5/5.38/vendor_perl
make --silent && make install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
cd /sources 
rm -Rf $Perl
echo -e "$DONE"
echo -e $Perl "$TOOL_READY"
#-------------------



### Python
tar -xf "$Python.tar.xz"
cd $Python

./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip
make --silent && make install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
cd /sources 
rm -Rf $Python
echo -e "$DONE"
echo -e $Python "$TOOL_READY"
#-------------------



### Texinfo
tar -xf "$Texinfo.tar.xz"
cd $Texinfo

./configure --prefix=/usr
make --silent && make install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
cd /sources 
rm -Rf $Texinfo
echo -e "$DONE"
echo -e $Texinfo "$TOOL_READY"
#-------------------



### Util-linux
tar -xf "$Util_linux.tar.xz"
cd $Util_linux

mkdir -pv /var/lib/hwclock
./configure --libdir=/usr/lib    \
            --runstatedir=/run   \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python     \
            ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --docdir=/usr/share/doc/$Util_linux
make --silent && make install --silent
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
cd /sources 
rm -Rf $Util_linux
echo -e "$DONE"
echo -e $Util_linux "$TOOL_READY"
#-------------------


echo -e "$START_CLEANING_JOB"
rm -rf /usr/share/{info,man,doc}/*          # remove the currently installed documentation files
find /usr/{lib,libexec} -name \*.la -delete # can cause BLFS package failures. Remove those files now:
rm -rf /tools                               # delete tools
echo -e "$DONE"

if $BACK_UP_OS_IN_THE_END; then
    source ./step4.3_backup.sh
fi

source ./step5.sh