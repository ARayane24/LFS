#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

cd $LFS/_myhelper/bash_sources || cd /_myhelper/bash_sources 

echo -e "$RESTORE_PROGRESS_TO_TARBALL"
if [ -z "$LFS" ]; then
  echo "$LFS_IS_NOT_SET"
  exit 1
fi
cd $LFS
rm -rf ./*
tar -xpf $HOME/lfs-temp-tools-12.1.tar.xz
echo "$DONE"
BACK_UP_OS_IN_THE_END=false #already has been done !!
SAVE="
    # Backup
    export BACK_UP_OS_IN_THE_END=${BACK_UP_OS_IN_THE_END}
    "
    echo "$SAVE" >> $SHARED_FILE
source ./step3.sh