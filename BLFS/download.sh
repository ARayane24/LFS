#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing



CODE_SOURCES_INSTALLED=$(yes_no_question "$DO_YOU_HAVE_CODE_SOURCES")

if $CODE_SOURCES_INSTALLED; then
    echo -e "$YOU_HAVE_CODE_SOURCES"
else
    echo -e "$YOU_DONNOT_HAVE_CODE_SOURCES"
    echo -e "$UPDATE_DOWNLOAD_NEEDED_PKGS"
    downlaod_utils_pkgs

    echo -e "$START_DOWNLOAD_CODE_SOURCES"
    wget -nv --input-file=./all-blfs-wget-list --continue --directory-prefix=$LFS/sources/blfs

    chown root:root $LFS/sources/blfs/*
    echo -e "$DONE"
fi
