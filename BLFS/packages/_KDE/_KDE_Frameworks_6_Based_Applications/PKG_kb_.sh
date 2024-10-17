#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_kb_"
file_name_compiled="${file_name}_compiled"
path_to_compiled_pkgs="../../../../../../../../compiled_pckages.sh"

## check if already has been compiled
source "$path_to_compiled_pkgs"

if [[ -n "$file_name_compiled" && $file_name_compiled ]]; then
    echo -e "${OK}Already compiled${NO_STYLE}"
    exit 0
fi


# required packages:: (file calls with source)
source "./packages/_KDE/_KDE_Frameworks_6/building.sh"
call_method "PKG_libkcddb_"         "./packages/_KDE/_KDE_Frameworks_6_Based_Applications/PKG_libkcddb_.sh"
call_method "PKG_libsamplerate_"    "./packages/_Multimedia/_Multimedia_Libraries_and_Drivers/PKG_libsamplerate_.sh"
call_method "PKG_shared_mime_info_" "./packages/_libs/_general_uitilities/PKG_shared_mime_info_.sh"
call_method "PKG_udisks_"           "./packages/_libs/_system_utilities/PKG_udisks_.sh"


# recommended packages::
if [[ -n "$recommended_packages" && $recommended_packages ]]; then
   call_method "PKG_libburn_"       "./packages/_Multimedia/_CD/DVD-Writing_Utilities/PKG_libburn_.sh"
   call_method "PKG_libdvdread_"    "./packages/_Multimedia/_Multimedia_Libraries_and_Drivers/PKG_libdvdread_.sh"
   call_method "PKG_taglib_"        "./packages/_Multimedia/_Multimedia_Libraries_and_Drivers/PKG_taglib_.sh"
   call_method "PKG_cdrtools_a"     "./packages/_Multimedia/_CD/DVD-Writing_Utilities/PKG_cdrtools_a.sh"
   call_method "PKG_dvd+rw_tools_"  "./packages/_Multimedia/_CD/DVD-Writing_Utilities/PKG_dvd+rw_tools_.sh"
   call_method "PKG_cdrdao_"        "./packages/_Multimedia/_CD/DVD-Writing_Utilities/PKG_cdrdao_.sh"
fi


# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
   call_method "PKG_ffmpeg_"        "./packages/_Multimedia/_Video_Utilities/PKG_ffmpeg_.sh"
   call_method "PKG_flac_"          "./packages/_Multimedia/_Multimedia_Libraries_and_Drivers/PKG_flac_.sh"
   call_method "PKG_lame_"          "./packages/_Multimedia/_Audio_Utilities/PKG_lame_.sh"
   call_method "PKG_libmad_b"       "./packages/_Multimedia/_Multimedia_Libraries_and_Drivers/PKG_libmad_b.sh"
   call_method "PKG_libsndfile_"    "./packages/_Multimedia/_Multimedia_Libraries_and_Drivers/PKG_libsndfile_.sh"
   call_method "PKG_libvorbis_"     "./packages/_Multimedia/_Multimedia_Libraries_and_Drivers/PKG_libvorbis_.sh"
fi



# main ::
# Use eval to define the function
PKG_kb_() {
# code
     ###PKG_kb_: 1.3 SBU
    if [[ -n "$PKG_kb_" ]] ;then
        extract_tar_files /sources "$PKG_kb_"
        echo -e "$PKG_kb_" " 1.3 SBU"
        echo $PKG_kb_
        cd $PKG_kb_
        next_pkg="$PKG_kb_"


        mkdir build &&
        cd    build &&

        cmake -D CMAKE_INSTALL_PREFIX=$KF6_PREFIX \
            -D CMAKE_BUILD_TYPE=Release         \
            -D BUILD_TESTING=OFF                \
            -W no-dev ..                        &&
        make
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export error_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        make install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export error_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        cd /sources/blfs
        rm -Rf $PKG_kb_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_kb_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


