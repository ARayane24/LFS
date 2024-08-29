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

### Gettext
echo -e "$START_JOB"
echo $Gettext
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
echo -e "$START_JOB"
echo $Bison
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
echo -e "$START_JOB"
echo $Perl
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
echo -e "$START_JOB"
echo Python
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
echo -e "$START_JOB"
echo $Textinfo
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
echo -e "$START_JOB"
echo $Util_linux
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
cd /LFS/bash_sources

if $BACK_UP_OS_IN_THE_END; then
    source ./step4.3_backup.sh

    EXIT_AFTER_BACKUP=$(yes_no_question "$DO_YOU_WANNA_EXIT_AFTER_BACKUP")
else
    EXIT_AFTER_BACKUP=false
fi


STEP4_ENDED=true
    echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$END_STEP4${STEP}*       #
    ############################################### ${NO_STYLE}
    "


#save to SHARED_FILE
SAVE="

#${STEP}
###############################################
#   *${NO_STYLE}$START_STEP4${STEP}*     #
############################################### ${NO_STYLE}

### copied vars to other user
export STEP4_ENDED=$STEP4_ENDED
export NEXT_STEP=/LFS/bash_sources/step5.sh

"
echo "$SAVE" >> /.bashrc


if $EXIT_AFTER_BACKUP; then
    echo -e "$SELECTED_EXIT_AFTER_BACKUP"
    echo -e "cp \$LFS/.bashrc \$SHARED_FILE"
    exit 0
else
    echo -e "$SELECTED_DONNT_EXIT_AFTER_BACKUP"
    source ./step5.sh
fi
