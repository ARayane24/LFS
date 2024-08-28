#!/bin/bash
# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

 echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$START_STEP7${STEP}*   #
    ############################################### ${NO_STYLE}
    "

rm -rf /tmp/*
find /usr/lib /usr/libexec -name \*.la -delete
find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf
userdel -r tester

 echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$END_STEP7${STEP}*     #
    ############################################### ${NO_STYLE}
    "

bash /LFS/bash_sources/step8.sh