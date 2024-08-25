get_language_file() {
    # Check if the first parameter is empty or out of bounds
    if [ -z "$1" ] || [ "$1" -le 0 ] || [ "$1" -gt "$ALL_LANGUAGES_LENGTH" ]; then
        echo "${ERROR}Error:${NO_STYLE} Invalid or no value provided for the first parameter."
        exit 1
    fi

    # Return the file path for the selected language
    echo "$SCRIPT_DIR/${ALL_LANGUAGES[$(( $1 - 1 ))]}"
}

select_lang(){
    #msgs
    local Choose_language_msg="Choose your language \n"
    local USER_Lang=-1
    echo -e "$Choose_language_msg" # -e : \n => new line


    # Format and collect the list of languages into a variable
    formatted_languages=""
    for ((i = 0; i < ALL_LANGUAGES_LENGTH; i++)); do
        # Append formatted string to the variable
        formatted_languages+=$(printf "%-5s" "$((i+1))- ${ALL_LANGUAGES[$i]%.sh}")

        # Add a newline every 2 entries for the desired output format
        if (( (i + 1) % 2 == 0 )); then
            formatted_languages+="\n"
        else
            formatted_languages+="\t"
        fi
    done

    # Print the formatted languages
    echo -e "$formatted_languages"
    echo -e "\n"

    # Ensure the USER_Lang is within the valid range
    while true; do
        read -p "Enter the number corresponding to your language: " USER_Lang

        if  [[ "$USER_Lang" =~ ^[0-9]+$ ]] && ! [ "$USER_Lang" -le 0 ] && ! [ "$USER_Lang" -gt "$ALL_LANGUAGES_LENGTH" ]; then
            break
        fi
        echo -e "${ERROR}Error:${NO_STYLE} The parameter is not a valid number."
    done

   export SELECTED_LANG=$(echo $(get_language_file $USER_Lang))

   
   # Prepare the content to be appended
    SAVE="
    ### Languages
    export SELECTED_LANG=$SELECTED_LANG
    "

    # Append the content to $SHARED_FILE
    echo "$SAVE"  >> $SHARED_FILE
    echo "Selected language : ${ALL_LANGUAGES[$(( $USER_Lang - 1 ))]%.sh}" 
}

