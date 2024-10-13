#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

source ./utils.sh

## create test user 
useradd -m -s /bin/bash tester
groupadd -g 102 dummy
usermod -aG dummy tester