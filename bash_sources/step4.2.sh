#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing


#***************************************************************************#

cd /LFS/bash_sources
source /.bashrc
source ./terminal_params/_pakages_names.sh
source ./terminal_params/_util_methodes.sh

# The /var/log/wtmp file records all logins and logouts. The /var/log/lastlog file records when each user last logged in.
# The /var/log/faillog file records failed login attempts. The /var/log/btmp file records the bad login attempts.
touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp
# The /run/utmp file records the users that are currently logged in. This file is created dynamically in the boot scripts.

cd /sources 
echo -e $CURRENT_USER

echo -e "$START_EXTRACTION"
extract_tar_files /sources/ "$Gettext_Tool      $Bison_Tool       $Perl_Tool     " &
extract_tar_files /sources/ "$Texinfo_Tool      $Util_linux       $Python_Tool   "
wait
echo -e "$DONE"


### Gettext
echo -e "$START_JOB" " 1.1 SBU"
echo $Gettext_Tool
cd $Gettext_Tool

./configure --disable-shared

make
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin

cd /sources 
rm -Rf $Gettext_Tool
echo -e "$DONE"
echo -e $Gettext_Tool "$TOOL_READY"
#-------------------

debug_mode true

### Bison
echo -e "$START_JOB" " 0.2 SBU"
echo $Bison_Tool
cd $Bison_Tool

./configure --prefix=/usr \
            --docdir=/usr/share/doc/$Bison_Tool

make && make install
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

cd /sources 
rm -Rf $Bison_Tool
echo -e "$DONE"
echo -e $Bison_Tool "$TOOL_READY"
#-------------------

debug_mode true

### Perl
echo -e "$START_JOB" " 0.6 SBU"
echo $Perl_Tool
cd $Perl_Tool

sh Configure -des                                        \
             -D prefix=/usr                               \
             -D vendorprefix=/usr                         \
             -D useshrplib                                \
             -D privlib=/usr/lib/perl5/$Perl_V/core_perl     \
             -D archlib=/usr/lib/perl5/$Perl_V/core_perl     \
             -D sitelib=/usr/lib/perl5/$Perl_V/site_perl     \
             -D sitearch=/usr/lib/perl5/$Perl_V/site_perl    \
             -D vendorlib=/usr/lib/perl5/$Perl_V/vendor_perl \
             -D vendorarch=/usr/lib/perl5/$Perl_V/vendor_perl

make && make install
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

cd /sources 
rm -Rf $Perl_Tool
echo -e "$DONE"
echo -e $Perl_Tool "$TOOL_READY"
#-------------------

debug_mode true

### Python
echo -e "$START_JOB" " 0.4 SBU"
echo Python
cd $Python_Tool

./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip

make && make install
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

cd /sources 
rm -Rf $Python_Tool
echo -e "$DONE"
echo -e $Python_Tool "$TOOL_READY"
#-------------------

debug_mode true

### Texinfo
echo -e "$START_JOB" " 0.2 SBU"
echo $Textinfo
cd $Texinfo_Tool

./configure --prefix=/usr

make && make install
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

cd /sources 
rm -Rf $Texinfo_Tool
echo -e "$DONE"
echo -e $Texinfo_Tool "$TOOL_READY"
#-------------------

debug_mode true

### Util-linux
echo -e "$START_JOB" " 0.2 SBU"
echo $Util_linux
cd $Util_linux

mkdir -pv /var/lib/hwclock
./configure --libdir=/usr/lib     \
            --runstatedir=/run    \
            --disable-chfn-chsh   \
            --disable-login       \
            --disable-nologin     \
            --disable-su          \
            --disable-setpriv     \
            --disable-runuser     \
            --disable-pylibmount  \
            --disable-static      \
            --disable-liblastlog2 \
            --without-python      \
            ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --docdir=/usr/share/doc/$Util_linux

make && make install
if [ $? -ne 0 ]; then
    echo -e "$BUILD_FAILED"
    exit 1
fi
echo -e "$BUILD_SUCCEEDED"

cd /sources 
rm -Rf $Util_linux
echo -e "$DONE"
echo -e $Util_linux "$TOOL_READY"
#-------------------

debug_mode true

echo -e "$START_CLEANING_JOB"
rm -rf /usr/share/{info,man,doc}/*          # remove the currently installed documentation files
find /usr/{lib,libexec} -name \*.la -delete # can cause BLFS package failures. Remove those files now:
rm -rf /tools                               # delete tools
echo -e "$DONE"
cd /LFS/bash_sources


STEP4_ENDED=true
    echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$END_STEP4${STEP}*       #
    ############################################### ${NO_STYLE}
    "

SAVE="
#${STEP}
###############################################
#   *${NO_STYLE}$START_STEP4${STEP}*     #
############################################### ${NO_STYLE}

### copied vars to other user
export STEP4_ENDED=$STEP4_ENDED
"
echo "$SAVE" >> /.bashrc

debug_mode true
if $BACK_UP_OS_IN_THE_END; then
    exit 0
fi


source ./step5.1.sh
