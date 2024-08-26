#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

SAVE="
###Language
#msgs:
export LFS_IS_NOT_SET=\"${ERROR}ERROR : ${NO_STYLE}The \$LFS var is not set !!\"
export DO_YOU_WANT_HAVING_ONLY_STATIC=\"Do you want us to use only static libs? (otherwais, we'll use dynamic libs when ever it's possible) [y/n] \"
export CHOOSE_CPU_ARCHI=\"Choose your Target CPU-archi \n\"
export ONLY_STATIC=\"${OK}You indicated that you want us to use only static libs.\n${NO_STYLE}\"
export NOT_ONLY_STATIC=\"${OK}You indicated that you want us to use dynamic libs when ever we can.\n${NO_STYLE}\"
export DO_YOU_HAVE_CODE_SOURCES=\"Do you have the code sources? [y/n] \"
export DO_YOU_WANT_BACKUP_OS_REC=\"Colse to the final steps ${OK}it is recommended${NO_STYLE} to have backup for the progress [requier about 5GB]\"
export DO_YOU_WANT_BACKUP_OS=\"Do you want to backup the progress? [y/n] \"
export YES_BACK_UP_OS=\"${OK}You indicated that you want us to backup the progress\n${NO_STYLE}\"
export NO_BACK_UP_OS=\"${OK}You indicated that you do not want us to backup the progress\n${NO_STYLE}\"
export YOU_HAVE_CODE_SOURCES=\"${OK}You indicated that you have the code sources.\n${NO_STYLE}\"
export YOU_DONNOT_HAVE_CODE_SOURCES=\"${OK}You indicated that you do not have the code sources.\n${NO_STYLE}\"
export UPDATE_DOWNLOAD_NEEDED_PKGS=\"${PROCESS}Downlading and updating required packges ...${NO_STYLE}\"
export PLEASE_Y_OR_N=\"${ERROR}Error:${NO_STYLE} Invalid input. Please enter y or n.\"
export STARTING_DOWNLOADS=\"${PROCESS}Starting the download ...${NO_STYLE}\"
export CANNOT_INSTALL_PAKAGES=\"${ERROR}Error:${NO_STYLE} Cannont download necessary packages\"
export MISSING_PARAM=\"${ERROR}Error:${NO_STYLE} Missing params\"
export START_DOWNLOAD_CODE_SOURCES=\"${PROCESS}Downloading the code sources ...${NO_STYLE}\"
export START_DOWNLOAD_CODE_SOURCES_OTHER=\"${PROCESS}Downloading the code sources from other links ...${NO_STYLE}\"
export SELECT_TARGET_ARCHI=\"Enter the number corresponding to your target CPU-archi: \"
export NOT_VALID_NUMBER=\"${ERROR}Error:${NO_STYLE} The parameter is not a valid number.\"
export SELECTED_ARCHI_IS=\"Your target CPU-archi is : \"
export INPUT_NEW_USER_NAME_msg=\"Input new user name: \"
export NO_MATCH_ERROR=\"${ERROR}Error:${NO_STYLE} no match :\"
export INPUT_THE_NAME_OF_THE_NEW_DISTRO_msg=\"Input the name of your new distro: \"
#**************
export START_STEP0=\"${TITLE}  START 0 - getting data from user - ${NO_STYLE}\"
export END_STEP0=\"${TITLE}  END 0 - getting data from user - ${NO_STYLE}\"
#**************
export START_STEP1=\"${TITLE} START 1 - create user & partition - ${NO_STYLE}\"
export INPUT_NAME_OF_PARTITION=\"Input the name of partition : \"
export CANNOT_GET_UUID=\"${ERROR}Error:${NO_STYLE} Could not get UUID for \"
export SUCCESS_MOUNT=\"${OK}Disk successfully mounted and fstab updated. ${NO_STYLE}\"
export ERROR_MOUNT=\"${ERROR}Error:${NO_STYLE} Disk could not be mounted. Check /etc/fstab and try again.\"
export CREATE_DIR_TO_PUT_RESULTS_OF_COMPILE=\"${PROCESS}Creating directories to put the results of compilation in it ...${NO_STYLE}\"
export ADD_USER_AND_GROUPE=\"${PROCESS}Adding new user and user group ...${NO_STYLE}\"
export RUN_CMD_TO_START_NEXT_STEP=\"Run this command to start the next step : \"
export END_STEP1=\"${TITLE} END 1 - create user & partition - ${NO_STYLE}\"
#**************
export START_STEP2=\"${TITLE}  START 2 - extracting & compiling - ${NO_STYLE}\"
export START_EXTRACTION=\"${PROCESS}Extracting files ...${NO_STYLE}\"
export N_THREADS=\"${OK}#number of threads:${NO_STYLE} \"
export START_TEST=\" ${TEST}Starting test ... ${NO_STYLE}\"
export EXPECT_OUTPUT=\" ${TEST}Expected out-put: ${NO_STYLE}\"
export REAL_OUTPUT=\" ${TEST}The real out-put: ${NO_STYLE}\"
export TEST_PASS=\" ${TEST}Test passed ! ${NO_STYLE}\"
export TEST_FAIL=\" ${ERROR}Test failed !! ${NO_STYLE}\"
export BUILD_FAILED=\"${ERROR}Build failed. !!${NO_STYLE}\"
export BUILD_SUCCEEDED=\"${OK}Build succeeded. !!${NO_STYLE}\"
export TOOL_READY=\"${OK}Tool is ready :) \n\n${NO_STYLE}\"
export END_STEP2=\"${TITLE}  END 2 - extracting & compiling - ${NO_STYLE}\"
#**************
export START_STEP3=\"${TITLE}  START 3 -  moving to Chroot - ${NO_STYLE}\"
export END_STEP3=\"${TITLE}  END 3 - moving to Chroot - ${NO_STYLE}\"
#**************
#**************
export START_STEP4=\"${TITLE}  START 4 - Building Temporary Tools - ${NO_STYLE}\"
export BACKING_UP_PROGRESS_TO_TARBALL=\"${PROCESS}Backing-up the progress ...${NO_STYLE}\"
export RESTORE_PROGRESS_TO_TARBALL=\"${PROCESS}Restoring the progress ...${NO_STYLE}\"
export END_STEP4=\"${TITLE}  END 4 - Building Temporary Tools - ${NO_STYLE}\"
#**************


#actions:
export START_JOB=\"${PROCESS}Making ...${NO_STYLE}\"
export START_CLEANING_JOB=\"${PROCESS} Cleaning ...${NO_STYLE}\"
export DONE=\"${OK}Done${NO_STYLE}\n\"
export STOP_MSG_ERROR=\"${ERROR}ERROR${NO_STYLE}\n\"
"

echo "$SAVE" >> $SHARED_FILE

