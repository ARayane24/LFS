#!/bin/bash
# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

clear
if ! [[ -n "${INIT_FOR_SAFETY+x}" ]] && [[ -f /etc/bash.bashrc ]]; then
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

    # Prepare the content to be appended
    SAVE="
    # INIT
    export SHARED_FILE=$SHARED_FILE
    export HELPER_DIR=$(pwd)
    export STEP1_ENDED=false
    export STEP2_ENDED=false
    export STEP3_ENDED=false
    export STEP4_ENDED=false

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
    CODE_SOURCES_INSTALLED=false
    while true; do
        read -p "$DO_YOU_HAVE_CODE_SOURCES" user_input

        if [[ "$user_input" == "y" || "$user_input" == "Y" ]]; then
            echo -e "$YOU_HAVE_CODE_SOURCES"
            CODE_SOURCES_INSTALLED=true
        elif [[ "$user_input" == "n" || "$user_input" == "N" ]]; then
            echo -e "$YOU_DONNOT_HAVE_CODE_SOURCES"
        else
            echo -e "$PLEASE_Y_OR_N"
            continue
        fi
        break
    done

    
    if ! $CODE_SOURCES_INSTALLED; then
        echo -e "$UPDATE_DOWNLOAD_NEEDED_PKGS"
        downlaod_utils_pkgs

        echo -e "$START_DOWNLOAD_CODE_SOURCES"
        downlaod_code_source_pkgs $HELPER_DIR
    fi


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
fi
