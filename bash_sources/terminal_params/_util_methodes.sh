


### Some important methodes
downlaod_utils_pkgs(){
    #install requited packages
    apt update  #update list pkgs
    apt upgrade #update existing pkgs
    apt full-upgrade  #update all pkgs

    if ! apt-get install binutils bison coreutils diffutils findutils gawk gcc g++ grep gzip m4 make patch perl python3 texinfo sed tar xz-utils bzip2 autoconf; then
        echo -e "$CANNOT_INSTALL_PAKAGES"
        return 1
    else
        echo -e "$DONE"
    fi
}



downlaod_code_source_pkgs_other_sources(){
    local COURENT_DIR=$1

    if [ -z "$COURENT_DIR" ]; then
        echo -e "$MISSING_PARAM"
        return 1
    fi

    echo -e "$START_DOWNLOAD_CODE_SOURCES_OTHER"

    #download the missing files from other sources
    wget https://github.com/libexpat/libexpat/releases/download/R_2_6_2/expat-2.6.2.tar.xz --directory-prefix=$COURENT_DIR/sources

    echo -e "$DONE"
}


downlaod_code_source_pkgs(){
    local COURENT_DIR=$1

    if [ -z "$COURENT_DIR" ]; then
        echo -e "$MISSING_PARAM"
        return 1
    fi

    mkdir $COURENT_DIR/sources
    cd $COURENT_DIR/sources

    #download list of names
    echo -e "${downloading_pkg_started_msg[$USER_Lang]}"
    
    #download files using the lists
    wget -nv --input-file=$COURENT_DIR/bash_sources/source_pkges_LFS --continue --directory-prefix=$COURENT_DIR/sources
    wget -nv --input-file=$COURENT_DIR/bash_sources/source_pkges_BLFS --continue --directory-prefix=$COURENT_DIR/sources
    pushd $COURENT_DIR/sources
        md5sum -c $COURENT_DIR/bash_sources/check_source_pkges_LFS #find missing pkgs
        md5sum -c $COURENT_DIR/bash_sources/check_source_pkges_BLFS #find missing pkgs
    popd
    echo -e "$DONE"

    #downlaod_code_source_pkgs_other_sources $COURENT_DIR
    cd ..
}


extract_tar_files_and_mkdir() {
    local dir="$1"
    local list_files=($2)

    # Check if the directory argument is valid
    if [ -z "$dir" ] || [ ! -d "$dir" ]; then
        echo -e "$MISSING_PARAM: Directory $dir does not exist or is invalid."
        return 1
    fi

    # Check if the list of files argument is valid
    if [ ${#list_files[@]} -eq 0 ]; then
        echo -e "$MISSING_PARAM: No files provided."
        return 1
    fi

    for file in  "${list_files[@]}" ; do
        [ -z "$file" ] && continue
        local founded_files=$( ls "$dir" | grep "^$file.*\.\(tar\.gz\|tar\.bz2\|tar\.xz\|zip\)$" )
        [ -z "$founded_files" ] && continue
        local full_path="$dir/${founded_files[0]}"
        case "${founded_files[0]}" in
                *.tar.gz)  tar -xzf "$full_path" -C "$dir"  || (echo $(pwd) $full_path "${founded_files[@]}" && return 1);;
                *.tar.bz2) tar -xjf "$full_path" -C "$dir"  || (echo $(pwd) $full_path "${founded_files[@]}" && return 1);;
                *.tar.xz)  tar -xJf "$full_path" -C "$dir"  || (echo $(pwd) $full_path "${founded_files[@]}" && return 1);;
                *.zip)     unzip "$full_path" -d "$dir"     || (echo $(pwd) $full_path "${founded_files[@]}" && return 1);;
                *)         echo "Unknown file format: $full_path" ;;
        esac
        mkdir -v "$dir/$file/build"
        echo -e "$founded_files $DONE"
    done
}





extract_tar_files() {
    local dir="$1"
    local list_files=($2)

    # Validate directory argument
    if [ -z "$dir" ] || [ ! -d "$dir" ]; then
        echo -e "$MISSING_PARAM: Directory $dir does not exist or is invalid."
        return 1
    fi

    # Validate list of files argument
    if [ ${#list_files[@]} -eq 0 ]; then
        echo -e "$MISSING_PARAM: No files provided."
        return 1
    fi

    # Process files matching the patterns
    for file in  "${list_files[@]}" ; do
        [ -z "$file" ] && continue
        local founded_files=$( ls "$dir" | grep "^$file.*\.\(tar\.gz\|tar\.bz2\|tar\.xz\|zip\)$" )
        [ -z "$founded_files" ] && continue
        local full_path="$dir/${founded_files[0]}"
        case "${founded_files[0]}" in
                *.tar.gz)  tar -xzf "$full_path" -C "$dir" || (echo $(pwd) $full_path "${founded_files[@]}" && return 1);;
                *.tar.bz2) tar -xjf "$full_path" -C "$dir" || (echo $(pwd) $full_path "${founded_files[@]}" && return 1);;
                *.tar.xz)  tar -xJf "$full_path" -C "$dir" || (echo $(pwd) $full_path "${founded_files[@]}" && return 1);;
                *.zip)     unzip "$full_path" -d "$dir"    || (echo $(pwd) $full_path "${founded_files[@]}" && return 1);;
                *)         echo "Unknown file format: $full_path" ;;
        esac
        echo -e "$founded_files $DONE"
    done
}

create_and_save_partition(){
    local LFS=$1
    local SAVE_Partition=$2
    local disk_partition_name=


    systemctl daemon-reload #update

    #mounting a disk partition
    mkdir -pv $LFS
    lsblk #show all disks
    read -p "${INPUT_NAME_OF_PARTITION}" disk_partition_name
    mount -v -t ext4 /dev/$disk_partition_name $LFS


    if $SAVE_Partition; then
        #Saving partition
        MOUNT_POINT=$LFS
        FILE_SYSTEM_TYPE=ext4

        # Get the UUID of the device
        UUID=$(blkid -s UUID -o value "/dev/$disk_partition_name")

        # Check if UUID was obtained
        if [ -z "$UUID" ]; then
            echo -e "${CANNOT_GET_UUID} $disk_partition_name"
            return 1
        fi

        # Add the new entry to /etc/fstab
        # Check if the entry already exists
        grep -q "$UUID" /etc/fstab
        if [ $? -eq 0 ]; then
            echo "The fstab entry for $UUID already exists."
        else
            echo "UUID=$UUID $MOUNT_POINT $FILE_SYSTEM_TYPE defaults 1 1" | sudo tee -a /etc/fstab
        fi

        # Test the new fstab entry
        sudo mount -a

        # Check if the mount was successful
        if mountpoint -q "$MOUNT_POINT"; then
            echo -e "$SUCCESS_MOUNT"
        else
            echo -e "$ERROR_MOUNT"
            return 1
        fi
    fi
    systemctl daemon-reload #update
    SAVE="export DISTRO_PARTITION_NAME=/dev/$disk_partition_name"

    # Append the content to $SHARED_FILE
    echo "$SAVE"  >> $SHARED_FILE

}


yes_no_question(){
    local QUESTION=$1

    if [ -z "$QUESTION" ]; then
        echo -e "$MISSING_PARAM"
        return 1
    fi

    local result=false
    while true; do
        read -p "$QUESTION" user_input

        if [[ "$user_input" != "y" && "$user_input" != "Y" && "$user_input" == "n" && "$user_input" == "N" ]]; then
            echo -e "$PLEASE_Y_OR_N"
            continue           
        elif [[ "$user_input" == "y" || "$user_input" == "Y" ]]; then
            result=true
        fi
        break
    done

    echo $result
}


select_cpu_archi() {
    # Check if the lengths of the arrays are the same
    if [[ ${#CPU_ARCH_HUMAN[@]} -ne ${#CPU_ARCH[@]} ]]; then
        echo -e "$NO_MATCH_ERROR"
        return 1
    fi

    # Format and collect the list of architectures into a variable
    local formatted_archi=""
    for ((i = 0; i < ${#CPU_ARCH_HUMAN[@]}; i++)); do
        # Append formatted string to the variable
        formatted_archi+=$(printf "%-5s" "$((i + 1))- ${CPU_ARCH_HUMAN[$i]}")

        # Add a newline every 2 entries for the desired output format
        if (( (i + 1) % 2 == 0 )); then
            formatted_archi+='\n'
        else
            formatted_archi+='\t'
        fi
    done

    # Print the formatted list of architectures
    echo -e "$formatted_archi"
    echo -e "\n"

    # Prompt the user to select an architecture
    while true; do
        read -p "$SELECT_TARGET_ARCHI" USER_archi

        # Validate the user input
        if [[ "$USER_archi" =~ ^[0-9]+$ ]] && (( USER_archi > 0 && USER_archi <= ${#CPU_ARCH_HUMAN[@]} )); then
            break
        fi
        echo -e "$NOT_VALID_NUMBER"
    done

    # Calculate the index and print the selected architecture
    local result_index=$(( USER_archi - 1 ))
    

     # Prepare the content to be appended
    SAVE="  export CPU_SELECTED_ARCH=${CPU_ARCH[$result_index]} "

    # Append the content to $SHARED_FILE
    echo "$SAVE"  >> $SHARED_FILE
    echo "$SELECTED_ARCHI_IS" "${CPU_ARCH[$result_index]}"
}


read_positive_numbers_only(){  
    while true; do
        read -p "$INPUT_POSI_NUMBER" USER_pos_number

        if  [[ "$USER_pos_number" =~ ^[0-9]+$ ]] && ! [ "$USER_pos_number" -le 0 ]; then
            break
        fi
        echo -e "$NO_VALID_NUMBER"
    done

    echo "$USER_pos_number"
}

sleep_before_complite(){
    echo -e "${PROCESS}$SLEEPPING_AFTER" "12.2SBU" "$FOR" "$SLEEP_FOR_N_SECONDS s " "...${NO_STYLE}"
    sleep $SLEEP_FOR_N_SECONDS
    echo -e "${PROCESS}$WAKINNG ${NO_STYLE}"
}

read_non_empty_string(){
    local MESSAGE_ASK_FOR_INPUT="$1"
    if [ -z "$MESSAGE_ASK_FOR_INPUT" ]; then
        echo -e "$MISSING_PARAM"
        return 1
    fi

    while true; do
        read -p "$MESSAGE_ASK_FOR_INPUT" USER_input

        # Check if the input is empty
        if [[ -z "$USER_input" ]]; then
            echo "$EMPTY_INPUT_IS_NOT_ALLOWED"
            continue
        fi
        break
    done

    echo "$USER_input"
}