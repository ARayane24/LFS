#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing


#***************************************************************************#
    echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$START_STEP3${STEP}*   #
    ############################################### ${NO_STYLE}
    "

#############################################################
echo -e "${PROCESS}Entering Chroot and Building Additional Temporary Tools...${NO_STYLE}"
#############################################################

findmnt # check For proper operation of the isolated environment, some communication with the running kernel must be established. This is done via the so-called Virtual Kernel File Systems, which will be mounted before entering the chroot environment. 

#change the ownership of the $LFS/* directories to user root 
chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -R root:root $LFS/lib64 ;;
esac
echo -e "${DONE}"

#creating the directories on which virtual file systems will be mounted
mkdir -pv $LFS/{dev,proc,sys,run}




STEP3_ENDED=true
    echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$END_STEP3${STEP}* these      #
    ############################################### ${NO_STYLE}
    "


#save to SHARED_FILE
SAVE="

#${STEP}
###############################################
#   *${NO_STYLE}$START_STEP3${STEP}*     #
############################################### ${NO_STYLE}

### copied vars to other user
export STEP3_ENDED=true
export NEXT_STEP=$HELPER_DIR/bash_sources/step3.sh

"
echo "$SAVE" >> $SHARED_FILE

