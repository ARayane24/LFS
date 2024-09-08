#!/bin/bash
# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
    #Recommended PKGS for GRUB (UEFI) version
    # 1 - OP_Which 0.1SBU
    if [ -n "$OP_Which" ] ;then
        echo -e "$START_JOB" " 0.1 SBU" 
        echo $OP_Which
        cd $OP_Which

        ./configure --prefix=/usr &&
        make && make install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        cd /sources/
        rm -Rf $OP_Which #rm extracted pkg
        echo -e "$DONE" 
        echo -e $OP_Which "$TOOL_READY"
    fi
  
    # 2 - OP_Libping 0.1SBU
    if [ -n "$OP_Libping" ] ;then
        echo -e "$START_JOB" " 0.1 SBU"
        echo $OP_Libping
        cd $OP_Libping

        gzip -cd ../$OP_Libping_patch-apng.patch.gz | patch -p1

       
        if $STATIC_ONLY;then
            ./configure --prefix=/usr \
                    --enable-static \
                    --disable-shared 
        else
             ./configure --prefix=/usr --disable-static
        fi

        make -s &&
        make -s install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        mkdir -v /usr/share/doc/$OP_Libping &&
        cp -v README libpng-manual.txt /usr/share/doc/$OP_Libping
        
        cd /sources/
        rm -Rf $OP_Libping #rm extracted pkg
        echo -e "$DONE" 
        echo -e $OP_Libping "$TOOL_READY"
    fi

     # 4 - OP_Freetype step 1 0.2SBU
    if [ -n "$OP_Freetype" ] ;then
        echo -e "$START_JOB" " 0.2 SBU"
        echo $OP_Freetype
        cd $OP_Freetype

        tar -xf ../$OP_Freetype_docs.tar.xz --strip-components=2 -C docs

        sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&

        sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
            -i include/freetype/config/ftoption.h  &&

        ./configure --prefix=/usr --enable-freetype-config --disable-static &&
        make && make install
        

        cp -v -R docs -T /usr/share/doc/$OP_Freetype &&
        rm -v /usr/share/doc/$OP_Freetype/freetype-config.1

        cd /sources/
        rm -Rf $OP_Freetype #rm extracted pkg
        echo -e "$DONE" 
        echo -e $OP_Freetype "$TOOL_READY"
    fi

    # 3 - OP_Harfbuzz 0.7SBU
    if [ -n "$OP_Harfbuzz" ] ;then
        echo -e "$START_JOB" " 0.7 SBU"
        echo $OP_Harfbuzz
        cd $OP_Harfbuzz

        mkdir build &&
        cd    build &&

        meson setup ..             \
            --prefix=/usr        \
            --buildtype=release  \
            -D graphite2=enabled &&
        ninja

        ninja install

        cd /sources/
        rm -Rf $OP_Harfbuzz #rm extracted pkg
        echo -e "$DONE" 
        echo -e $OP_Harfbuzz "$TOOL_READY"
    fi

     # 4 - OP_Freetype step 2 0.2SBU
    if [ -n "$OP_Freetype" ] ;then
        echo -e "$START_JOB" " 0.2 SBU"
        echo $OP_Freetype
        tar -xf $OP_Freetype.tar.xz
        cd $OP_Freetype

        tar -xf ../$OP_Freetype_docs.tar.xz --strip-components=2 -C docs

        sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&

        sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
            -i include/freetype/config/ftoption.h  &&

        ./configure --prefix=/usr --enable-freetype-config --disable-static &&
        make && make install
        

        cp -v -R docs -T /usr/share/doc/$OP_Freetype &&
        rm -v /usr/share/doc/$OP_Freetype/freetype-config.1

        cd /sources/
        rm -Rf $OP_Freetype #rm extracted pkg
        echo -e "$DONE" 
        echo -e $OP_Freetype "$TOOL_READY"
    fi

      # 5 - OP_Popt 0.1SBU
    if [ -n "$OP_Popt" ] ;then
        echo -e "$START_JOB" " 0.1 SBU"
        echo $OP_Popt
        cd $OP_Popt
        
        if $STATIC_ONLY;then
            ./configure --prefix=/usr --enable-static \
                    --disable-shared 
        else
            ./configure --prefix=/usr --disable-static
        fi

        make && make install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        if $ADD_OPTIONNAL_DOCS; then
            install -v -m755 -d /usr/share/doc/$OP_Popt
        fi

        cd /sources/
        rm -Rf $OP_Popt #rm extracted pkg
        echo -e "$DONE" 
        echo -e $OP_Popt "$TOOL_READY"
    fi

      # 6 - OP_Mandoc 0.1SBU
    if [ -n "$OP_Mandoc" ] ;then
        echo -e "$START_JOB" " 0.1 SBU"
        echo $OP_Mandoc
        cd $OP_Mandoc
        
      
        ./configure && make mandoc
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        install -vm755 mandoc   /usr/bin &&
        install -vm644 mandoc.1 /usr/share/man/man1

        cd /sources/
        rm -Rf $OP_Mandoc #rm extracted pkg
        echo -e "$DONE" 
        echo -e $OP_Mandoc "$TOOL_READY"
    fi

      # 7 - OP_Efivar 0.1SBU
    if [ -n "$OP_Efivar" ] ;then
        echo -e "$START_JOB" " 0.1 SBU"
        echo $OP_Efivar
        cd $OP_Efivar
        
        make && make install LIBDIR=/usr/lib
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        cd /sources/
        rm -Rf $OP_Efivar #rm extracted pkg
        echo -e "$DONE" 
        echo -e $OP_Efivar "$TOOL_READY"
    fi

      # 8 - OP_Efibootmgr 0.1SBU
    if [ -n "$OP_Efibootmgr" ] ;then
        echo -e "$START_JOB" " 0.1 SBU"
        echo $OP_Efibootmgr
        cd $OP_Efibootmgr
        
        make EFIDIR=LFS EFI_LOADER=grubx64.efi && make install EFIDIR=LFS
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        cd /sources/
        rm -Rf $OP_Efibootmgr #rm extracted pkg
        echo -e "$DONE" 
        echo -e $OP_Efibootmgr "$TOOL_READY"
    fi
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#