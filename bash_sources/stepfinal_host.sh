#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

#restore default !!
mv /etc/bash.bashrc.NOUSE /etc/bash.bashrc
if [ -z "$LFS" ]; then
  echo "$LFS_IS_NOT_SET"
  exit 1
fi
rm -Rf $LFS/*
userdel -r $DEV_NAME
groupdel $DEV_NAME
exit
