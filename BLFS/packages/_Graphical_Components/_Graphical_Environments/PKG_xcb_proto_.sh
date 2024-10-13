#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_xcb_proto_"
file_name_compiled="${file_name}_compiled"
path_to_compiled_pkgs="../../../../../../../../compiled_pckages.sh"

## check if already has been compiled
source "$path_to_compiled_pkgs"

if [[ -n "$file_name_compiled" && $file_name_compiled ]]; then
    echo -e "${OK}Already compiled${NO_STYLE}"
    exit 0
fi


# required packages:: (file calls with source)
# call_method method_name file_path(source)


# recommended packages::
if [[ -n "$recommended_packages" && $recommended_packages ]]; then
   
   

fi


# optional packages::
if [[ -n "$optional_packages" && $optional_packages ]]; then
   
   

fi



# main ::
# Use eval to define the function
PKG_xcb_proto_() {
    # code
    #Setting up the Xorg Build Environment
    export XORG_PREFIX="/usr"

    export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

    cat > /etc/profile.d/xorg.sh << EOF
    XORG_PREFIX="$XORG_PREFIX"
    XORG_CONFIG="--prefix=\$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
    export XORG_PREFIX XORG_CONFIG
EOF
    chmod 644 /etc/profile.d/xorg.sh


    ###PKG_xcb_proto: 3SBU
    if [[ -n "$PKG_xcb_proto" && "$next_pkg" = "$PKG_xcb_proto" ]] ;then
        extract_tar_files /sources "$PKG_xcb_proto"
        echo -e "$PKG_xcb_proto" " 3 SBU"
        echo $PKG_xcb_proto
        cd $PKG_xcb_proto


        PYTHON=python3 ./configure $XORG_CONFIG
        make
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export next_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        if $DO_OPTIONNAL_TESTS; then
            make check
        fi

        make install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            echo "export next_pkg=$next_pkg" >> /.bashrc
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        rm -f $XORG_PREFIX/lib/pkgconfig/xcb-proto.pc
        
        cd /sources/blfs
        rm -Rf $PKG_xcb_proto #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_xcb_proto "$TOOL_READY"
        next_pkg="$PKG_util_macros"
        
        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


