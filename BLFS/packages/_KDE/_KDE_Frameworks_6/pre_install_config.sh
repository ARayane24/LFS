#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

export KF6_PREFIX=/usr

cat >> /etc/profile.d/qt6.sh << "EOF"
# Begin kf6 extension for /etc/profile.d/qt6.sh

pathappend /usr/lib/plugins        QT_PLUGIN_PATH
pathappend $QT6DIR/lib/plugins     QT_PLUGIN_PATH

pathappend /usr/lib/qt6/qml        QML2_IMPORT_PATH
pathappend $QT6DIR/lib/qml         QML2_IMPORT_PATH

# End extension for /etc/profile.d/qt6.sh
EOF

cat > /etc/profile.d/kf6.sh << "EOF"
# Begin /etc/profile.d/kf6.sh

export KF6_PREFIX=/usr

# End /etc/profile.d/kf6.sh
EOF


file_name="PKG_sudo_p"
file_name_compiled="${file_name}_compiled"

## check if already has been compiled
source "$path_to_compiled_pkgs"

if [[ -n "$file_name_compiled" && $file_name_compiled ]]; then  
    cat >> /etc/sudoers.d/qt << "EOF"
    Defaults env_keep += QT_PLUGIN_PATH
    Defaults env_keep += QML2_IMPORT_PATH
EOF

    cat >> /etc/sudoers.d/kde << "EOF"
    Defaults env_keep += KF6_PREFIX
EOF
fi