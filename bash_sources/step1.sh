#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing


#***************************************************************************#
#####################################################
#                      *  settings  *               #
#####################################################
# Important vars
export USER=true #true : use the user inputs else use the default
export SAVE_Partition=true
export Logs_path="$HELPER_DIR/logs" #show results only
# copied vars to other user
export DEV_NAME=lfs
export DISTRO_NAME=lfs
export DESTRO_HOSTNAME=lfs


#***************************************************************************#
if $USER; then
    echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$START_STEP0${STEP}*   #
    ############################################### ${NO_STYLE}
    "
    export DEV_NAME=$(read_non_empty_string "${INPUT_NEW_USER_NAME_msg}" )
    echo -e "\n"

    export DISTRO_NAME=$(read_non_empty_string "${INPUT_THE_NAME_OF_THE_NEW_DISTRO_msg}")
    echo -e "\n"
    
    export DESTRO_HOSTNAME=$(read_non_empty_string "${INPUT_HOST_NAME}")
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


########################
###** Start chap 2 **###
########################

#export Important vars
export LFS=/mnt/$DISTRO_NAME
export PATH=$PATH:/usr/sbin #to let the os find all the commands

#create partion
create_and_save_partition $LFS $SAVE_Partition || {
    echo -e "$STOP_MSG_ERROR"
    exit 1
}


########################
###** Start chap 3 **###
########################

cp -rf $HELPER_DIR $LFS
chmod -v a+wt $LFS/LFS #all users can write. only the owner of the file who can delete it


#mouve sources if found to sources dir in the partion file
mv -f $LFS/LFS/sources $LFS || downlaod_code_source_pkgs $LFS

chmod -v a+wt $LFS/sources #all users can write. only the owner of the file who can delete it
#change the owner to root
chown root:root $LFS/sources/*
chown root:root $LFS/LFS/*


########################
###** Start chap 4 **###
########################


echo -e "$CREATE_DIR_TO_PUT_RESULTS_OF_COMPILE"
mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}
for i in bin lib sbin; do
    ln -sv usr/$i $LFS/$i #creating shortcuts from the working dir to the main system files
done
#if system is 64bit than mkdir lib64
case $CPU_SELECTED_ARCH in
    x86_64) mkdir -pv $LFS/lib64 ;;
esac
mkdir -pv $LFS/tools
echo -e "$DONE \n"


echo -e "$ADD_USER_AND_GROUPE"

groupadd $DEV_NAME
useradd -s /bin/bash -g $DEV_NAME -m -k /dev/null $DEV_NAME

passwd $DEV_NAME #password for user

#Setting the owner to DEV_NAME
chown -v $DEV_NAME $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools} || {
    echo -e "$STOP_MSG_ERROR"
    exit 1
}
case $CPU_SELECTED_ARCH in
    x86_64) chown -v $DEV_NAME $LFS/lib64 ;;
esac
fg #connfirme that there is no error
echo -e "$DONE \n"

STEP1_ENDED=true
export NEXT_STEP=$LFS/LFS/bash_sources/step2.1.sh

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
export DESTRO_HOSTNAME=$DESTRO_HOSTNAME
export STEP1_ENDED=$STEP1_ENDED
export LFS=/mnt/$DISTRO_NAME
export PATH=$PATH:/usr/sbin #to let the os find all the commands
export NEXT_STEP=$NEXT_STEP
"
echo "$SAVE" >> $SHARED_FILE
echo -e "$DONE"

if ! [ -n "$STEP2_ENDED" ] || ! $STEP2_ENDED; then
    echo -e "STEP1_ENDED=$STEP1_ENDED"
    echo -e "$SWICH_TO_LFS"
fi

# debug_mode true
su - "$DEV_NAME" -c " bash $NEXT_STEP " #change the user && run $NEXT_STEP

source $SHARED_FILE #update the value of $NEXT_STEP

#source $SHARED_FILE
if { [ -z "$STEP3_ENDED" ] || [ "$STEP3_ENDED" = "false" ]; } && [ "$STEP2_ENDED" = "true" ]; then
    source $NEXT_STEP # $LFS/LFS/bash_sources/step3.sh
fi

