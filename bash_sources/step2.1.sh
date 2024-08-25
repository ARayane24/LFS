#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing


source ./_pakages_names.sh
#***************************************************************************#
        echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$START_STEP2${STEP}*   #
    ############################################### ${NO_STYLE}
    "

#creating new bash profile for the new user by Adding some lines to the file ~/.bash_profile to isolate variables from the host system and prevent them from being leaked into the build environment
lines="exec env -i HOME=\$HOME TERM=\$TERM PS1='\u:\w\\$ ' /bin/bash "
echo "$lines" > ~/.bash_profile
echo -e "$DONE \n"

# Define variables for each part of the content
disable_hashing="set +h" #to force the shell to search the PATH whenever a program is to be run. the shell will find the newly compiled tools in $LFS/tools/bin as soon as they are available without remembering a previous version of the same program provided by the host distro, in /usr/bin or /bin.
set_umask="umask 022" # ensures that newly created files and directories are only writable by their owner, but are readable and executable by anyone
set_lfs_dir="LFS=${LFS}"
set_locale="LC_ALL=POSIX"
set_target="LFS_TGT=${CPU_SELECTED_ARCH}-${DISTRO_NAME}-linux-gnu"
set_path="/usr/bin"
conditional_path='if [ ! -L /bin ]; then PATH=/bin:$PATH; fi'
extend_path="PATH=\$LFS/tools/bin:\$PATH"
set_config_site="CONFIG_SITE=\$LFS/usr/share/config.site"
export_vars="export LFS LC_ALL LFS_TGT PATH CONFIG_SITE"
export_var_MAKEFLAGS="export MAKEFLAGS=-j$(nproc)"

# Combine all parts into a single variable
lines="$disable_hashing
$set_umask
$set_lfs_dir
$set_locale
$set_target
PATH=$set_path
$conditional_path
$extend_path
$set_config_site
$export_vars
$export_var_MAKEFLAGS"



# Write the combined content to ~/.bashrc
cat $SHARED_FILE > ~/.bashrc
echo "$lines" >> ~/.bashrc
echo -e "$DONE"
bash -n ~/.bash_profile

source ./step2.2.sh