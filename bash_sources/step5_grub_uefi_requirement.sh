#!/bin/bash
# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
    #Recommended PKGS for GRUB (UEFI) version
    # 1 - OP_Which
    if [-n "$OP_Which"] ;then
        echo -e "$START_JOB"
        echo $OP_Which
        tar -xf $OP_Which.tar.gz
        cd $OP_Which

        ./configure --prefix=/usr &&
        make -s && make -s install
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
  
    # 2 - OP_Libping
    if [-n "$OP_Libping"] ;then
        echo -e "$START_JOB"
        echo $OP_Libping
        tar -xf $OP_Libping.tar.xz
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

     # 4 - OP_Freetype step 1
    if [-n "$OP_Freetype"] ;then
        echo -e "$START_JOB"
        echo $OP_Freetype
        tar -xf $OP_Freetype.tar.xz
        cd $OP_Freetype

        tar -xf ../$OP_Freetype_docs.tar.xz --strip-components=2 -C docs

        sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&

        sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
            -i include/freetype/config/ftoption.h 

         
        if $STATIC_ONLY;then
            ./configure --prefix=/usr --enable-freetype-config --enable-static \
                    --disable-shared 
        else
            ./configure --prefix=/usr --enable-freetype-config --disable-static
        fi

        make -s && make -s install
        

        cp -v -R docs -T /usr/share/doc/$OP_Freetype &&
        rm -v /usr/share/doc/$OP_Freetype/freetype-config.1

        cd /sources/
        rm -Rf $OP_Freetype #rm extracted pkg
        echo -e "$DONE" 
        echo -e $OP_Freetype "$TOOL_READY"
    fi

    # 3 - OP_Harfbuzz
    if [-n "$OP_Harfbuzz"] ;then
        echo -e "$START_JOB"
        echo $OP_Harfbuzz
        tar -xf $OP_Harfbuzz.tar.xz
        cd $OP_Harfbuzz

        mkdir build &&
        cd    build &&

        meson setup ..            \
            --prefix=/usr       \
            --buildtype=release \
            -Dgraphite2=enabled &&
        ninja

        ninja install

        cd /sources/
        rm -Rf $OP_Harfbuzz #rm extracted pkg
        echo -e "$DONE" 
        echo -e $OP_Harfbuzz "$TOOL_READY"
    fi

     # 4 - OP_Freetype step 2
    if [-n "$OP_Freetype"] ;then
        echo -e "$START_JOB"
        echo $OP_Freetype
        tar -xf $OP_Freetype.tar.xz
        cd $OP_Freetype

        tar -xf ../$OP_Freetype_docs.tar.xz --strip-components=2 -C docs

        sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&

        sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
            -i include/freetype/config/ftoption.h  &&

         
        if $STATIC_ONLY;then
            ./configure --prefix=/usr --enable-freetype-config --enable-static \
                    --disable-shared 
        else
            ./configure --prefix=/usr --enable-freetype-config --disable-static
        fi

        make -s && make -s install
        if [ $? -ne 0 ]; then
            echo -e "$BUILD_FAILED"
            exit 1
        fi
        echo -e "$BUILD_SUCCEEDED"

        cp -v -R docs -T /usr/share/doc/$OP_Freetype &&
        rm -v /usr/share/doc/$OP_Freetype/freetype-config.1

        cd /sources/
        rm -Rf $OP_Freetype #rm extracted pkg
        echo -e "$DONE" 
        echo -e $OP_Freetype "$TOOL_READY"
    fi

      # 5 - OP_Popt
    if [-n "$OP_Popt"] ;then
        echo -e "$START_JOB"
        echo $OP_Popt
        tar -xf $OP_Popt.tar.gz
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

        if ADD_OPTIONNAL_DOCS; then
            install -v -m755 -d /usr/share/doc/popt-1.19 &&
        fi

        cd /sources/
        rm -Rf $OP_Popt #rm extracted pkg
        echo -e "$DONE" 
        echo -e $OP_Popt "$TOOL_READY"
    fi

      # 6 - OP_Mandoc
    if [-n "$OP_Mandoc"] ;then
        echo -e "$START_JOB"
        echo $OP_Mandoc
        tar -xf $OP_Mandoc.tar.gz
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

      # 7 - OP_Efivar
    if [-n "$OP_Efivar"] ;then
        echo -e "$START_JOB"
        echo $OP_Efivar
        tar -xf $OP_Efivar.tar.gz
        cd $OP_Efivar
        
        make -s && make -s install LIBDIR=/usr/lib
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

      # 8 - OP_Efibootmgr
    if [-n "$OP_Efibootmgr"] ;then
        echo -e "$START_JOB"
        echo $OP_Efibootmgr
        tar -xf $OP_Efibootmgr.tar.gz
        cd $OP_Efibootmgr
        
        make EFIDIR=LFS EFI_LOADER=grubx64.efi && make install EFIDIR=/
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