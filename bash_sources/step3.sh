#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing


########################
###** Start chap 7 **###
########################

cd $LFS/LFS/bash_sources
#***************************************************************************#
    echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$START_STEP3${STEP}*   #
    ############################################### ${NO_STYLE}
    "
echo -e $CURRENT_USER
# debug_mode true
findmnt # check For proper operation of the isolated environment, some communication with the running kernel must be established. This is done via the so-called Virtual Kernel File Systems, which will be mounted before entering the chroot environment. 

#change the ownership of the $LFS/* directories to user root 
chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $CPU_SELECTED_ARCH in
  x86_64) chown -R root:root $LFS/lib64 ;;
esac
echo -e "${DONE}"

#creating the directories on which virtual file systems will be mounted
mkdir -pv $LFS/{dev,proc,sys,run}


mount -v --bind /dev $LFS/dev
mount -vt devpts devpts -o gid=5,mode=0620 $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  install -v -d -m 1777 $LFS$(realpath /dev/shm)
else
  mount -vt tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
fi



STEP3_ENDED=true
export NEXT_STEP=/LFS/bash_sources/step4.1.sh
    echo -e "${STEP}
    ###############################################
    #     *${NO_STYLE}$END_STEP3${STEP}*         #
    ############################################### ${NO_STYLE}
    "


#save to SHARED_FILE
SAVE="

#${STEP}
###############################################
#   *${NO_STYLE}$START_STEP3${STEP}*     #
############################################### ${NO_STYLE}

### copied vars to other user
export STEP3_ENDED=$STEP3_ENDED
export NEXT_STEP=$NEXT_STEP

"
echo "$SAVE" >> $SHARED_FILE

cp -v $SHARED_FILE $LFS/.bashrc #keep shared vars
# debug_mode true

if ! [ -n "$STEP5_ENDED" ] || ! $STEP5_ENDED; then
    echo -e "$DONE"
    echo -e "STEP3_ENDED=$STEP3_ENDED"

    #entering chroot you can set other vars here also 
    chroot "$LFS" /usr/bin/env -i   \
            HOME=/root                  \
            TERM="$TERM"                \
            PS1='(lfs chroot) \u:\w\$ ' \
            PATH=/usr/bin:/usr/sbin     \
            MAKEFLAGS="-j$(nproc)"      \
            TESTSUITEFLAGS="-j$(nproc)" \
            /bin/bash --login -c "bash $NEXT_STEP"

    # return from chroot :
    if [ -z "$LFS" ]; then
      echo "$LFS_IS_NOT_SET"
      exit 1
    fi
    cat $LFS/.bashrc > $SHARED_FILE #update shared file with last vars
    source $SHARED_FILE
    # debug_mode true

    if $BACK_UP_OS_IN_THE_END; then

      source ./step4.3_backup.sh

      SAVE="
      # Backup
      export BACK_UP_OS_IN_THE_END=false #already has been done !!
      "
      echo "$SAVE" >> $SHARED_FILE
      echo "$SAVE" >> $LFS/.bashrc #keep shared vars

      if $EXIT_AFTER_BACKUP; then
          echo -e "$SELECTED_EXIT_AFTER_BACKUP"
          exit 0
      else
          echo -e "$SELECTED_DONNT_EXIT_AFTER_BACKUP"
          bash $LFS/LFS/bash_sources/step3.sh || bash /LFS/bash_sources/step3.sh
      fi
    fi
fi