#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing



#***************************************************************************#
#####################################################
#                      *  settings  *               #
#####################################################
# Important vars
export USER=true #true : use the user inputs else use the default
export SAVE_Partition=true
export THIS_FILE_LOCATION=$(pwd)
export Logs_path=$THIS_FILE_LOCATION/logs #show results only
# copied vars to other user
export DEV_NAME=lfs
export DISTRO_NAME=lfs
export USER_Lang=3


#***************************************************************************#
if $USER; then
    echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$START_STEP0${STEP}*   #
    ############################################### ${NO_STYLE}
    "
    read -p "${INPUT_NEW_USER_NAME_msg}" DEV_NAME
    echo -e "\n"

    read -p "${INPUT_THE_NAME_OF_THE_NEW_DISTRO_msg}" DISTRO_NAME
    echo -e "\n"

    echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$END_STEP0${STEP}*     #
    ############################################### ${NO_STYLE}
    "
fi


    echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$START_STEP1${STEP}*   #
    ############################################### ${NO_STYLE}
    "
#source $SHARED_FILE

#export Important vars
export LFS=/mnt/$DISTRO_NAME
export PATH=$PATH:/usr/sbin #to let the os find all the commands

#create partion
create_and_save_partition $LFS $SAVE_Partition || {
    echo "$STOP_MSG_ERROR"
    return 1
}

cp -rf $HELPER_DIR $LFS/_myhelper
mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources #all users can write. only the owner of the file who can delete it
chmod -v a+wt $LFS/_myhelper #all users can write. only the owner of the file who can delete it


#mouve sources if foound to sources dir in the partion file
mv -rf $LFS/_myhelper/sources $LFS || downlaod_code_source_pkgs $LFS

#change the owner to root
chown root:root $LFS/sources/*
chown root:root $LFS/_myhelper/*


echo -e "$CREATE_DIR_TO_PUT_RESULTS_OF_COMPILE"
mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}
for i in bin lib sbin; do
    ln -sv usr/$i $LFS/$i #creating shortcuts from the working dir to the main system files
done
#if system is 64bit than mkdir lib64
case $(uname -m) in
    x86_64) mkdir -pv $LFS/lib64 ;;
esac
mkdir -pv $LFS/tools
echo -e "$DONE \n"


echo -e "$ADD_USER_AND_GROUPE"

groupadd $DEV_NAME
useradd -s /bin/bash -g $DEV_NAME -m -k /dev/null $DEV_NAME

passwd $DEV_NAME #password for user

#Setting the owner to DEV_NAME
chown -v $DEV_NAME $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
x86_64) chown -v $DEV_NAME $LFS/lib64 ;;
esac
fg #connfirme that there is no error
echo -e "$DONE \n"

    STEP1_ENDED=true

    echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$END_STEP1${STEP}*     #
    ############################################### ${NO_STYLE}
    "


#save to SHARED_FILE
SAVE="

#${STEP}
###############################################
#   *${NO_STYLE}$START_STEP0${STEP}*     #
############################################### ${NO_STYLE}

### copied vars to other user
export DEV_NAME=$DEV_NAME
export DISTRO_NAME=$DISTRO_NAME
export USER_Lang=$USER_Lang
export STEP1_ENDED=$STEP1_ENDED
export LFS=/mnt/$DISTRO_NAME
export PATH=$PATH:/usr/sbin #to let the os find all the commands
export NEXT_STEP=$LFS/_myhelper/bash_sources/step2.1.sh
"
echo "$SAVE" >> $SHARED_FILE




