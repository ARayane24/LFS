#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

file_name="PKG_qt_everywhere_src_"
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
PKG_qt_everywhere_src_() {
    # code
    ###PKG_Qt: 0.1SBU
    if [[ -n "$PKG_Qt" && "$next_pkg" = "$PKG_Qt" ]] ;then
        extract_tar_files /sources "$PKG_Qt"

        echo -e "$PKG_Qt" " 0.1 SBU"
        echo $PKG_Qt
        cd $PKG_Qt

        export QT6PREFIX=/opt/qt6
        mkdir -pv /opt/qt-6.7.2
        ln -sfnv qt-6.7.2 /opt/qt6


        if [ "$CPU_SELECTED_ARCH" == "i686" ]; then
            sed -e "/^#elif defined(Q_CC_GNU_ONLY)/s/.*/& \&\& 0/" \
                -i qtbase/src/corelib/global/qtypes.h
        fi

        ./configure -prefix $QT6PREFIX      \
                -sysconfdir /etc/xdg    \
                -dbus-linked            \
                -openssl-linked         \
                -system-sqlite          \
                -nomake examples        \
                -no-rpath               \
                -journald               \
                -skip qt3d              \
                -skip qtquick3dphysics  \
                -skip qtwebengine       \
                -W no-dev               &&
        ninja

        ninja install

        find $QT6PREFIX/ -name \*.prl \
    -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;

    pushd qttools/src &&
            install -v -Dm644 assistant/assistant/images/assistant-128.png       \
                            /usr/share/pixmaps/assistant-qt6.png               &&

            install -v -Dm644 designer/src/designer/images/designer.png          \
                            /usr/share/pixmaps/designer-qt6.png                &&

            install -v -Dm644 linguist/linguist/images/icons/linguist-128-32.png \
                            /usr/share/pixmaps/linguist-qt6.png                &&

            install -v -Dm644 qdbus/qdbusviewer/images/qdbusviewer-128.png       \
                            /usr/share/pixmaps/qdbusviewer-qt6.png             &&
        popd &&


        cat > /usr/share/applications/assistant-qt6.desktop << EOF
        [Desktop Entry]
        Name=Qt6 Assistant
        Comment=Shows Qt6 documentation and examples
        Exec=$QT6PREFIX/bin/assistant
        Icon=assistant-qt6.png
        Terminal=false
        Encoding=UTF-8
        Type=Application
        Categories=Qt;Development;Documentation;
EOF

        cat > /usr/share/applications/designer-qt6.desktop << EOF
        [Desktop Entry]
        Name=Qt6 Designer
        GenericName=Interface Designer
        Comment=Design GUIs for Qt6 applications
        Exec=$QT6PREFIX/bin/designer
        Icon=designer-qt6.png
        MimeType=application/x-designer;
        Terminal=false
        Encoding=UTF-8
        Type=Application
        Categories=Qt;Development;
EOF

        cat > /usr/share/applications/linguist-qt6.desktop << EOF
        [Desktop Entry]
        Name=Qt6 Linguist
        Comment=Add translations to Qt6 applications
        Exec=$QT6PREFIX/bin/linguist
        Icon=linguist-qt6.png
        MimeType=text/vnd.trolltech.linguist;application/x-linguist;
        Terminal=false
        Encoding=UTF-8
        Type=Application
        Categories=Qt;Development;
EOF

        cat > /usr/share/applications/qdbusviewer-qt6.desktop << EOF
        [Desktop Entry]
        Name=Qt6 QDbusViewer
        GenericName=D-Bus Debugger
        Comment=Debug D-Bus applications
        Exec=$QT6PREFIX/bin/qdbusviewer
        Icon=qdbusviewer-qt6.png
        Terminal=false
        Encoding=UTF-8
        Type=Application
        Categories=Qt;Development;Debugger;
EOF

        cat >> /etc/ld.so.conf << EOF
        # Begin Qt addition

        /opt/qt6/lib

        # End Qt addition
EOF

        ldconfig

        cat > /etc/profile.d/qt6.sh << "EOF"
        # Begin /etc/profile.d/qt6.sh

        QT6DIR=/opt/qt6

        pathappend $QT6DIR/bin           PATH
        pathappend $QT6DIR/lib/pkgconfig PKG_CONFIG_PATH

        export QT6DIR

        # End /etc/profile.d/qt6.sh
EOF

        cd /sources/blfs
        rm -Rf $PKG_Qt #rm extracted pkg
        echo -e "$DONE" 
        echo -e $PKG_Qt "$TOOL_READY"
        next_pkg="$PKG_Packaging"

        # end
        echo -e "$file_name_compiled=true" >> $path_to_compiled_pkgs
    fi
    ###********************************
}


