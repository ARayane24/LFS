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

    # 3 - OP_Which
    if [-n "$OP_Which"] ;then
        echo -e "$START_JOB"
        echo $OP_Which
        tar -xf $OP_Which.tar.gz
        cd $OP_Which


        cd /sources/
        rm -Rf $OP_Which #rm extracted pkg
        echo -e "$DONE" 
        echo -e $OP_Which "$TOOL_READY"
    fi
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#