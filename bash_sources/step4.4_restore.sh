#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing


echo -e "$RESTORE_PROGRESS_TO_TARBALL"
if [ -z "$LFS" ]; then
  echo "$LFS_IS_NOT_SET"
  exit 1
fi
cd $LFS
rm -rf ./*

# debug_mode true

tar -xvpf $HOME/${DISTRO_NAME}-temp-tools.tar.xz
cp -rf $HELPER_DIR $LFS
echo -e "$DONE"
cd $LFS/LFS/bash_sources || cd /LFS/bash_sources 
bash ./step3.sh