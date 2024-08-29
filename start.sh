#!/bin/bash
# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

# Tips :
# don't forget to cd to this file location so every thing works fine !!

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
    source /etc/bash.bashrc
    
    echo -e "Init Done ! \n"
    sync
fi

if ! [ -n "$STEP1_ENDED" ] || ! $STEP1_ENDED; then
    ######################
    #   *  settings  *   #
    ######################
    # Important vars
    export HELPER_DIR=$(pwd)
    find $HELPER_DIR -type f -name "*.sh" -exec bash -n {} \; #chexk if there is a syntax error in all the bash files that will be excuted

    export SHARED_FILE="/etc/bash.bashrc"

    export CPU_ARCH_HUMAN=("64-bit(x86) architecture" "64-bit(ARM) architecture")
    export CPU_ARCH=("x86_64" "aarch64")
    export CPU_SELECTED_ARCH=$(uname -m) # current cpu archi

    printf -v formatted_cpu_arch_human "(%s)" "$(printf '"%s" ' "${CPU_ARCH_HUMAN[@]}")"
    printf -v formatted_cpu_arch "(%s)" "$(printf '"%s" ' "${CPU_ARCH[@]}")"

    # Prepare the content to be appended
SAVE="
    # INIT
    export SHARED_FILE=$SHARED_FILE
    export HELPER_DIR=$(pwd)
    export STEP1_ENDED=false
    export STEP2_ENDED=false
    export STEP3_ENDED=false
    export STEP4_ENDED=false
    export STEP5_ENDED=false
    export STEP6_ENDED=false
    export STEP7_ENDED=false
    export STEP8_ENDED=false
    export STEP9_ENDED=false
    export STEP10_ENDED=false


    export CPU_ARCH_HUMAN=$formatted_cpu_arch_human
    export CPU_ARCH=$formatted_cpu_arch
"
    echo "$SAVE" >> $SHARED_FILE
    sync
    # Starting _config
    cd ./bash_sources/terminal_params
    source ./_config.sh
    cd $HELPER_DIR
    source $SHARED_FILE

    #######################
    #   *  Welcome  *   #
    #######################
    # Define multiple lines of text to center
    lines=("$WELCOME"
        "$LOGO")
    layout=("${STEP}${lines[0]}${NO_STYLE}"
        "${TITLE}${lines[1]}${NO_STYLE}")

    # Get the width of the terminal
    terminal_width=$(tput cols)

    # Loop through each line and print it centered
    i=0
    for text in "${lines[@]}"; do
        text_length=${#text}
        spaces=$(( (terminal_width - text_length) / 2 ))
        padding=$(printf "%${spaces}s")
        echo -e "${padding}${layout[$i]}"
        ((i++))
    done

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
    echo -e "$DO_YOU_WANT_BACKUP_OS_REC"
    BACK_UP_OS_IN_THE_END=$(yes_no_question "$DO_YOU_WANT_BACKUP_OS")
    if $STATIC_ONLY; then
        echo -e "$YES_BACK_UP_OS"
    else
        echo -e "$NO_BACK_UP_OS"
    fi
    #################################
    #   *  static vs dync libs  *   #
    #################################
    STATIC_ONLY=$(yes_no_question "$DO_YOU_WANT_HAVING_ONLY_STATIC")
    if $STATIC_ONLY; then
        echo -e "$ONLY_STATIC"
    else
        echo -e "$NOT_ONLY_STATIC"
    fi
    ##############################
    #   * DO optionnal tests *   #
    ##############################
    WANT_TO_DO_OPTIONNAL_TESTS=$(yes_no_question "$DO_YOU_WANT_TO_EXE_OPTIONNAL_TESTS")
    if $WANT_TO_DO_OPTIONNAL_TESTS; then
        echo -e "$DO_ALL_TESTS"
    else
        echo -e "$DONT_DO_ALL_TESTS"
    fi
    ##############################
    #   * ADD optionnal docs *   #
    ##############################
    # optionnal documentation of the used pkgs
    WANT_TO_ADD_OPTIONNAL_DOCS=$(yes_no_question "$DO_YOU_WANT_TO_ADD_OPTIONNAL_DOCS")
    if $WANT_TO_ADD_OPTIONNAL_DOCS; then
        echo -e "$ADD_ALL_DOCS"
    else
        echo -e "$DONT_ADD_ALL_DOCS"
    fi
    ###########################
    #   * optionnal SLEEP *   #
    ###########################
    echo -e "$RUNING_WITH_FULL_CPU_POWER_FOR_LONG_TIME_HARM_PC"
    echo -e "$HOW_MATCH_TIME_SLEEP_IN_SECONDS"
    SLEEP_FOR_N_SECONDS=$(read_positive_numbers_only)
    echo -e "$EACH_5_SBU_SLEEP" "$SLEEP_FOR_N_SECONDS"
    #######################
    #   * UEFI System *   #
    #######################
    IS_UEFI=$(yes_no_question "$IS_YOUR_TARGET_UEFI")
    if $IS_UEFI; then
        echo -e "$YOUR_TARGET_IS_UEFI"
    else
        echo -e "$YOUR_TARGET_IS_NOT_UEFI"
    fi
    ######################
    #   * Debug mode *   #
    ######################
    KEEP_DEBUG_FILES=$(yes_no_question "$DO_YOU_WANNA_KEEP_DEBUG_FILES")
    if $KEEP_DEBUG_FILES; then
        echo -e "$YEP_KEEP_DEBUG_FILES"
    else
        echo -e "$NO_KEEP_DEBUG_FILES"
    fi

    SAVE="
    # Backup
    export BACK_UP_OS_IN_THE_END=${BACK_UP_OS_IN_THE_END}
    export STATIC_ONLY=${STATIC_ONLY}
    export DO_OPTIONNAL_TESTS=$WANT_TO_DO_OPTIONNAL_TESTS
    export ADD_OPTIONNAL_DOCS=$WANT_TO_ADD_OPTIONNAL_DOCS
    export SLEEP_FOR_N_SECONDS=$SLEEP_FOR_N_SECONDS
    export IS_UEFI=$IS_UEFI
    export KEEP_DEBUG_FILES=$KEEP_DEBUG_FILES
    "
    echo "$SAVE" >> $SHARED_FILE
   
   
    #############################
    #   *  target cpu archi *   #
    #############################
    echo -e "$CHOOSE_CPU_ARCHI"
    select_cpu_archi
    
    
    ######################
    #   *  Starting  *   #
    ######################
    cd $HELPER_DIR
    bash ./bash_sources/step1.sh
fi
if [ -n "$STEP1_ENDED" ] && [ "$STEP1_ENDED" = true ] \
   && [ -n "$STEP2_ENDED" ] && [ "$STEP2_ENDED" = true ] \
   && [ -n "$STEP3_ENDED" ] && [ "$STEP3_ENDED" = true ] ; then
    # Restore
    source "$LFS/LFS/bash_sources/step4.4_restore.sh"
fi

bash $NEXT_STEP





## Future improvment :
# add option to save progress in case of error to complite where it has stopted