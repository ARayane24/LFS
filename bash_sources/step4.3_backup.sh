#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

echo -e "$BACKING_UP_PROGRESS_TO_TARBALL"
#unmount the virtual file systems
mountpoint -q $LFS/dev/shm && umount $LFS/dev/shm
umount $LFS/dev/pts
umount $LFS/{sys,proc,run,dev}

# compress tools
cd /
tar -cJpf $HOME/${DISTRO_NAME}-temp-tools.tar.xz . || exit 1
mv ${DISTRO_NAME}-temp-tools.tar.xz /LFS
echo -e "$DONE"