#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_Vulkan_Loader_"
file_name_compiled="${file_name}_compiled"
path_to_compiled_pkgs="../../../../../../../../compiled_pckages.sh"

## check if already has been compiled
source "$path_to_compiled_pkgs"

if [[ -n "$file_name_compiled" && $file_name_compiled ]]; then
    echo -e "${OK}Already compiled${NO_STYLE}"
    exit 0
fi


# required packages:: (file calls with source)
call_method "PKG_libsndfile_" "./packages/_Multimedia/_Multimedia_Libraries_and_Drivers/PKG_libsndfile_.sh"


# recommended packages::
if [[ -n "$recommended_packages" && $recommended_packages ]]; then
    call_method "PKG_alsa_lib_" "./packages/_Multimedia/_Multimedia_Libraries_and_Drivers/PKG_alsa_lib_.sh"
    call_method "PKG_dbus_"     "./packages/_libs/_system_utilities/PKG_dbus_.sh"
    call_method "PKG_glib_"     "./packages/_libs/_general_/PKG_glib_.sh"
    call_method "PKG_speex_"    "./packages/_Multimedia/_Multimedia_Libraries_and_Drivers/PKG_speex_.sh"
    call_method "xorg_libs"     "./packages/_Graphical_Components/_Graphical_Environments/xorg_libs.sh"
fi


# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
    call_method "PKG_avahi_"          "./packages/_Networking/_Networking_Utilities/PKG_avahi_.sh"
    call_method "PKG_bluez_"          "./packages/_libs/_system_utilities/PKG_bluez_.sh"
    call_method "PKG_doxygen_src"     "./packages/_libs/_system_utilities/PKG_doxygen_src.sh"
    call_method "PKG_fftw_"           "./packages/_libs/_general_/PKG_fftw_.sh"
    call_method "PKG_gtk2_"           "./packages/_Graphical_Components/_Display_Managers/PKG_gtk2_.sh"
    call_method "PKG_libsamplerate_"  "./packages/_Multimedia/_Multimedia_Libraries_and_Drivers/PKG_libsamplerate_.sh"
    call_method "PKG_sbc_"            "./packages/_Multimedia/_Multimedia_Libraries_and_Drivers/PKG_sbc_.sh"
    call_method "PKG_valgrind_"       "./packages/_libs/_system_utilities/PKG_valgrind_.sh"
fi



# main ::
# Use eval to define the function
PKG_Vulkan_Loader_() {
# code
     ###PKG_Vulkan_Loader_: 0.2 SBU
    if [[ -n "$PKG_Vulkan_Loader_" ]] ;then
        extract_tar_files /sources "$PKG_Vulkan_Loader_"
        echo -e "$PKG_Vulkan_Loader_" " 0.2 SBU"
        echo $PKG_Vulkan_Loader_
        cd $PKG_Vulkan_Loader_
        next_pkg="$PKG_Vulkan_Loader_"


        mkdir build &&
        cd    build &&

        meson setup --prefix=/usr       \
                    --buildtype=release \
                    -D database=gdbm    \
                    -D doxygen=false    \
                    -D bluez5=disable   \
                    ..                  &&
        ninja
        echo -e "$BUILD_SUCCEEDED"

        if $DO_OPTIONNAL_TESTS; then
            ninja test
        fi

        ninja install
        echo -e "$BUILD_SUCCEEDED"

        cd /sources/blfs
        rm -Rf $PKG_Vulkan_Loader_ #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_Vulkan_Loader_ "$TOOL_READY"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


