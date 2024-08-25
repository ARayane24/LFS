#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

if [ -z "$LFS" ]; then
  echo "$LFS_IS_NOT_SET"
  exit 1
fi
cd $LFS
rm -rf ./*
tar -xpf $HOME/lfs-temp-tools-12.1.tar.xz

findmnt | grep $LFS