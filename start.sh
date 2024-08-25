#!/bin/bash
# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

# Tips :
# don't forget to cd to this file location so every thing works fine !!

source /etc/bash.bashrc
if ! [[ -n "${INIT_FOR_SAFETY+x}" ]] && [[ -f /etc/bash.bashrc ]]; then
    clear
    mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE || {
        echo "Error: Failed to move /etc/bash.bashrc."
        exit 1
    }
   
     # Initialize INIT_FOR_SAFETY and append the old bashrc contents
    if ! [[ -n "${INIT_FOR_SAFETY}" ]]; then
        echo 'export INIT_FOR_SAFETY="OK"' > /etc/bash.bashrc || {
            echo "Error: Failed to write to /etc/bash.bashrc."
            exit 1
        }
    fi
    cat /etc/bash.bashrc.NOUSE >> /etc/bash.bashrc || {
        echo "Error: Failed to append /etc/bash.bashrc.NOUSE."
        exit 1
    }

    chmod -v a+wt /etc/bash.bashrc #all users can write and read & only owner can delete
    chmod -v a+wt ./start.sh
    source /etc/bash.bashrc
    
    echo "Init Done !"
fi

if ! [ -n "$STEP1_ENDED" ] || ! $STEP1_ENDED; then
    ######################
    #   *  settings  *   #
    ######################
    # Important vars
    export HELPER_DIR=$(pwd)
    export STEP1_ENDED=false
    export STEP2_ENDED=false
    export STEP3_ENDED=false
    export STEP4_ENDED=false
    export SHARED_FILE=/etc/bash.bashrc

    export CPU_ARCH_HUMAN=("64-bit(x86) architecture" "64-bit(ARM) architecture")
    export CPU_ARCH=("x86_64" "aarch64")
    export CPU_SELECTED_ARCH=$(uname -m) # current cpu archi

    # Prepare the content to be appended
    SAVE="
    # INIT
    export SHARED_FILE=$SHARED_FILE
    export HELPER_DIR=$(pwd)
    export STEP1_ENDED=false
    export STEP2_ENDED=false
    export STEP3_ENDED=false
    export STEP4_ENDED=false

    export CPU_ARCH_HUMAN=$CPU_ARCH_HUMAN
    export CPU_ARCH=$CPU_ARCH
    "
    echo "$SAVE" >> $SHARED_FILE
    source $SHARED_FILE

    # Starting _config
    cd ./bash_sources/terminal_params

    source ./_config.sh
    cd $HELPER_DIR
    source $SHARED_FILE

    #######################
    #   *  downloads  *   #
    #######################
    CODE_SOURCES_INSTALLED=$(yes_no_question "$DO_YOU_HAVE_CODE_SOURCES")

    if $CODE_SOURCES_INSTALLED; then
        echo -e "$YOU_HAVE_CODE_SOURCES"
    else
        echo -e "$YOU_DONNOT_HAVE_CODE_SOURCES"
        echo -e "$UPDATE_DOWNLOAD_NEEDED_PKGS"
        downlaod_utils_pkgs

        echo -e "$START_DOWNLOAD_CODE_SOURCES"
        downlaod_code_source_pkgs $HELPER_DIR
    fi


    #######################
    #   *  backup OS  *   #
    #######################
    BACK_UP_OS_IN_THE_END=$(yes_no_question "$BACK_UP_OS_IN_THE_END")
    #################################
    #   *  static vs dync libs  *   #
    #################################
    STATIC_ONLY=$(yes_no_question "$DO_YOU_WANT_HAVING_ONLY_STATIC")
    #############################
    #   *  target cpu archi *   #
    #############################
    CPU_SELECTED_ARCH=$(select_cpu_archi $SELECT_TARGET_ARCHI)


    SAVE="
    # Backup
    export BACK_UP_OS_IN_THE_END=$BACK_UP_OS_IN_THE_END
    export STATIC_ONLY=$STATIC_ONLY
    export CPU_SELECTED_ARCH=$CPU_SELECTED_ARCH
    "
    echo "$SAVE" >> $SHARED_FILE

    ######################
    #   *  Starting  *   #
    ######################
    cd $HELPER_DIR
    source ./bash_sources/step1.sh
fi

if ! [ -n "$STEP2_ENDED" ] || ! $STEP2_ENDED; then
    echo -e "$DONE"
    echo -e "STEP1_ENDED=$STEP1_ENDED"
    echo -e "$RUN_CMD_TO_START_NEXT_STEP"
    echo "bash \$NEXT_STEP"

    su - $DEV_NAME  #change the user 
fi

if ! [ -n "$STEP3_ENDED" ] || ! $STEP3_ENDED; then
    echo -e "$DONE"
    echo -e "STEP2_ENDED=$STEP2_ENDED"
    echo -e "$RUN_CMD_TO_START_NEXT_STEP"
    echo "bash \$NEXT_STEP"

    su #root
fi
