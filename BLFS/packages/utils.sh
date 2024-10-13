#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing


# usage : call_method method_name file_path
call_method() {
    local method_name="$1"
    local file_path="$2"

    # Check if parameters are provided and not empty
    if [[ -z "$method_name" || -z "$file_path" ]]; then
        echo -e "${ERROR} Method name and file path must be provided.${NO_STYLE}"
        exit 1
    fi

    # Check if the file exists
    if [[ ! -f "$file_path" ]]; then
        echo -e "${ERROR} File not found: $file_path${NO_STYLE}"
        exit 1
    fi

    # Source the file
    source "$file_path"

    # Check if the method is defined
    if ! declare -f "$method_name" > /dev/null; then
        echo -e "${ERROR} Method not found: $method_name${NO_STYLE}"
        exit 1
    fi

    # Call the method
    "$method_name"

    # Check if the function executed successfully
    if [ $? -eq 0 ]; then
        echo -e "${DONE}"
        exit 0
    else
        echo -e "${ERROR} Failed${NO_STYLE} : $method_name"
        exit 1
    fi
}
