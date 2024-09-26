#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

SAVE="
###Language
#msgs:
export DO_YOU_WANNA_USE_SYSTEM_V_OR_D=\"Do you want to create system-V ? [y/n] \"
export YEP_USE_STSTEM_V=\"${OK}You have indicated that you want to create system-V\n${NO_STYLE}\"
export NO_USE_STSTEM_D=\"${OK}You have indicated that you want to create system-D\n${NO_STYLE}\"

export CURRENT_USER=\"${PROCESS} The current user is : \$(whoami)\n${NO_STYLE}\"

export DO_YOU_WANNA_KEEP_DEBUG_FILES=\"Do you want to keep the debug files ? [y/n] \"
export YEP_KEEP_DEBUG_FILES=\"${OK}You have indicated that you want to keep them\n${NO_STYLE}\"
export YEP_KEEP_DEBUG_FILES=\"${OK}You have indicated that you do not want to keep them\n${NO_STYLE}\"

export INPUT_POSI_NUMBER=\"Input a positive number (>0): \"
export NO_VALID_NUMBER=\"${ERROR}Error:${NO_STYLE} The parameter is not a valid number\"

export DO_YOU_WANT_TO_EXE_OPTIONNAL_TESTS=\"Do you want to execute recommended and optionnal testes ? [y/n] \"
export DO_ALL_TESTS=\"${OK}You have indicated that you want all the tests to be done\n${NO_STYLE}\"
export DONT_DO_ALL_TESTS=\"${OK}You have indicated that you don not want all the tests to be done (do only the neccessary ones)\n${NO_STYLE}\"

export DO_YOU_WANT_TO_ADD_OPTIONNAL_DOCS=\"Do you want to add documentation for all used pkgs ? [y/n] \"
export ADD_ALL_DOCS=\"${OK}You have indicated that you want to add all documentation of all used pkgs\n${NO_STYLE}\"
export DONT_ADD_ALL_DOCS=\"${OK}You have indicated that you do not want to add all documentation of all used pkgs (only the neccessary ones)\n${NO_STYLE}\"

export RUNING_WITH_FULL_CPU_POWER_FOR_LONG_TIME_HARM_PC=\"${ERROR}IMPORTANT : ${NO_STYLE} Using 100% of your CPU for realy long time could harm your CPU\"
export HOW_MATCH_TIME_SLEEP_IN_SECONDS=\"For How long (in seconds) you want to pause the proccess after each period (5SBU -aprox) ?\"
export EACH_5_SBU_SLEEP=\"Each period the proccess will sleep for : \"
export SLEEPPING_AFTER=\"Sleeping after \"
export WAKINNG=\"Waking up ... \"

export IS_YOUR_TARGET_UEFI=\"Does your target has UEFI bios? [y/n] \"
export YOUR_TARGET_IS_UEFI=\"${OK}You have indicated that your target has UEFI bios \n${NO_STYLE}\"
export YOUR_TARGET_IS_NOT_UEFI=\"${OK}You have indicated that your target has not UEFI bios \n${NO_STYLE}\"

export LFS_IS_NOT_SET=\"${ERROR}ERROR : ${NO_STYLE}The \$LFS var is not set !!\"
export DO_YOU_WANT_HAVING_ONLY_STATIC=\"Do you want us to use only static libs? (otherwais, we'll use dynamic libs when ever it's possible) [y/n] \"
export CHOOSE_CPU_ARCHI=\"Choose your Target CPU-archi \n\"
export ONLY_STATIC=\"${OK}You have indicated that you want us to use only static libs.\n${NO_STYLE}\"
export NOT_ONLY_STATIC=\"${OK}You have indicated that you want us to use dynamic libs when ever we can.\n${NO_STYLE}\"
export DO_YOU_HAVE_CODE_SOURCES=\"Do you have the required pkges ? [y/n] \"
export DO_YOU_WANT_BACKUP_OS_REC=\"Colse to the final steps ${OK}it is recommended${NO_STYLE} to have backup for the progress [requier about 5GB]\"
export DO_YOU_WANT_BACKUP_OS=\"Do you want to backup the progress? [y/n] \"
export YES_BACK_UP_OS=\"${OK}You have indicated that you want us to backup the progress\n${NO_STYLE}\"
export NO_BACK_UP_OS=\"${OK}You have indicated that you do not want us to backup the progress\n${NO_STYLE}\"
export YOU_HAVE_CODE_SOURCES=\"${OK}You have indicated that you have the code sources.\n${NO_STYLE}\"
export YOU_DONNOT_HAVE_CODE_SOURCES=\"${OK}You have indicated that you do not have the code sources.\n${NO_STYLE}\"
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
export WELCOME=\"Welcome to My Program\"
export LOGO=\"Create LFS easily !!\"
#**************
export START_STEP0=\"${TITLE}  START 0 - Getting data from user - ${NO_STYLE}\"
export END_STEP0=\"${TITLE}  END 0 - Getting data from user - ${NO_STYLE}\"
#**************
export START_STEP1=\"${TITLE} START 1 - Create user & partition - ${NO_STYLE}\"
export INPUT_NAME_OF_PARTITION=\"Input the name of partition : \"
export CANNOT_GET_UUID=\"${ERROR}Error:${NO_STYLE} Could not get UUID for \"
export SUCCESS_MOUNT=\"${OK}Disk successfully mounted and fstab updated. ${NO_STYLE}\"
export ERROR_MOUNT=\"${ERROR}Error:${NO_STYLE} Disk could not be mounted. Check /etc/fstab and try again.\"
export CREATE_DIR_TO_PUT_RESULTS_OF_COMPILE=\"${PROCESS}Creating directories to put the results of compilation in it ...${NO_STYLE}\"
export ADD_USER_AND_GROUPE=\"${PROCESS}Adding new user and user group ...${NO_STYLE}\"
export RUN_CMD_TO_START_NEXT_STEP=\"Run this command to start the next step : \"
export END_STEP1=\"${TITLE} END 1 - Create user & partition - ${NO_STYLE}\"
#**************
export START_STEP2=\"${TITLE}  START 2 - Extracting & Compiling - ${NO_STYLE}\"
export SWICH_TO_ROOT=\"${PROCESS} Swiching to Root user of the host ... ${NO_STYLE}\"
export SWICH_TO_LFS=\"${PROCESS} Swiching to \$DEV_NAME user ... ${NO_STYLE}\"
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
export END_STEP2=\"${TITLE}  END 2 - Extracting & Compiling - ${NO_STYLE}\"
#**************
export START_STEP3=\"${TITLE}  START 3 -  Moving to Chroot - ${NO_STYLE}\"
export END_STEP3=\"${TITLE}  END 3 - Moving to Chroot - ${NO_STYLE}\"
#**************
export START_STEP4=\"${TITLE}  START 4 - Adding necessary dirs - ${NO_STYLE}\"
export BACKING_UP_PROGRESS_TO_TARBALL=\"${PROCESS}Backing-up the progress ...${NO_STYLE}\"
export RESTORE_PROGRESS_TO_TARBALL=\"${PROCESS}Restoring the progress ...${NO_STYLE}\"

export DO_YOU_WANNA_EXIT_AFTER_BACKUP=\"Do you want to exit now the backup is complited ?  [y/n] \"
export SELECTED_EXIT_AFTER_BACKUP=\"${PROCESS}You have indicated that you want to exit ... ${NO_STYLE}\"
export SELECTED_DONNT_EXIT_AFTER_BACKUP=\"${PROCESS}You have indicated that you do want to exit, compliting the work ... ${NO_STYLE}\"

export END_STEP4=\"${TITLE}  END 4 - Adding necessary dirs - ${NO_STYLE}\"
#**************
export START_STEP5=\"${TITLE}  START 5 - Building Temporary Tools - ${NO_STYLE}\"
export INPUT_TZ_VALUE=\"Input the result of previous command (TZ value): \"
export VALID_TZ=\"${OK}Valid time zone: ${NO_STYLE}\n\"
export NOT_VALID_TZ=\"${ERROR}ERROR: Invalid time zone. Please try again.${NO_STYLE}\n\"
export END_STEP5=\"${TITLE}  END 5 - Building Temporary Tools - ${NO_STYLE}\"
#**************
export START_STEP6=\"${TITLE}  START 6 - Removing debug files - ${NO_STYLE}\"
export END_STEP6=\"${TITLE}  END 6 - Removing debug files - ${NO_STYLE}\"
#**************
export START_STEP7=\"${TITLE}  START 7 - Cleaning build -   ${NO_STYLE}\"
export END_STEP7=\"${TITLE}  END 7 - Cleaning build -   ${NO_STYLE}\"
#**************
export START_STEP8=\"${TITLE}  START 8 - System config -   ${NO_STYLE}\"
export INPUT_NETWORK_INTERFACE_NAME=\"Enter your network interface name (e.g., eth0, wlan0) or type 'exit' to finish: \"
export FINISHED_ADDING_NW_I_N=\"Finished adding network interfaces.\"
export INPUT_HOST_NAME=\"Enter your hostname (name apears after the @ ex: \\\"root@HOSTNAME:\\\" ): \"
export EMPTY_NW_I_N=\"${ERROR}ERROR: Network interface name cannot be empty.${NO_STYLE} Please try again.\"
export CHOOSE_SYS_LOCAL=\"Choose the system local from the list below : \"
export INPUT_SYS_L_VALUE=\"Input the chosen value : \"
export NOT_VALID_SYS_L=\"${ERROR}ERROR: Not valid local !!${NO_STYLE}\"
export VALID_SYS_L=\"${OK}Your choosen local is : ${NO_STYLE}\"
export INPUT_ANY_CHAR_TO_CONTINUE=\"${OK}(input any char to continue ...) ${NO_STYLE} \"

export INPUT_EFI_System_Partition_NAME=\"Input the name of partition you want to use as efi boot partion (Note: its type should be FAT32) : \"
export INPUT_swp_Partition_NAME=\"Input the name of partition you want to use as swap partion (Note: the name is needed not the full path) : \"
export INPUT_boot_Partition_NAME=\"Input the name of partition you want to use as the boot partion (Note: the name is needed not the full path) : \"
export INPUT_boot_partition_root_NAME=\"Input the name of the boot partion (Note: the needed value should be in the form of (hd<n>,<m>) where n: N° of disk && m: N° of partition in it ex: (hd0,6)) : \"


export MAKING_EM_BOOT_DISK=\"${PROCESS}Making emergency boot disk ...${NO_STYLE}\"
export MAKING_EM_BOOT_DISK=\"${PROCESS}Making the EFI System Partition ...${NO_STYLE}\"
export END_STEP8=\"${TITLE}  END 8 - System config -   ${NO_STYLE}\"
#**************


#actions:
export START_JOB=\"${PROCESS}Making ...${NO_STYLE}\"
export START_CLEANING_JOB=\"${PROCESS} Cleaning ...${NO_STYLE}\"
export DONE=\"${OK}Done${NO_STYLE}\n\"
export STOP_MSG_ERROR=\"${ERROR}ERROR${NO_STYLE}\n\"
export EMPTY_INPUT_IS_NOT_ALLOWED=\"${ERROR}ERROR : EMPTY INPUT IS NOT ALLOWED !!${NO_STYLE}\n\"



export END_OF_BASH_WORK=\"This bash script was made by chroot team in the hackathon (first Linux from scratch in algeria) \n thank you for usig this tool !! \n the next thing you need to do is to reboot your system \"
"

echo "$SAVE" >> $SHARED_FILE

