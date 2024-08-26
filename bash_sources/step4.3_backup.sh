#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

echo -e "$BACKING_UP_PROGRESS_TO_TARBALL"
#unmount the virtual file systems
mountpoint -q $LFS/dev/shm && umount $LFS/dev/shm
umount $LFS/dev/pts
umount $LFS/{sys,proc,run,dev}

# compress tools
cd $LFS
tar -cJpf $HOME/lfs-temp-tools-12.1.tar.xz .
echo -e "$DONE"