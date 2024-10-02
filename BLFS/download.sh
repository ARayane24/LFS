#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

source ../bash_sources/terminal_params/_util_methodes.sh

CODE_SOURCES_INSTALLED=$(yes_no_question "$DO_YOU_HAVE_CODE_SOURCES")

if $CODE_SOURCES_INSTALLED; then
    echo -e "$YOU_HAVE_CODE_SOURCES"
else
    echo -e "$YOU_DONNOT_HAVE_CODE_SOURCES"
    echo -e "$UPDATE_DOWNLOAD_NEEDED_PKGS"
    downlaod_utils_pkgs

    echo -e "$START_DOWNLOAD_CODE_SOURCES"
    # Directory to check for existing packages
    download_dir="$HELPER_DIR/sources/blfs"
    source_file="./all-blfs-wget-list"
    elinks="./error_links"

    # Create the download directory if it doesn't exist
    mkdir -p "$download_dir"

    # Read each URL from the file
    while IFS= read -r url; do
        package_name=$(basename "$url")  # No need for 'export'

        if [[ -f "$download_dir/$package_name" ]]; then
            echo "Package $package_name already exists."
        else
            wget -nv --directory-prefix="$download_dir" "$url"  || echo "$url" >> $elinks
            echo "Downloaded $package_name"
        fi
    done < $source_file

    while IFS= read -r url; do
        package_name=$(basename "$url")  # No need for 'export'

        if [[ -f "$download_dir/$package_name" ]]; then
            p=1
        else
            lynx -dump -listonly -nonumbers "$url"  > "links.txt"
            while IFS= read -r url; do
                package_name=$(basename "$url")  # No need for 'export'

                if [[ -f "$download_dir/$package_name" ]]; then
                    p=1
                else
                    wget -nv --directory-prefix="$download_dir" "$url"  || echo "$url" >> $elinks-no-solution
                    echo "Downloaded $package_name"
                fi
            done < "links.txt"
        fi
    done < $elinks
fi


cp -Rf $HELPER_DIR/sources/blfs $LFS/sources
chown root:root $LFS/sources/blfs
chown root:root $LFS/sources/blfs/*
echo -e "$DONE"




