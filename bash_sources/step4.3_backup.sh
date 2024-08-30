#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing
    

echo -e "$BACKING_UP_PROGRESS_TO_TARBALL"

if [ -z "$LFS" ]; then
  echo "$LFS_IS_NOT_SET"
  exit 1
fi

#unmount the virtual file systems
mountpoint -q $LFS/dev/shm && umount $LFS/dev/shm
umount $LFS/dev/pts
umount $LFS/{sys,proc,run,dev}

# compress tools
cd $LFS
tar -cvJpf $HOME/${DISTRO_NAME}-temp-tools.tar.xz . || exit 1
echo -e "$DONE"
echo $HOME/${DISTRO_NAME}-temp-tools.tar.xz

export EXIT_AFTER_BACKUP=$(yes_no_question "$DO_YOU_WANNA_EXIT_AFTER_BACKUP")