#!/bin/bash
# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing


echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$START_STEP8${STEP}*   #
    ############################################### ${NO_STYLE}
    "

pushd /sources/

###SC_LFS_Bootscripts: 0.1SBU
if [ -n "$SC_LFS_Bootscripts" ] ;then
    echo -e "$START_JOB"
    echo $SC_LFS_Bootscripts
    tar -xf $SC_LFS_Bootscripts.tar.xz
    cd $SC_LFS_Bootscripts

    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources/
    rm -Rf $SC_LFS_Bootscripts #rm extracted pkg
    echo -e "$DONE" 
    echo -e $SC_LFS_Bootscripts "$TOOL_READY"
fi
###********************************


bash /usr/lib/udev/init-net-rules.sh

###OP_dhcpcd: 0.1SBU
if [ -n "$OP_dhcpcd" ] ;then
    echo -e "$START_JOB"
    echo $OP_dhcpcd
    tar -xf $OP_dhcpcd.tar.xz
    cd $OP_dhcpcd

   install  -v -m700 -d /var/lib/dhcpcd &&

   groupadd -g 52 dhcpcd        &&
   useradd  -c 'dhcpcd PrivSep' \
            -d /var/lib/dhcpcd  \
            -g dhcpcd           \
            -s /bin/false       \
            -u 52 dhcpcd &&
   chown    -v dhcpcd:dhcpcd /var/lib/dhcpcd 


   ./configure --prefix=/usr             \
            --sysconfdir=/etc            \
            --libexecdir=/usr/lib/dhcpcd \
            --dbdir=/var/lib/dhcpcd      \
            --runstatedir=/run           \
            --privsepuser=dhcpcd         &&
   make
   if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
   fi
   echo -e "$BUILD_SUCCEEDED"

   if $DO_OPTIONNAL_TESTS; then
      make test
   fi

   make install
   if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
   fi
   echo -e "$BUILD_SUCCEEDED"

   cd ..

   #config
   echo -e "$START_JOB"
   echo $SC_BLFS_Bootscripts
   tar -xf $SC_BLFS_Bootscripts.tar.xz
   cd $SC_BLFS_Bootscripts

   make install-service-dhcpcd
   if [ $? -ne 0 ]; then
      echo -e "$BUILD_FAILED"
      exit 1
   fi
   echo -e "$BUILD_SUCCEEDED"

   cd /sources/
   rm -Rf $SC_BLFS_Bootscripts #rm extracted pkg
   echo -e "$DONE" 
   echo -e $SC_BLFS_Bootscripts "$TOOL_READY"

   ip a #veiw all network interface names and @address 

   while true; do
    NET_WORK_INTERFACE_NAME=$(read_non_empty_string "$INPUT_NETWORK_INTERFACE_NAME")

    if [[ "$NET_WORK_INTERFACE_NAME" == "exit" ]]; then
        echo "$FINISHED_ADDING_NW_I_N"
        break
    fi

    

    # Define the configuration file path
    CONFIG_FILE="/etc/sysconfig/ifconfig.$NET_WORK_INTERFACE_NAME"

    # Create or overwrite the configuration file with user input
    cat > "$CONFIG_FILE" <<EOF
ONBOOT="yes"
IFACE="$NET_WORK_INTERFACE_NAME"
SERVICE="dhcpcd"
DHCP_START="-b -q -h $DESTRO_HOSTNAME 192.168.1.2"
DHCP_STOP="-k 192.168.1.254"
EOF

    echo "Configuration file created at $CONFIG_FILE"
   done

   cat > /etc/resolv.conf.head << "EOF"
nameserver 192.168.0.1
# Google DNS servers
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF

   echo "$DESTRO_HOSTNAME" > /etc/hostname

   cat > /etc/hosts <<EOF
127.0.0.1	localhost
127.0.1.1	$DESTRO_HOSTNAME

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

   cd /sources/
   rm -Rf $OP_dhcpcd #rm extracted pkg
   echo -e "$DONE" 
   echo -e $OP_dhcpcd "$TOOL_READY"
fi
###********************************


## init
cat > /etc/inittab <<EOF
# Begin /etc/inittab

id:3:initdefault:

si::sysinit:/etc/rc.d/init.d/rc S

l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6

ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

su:S06:once:/sbin/sulogin
s1:1:respawn:/sbin/sulogin

1:2345:respawn:/sbin/agetty --noclear tty1 9600
2:2345:respawn:/sbin/agetty tty2 9600
3:2345:respawn:/sbin/agetty tty3 9600
4:2345:respawn:/sbin/agetty tty4 9600
5:2345:respawn:/sbin/agetty tty5 9600
6:2345:respawn:/sbin/agetty tty6 9600

# End /etc/inittab
EOF

## TZ
cat > /etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock

UTC=1

# Set this to any options you might need to give to hwclock,
# such as machine hardware clock type for Alphas.
CLOCKPARAMS=

# End /etc/sysconfig/clock
EOF


## console
cat > /etc/sysconfig/console << "EOF"
# Begin /etc/sysconfig/console

UNICODE="1"
FONT="Lat2-Terminus16"

# End /etc/sysconfig/console
EOF

## sys local
echo -e "$CHOOSE_SYS_LOCAL"
ALL_SYS_LOCALS="$(locale -a | sort)"
echo -e $ALL_SYS_LOCALS

while true; do
   chosen_local=$(read_non_empty_string "$INPUT_SYS_L_VALUE")
   if echo "$ALL_SYS_LOCALS" | grep -q "^$chosen_local$"; then
      echo -e "$VALID_SYS_L $chosen_local"
      break
   fi
   echo -e "$NOT_VALID_SYS_L"
done


CHOOSEN_CHARMAP="$(LC_ALL="$chosen_local" locale charmap)"
formatted_locale=$(echo "$chosen_local" | sed -E 's/(.*)\.(utf8|UTF-8)/\1/')

cat > /etc/profile <<EOF
# Begin /etc/profile

for i in $(locale); do
  unset ${i%=*}
done

if [[ "$TERM" = linux ]]; then
  export LANG=C.UTF-8
else
  export LANG=$formatted_locale.$CHOOSEN_CHARMAP     #format : <ll>_<CC>.<charmap><@modifiers>
fi

# End /etc/profile
EOF

## Creating the /etc/inputrc File
# It works by translating keyboard inputs into specific actions. Readline is used by bash and most other shells as well as many other applications.
cat > /etc/inputrc <<EOF
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8-bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF

## Creating the /etc/shells File
cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF


## Creating the /etc/fstab File
cat > /etc/fstab <<EOF
# Begin /etc/fstab

# file system              mount-point    type     options             dump  fsck
#                                                                            order

$DISTRO_PARTITION_NAME     /              ext4     defaults             1     1
proc                       /proc          proc     nosuid,noexec,nodev  0     0
sysfs                      /sys           sysfs    nosuid,noexec,nodev  0     0
devpts                     /dev/pts       devpts   gid=5,mode=620       0     0
tmpfs                      /run           tmpfs    defaults             0     0
devtmpfs                   /dev           devtmpfs mode=0755,nosuid     0     0
tmpfs                      /dev/shm       tmpfs    nosuid,nodev         0     0
cgroup2                    /sys/fs/cgroup cgroup2  nosuid,noexec,nodev  0     0

# End /etc/fstab
EOF





###Linux_Kernel: 0.1SBU
if [ -n "$Linux_Kernel" ] ;then
   echo -e "$START_JOB"
   echo $Linux_Kernel
   tar -xf $Linux_Kernel.tar.xz
   cd $Linux_Kernel

   make mrproper
   if [ $? -ne 0 ]; then
      echo -e "$BUILD_FAILED"
      exit 1
   fi
   echo -e "$BUILD_SUCCEEDED"

   make defconfig
   make menuconfig

   make
   if [ $? -ne 0 ]; then
      echo -e "$BUILD_FAILED"
      exit 1
   fi
   echo -e "$BUILD_SUCCEEDED"

   make modules_install
   if [ $? -ne 0 ]; then
      echo -e "$BUILD_FAILED"
      exit 1
   fi
   echo -e "$BUILD_SUCCEEDED"

   cp -iv arch/x86/boot/bzImage /boot/vmlinuz-6.7.4-$DISTRO_NAME
   cp -iv System.map /boot/System.map-6.7.4

   if $ADD_OPTIONNAL_DOCS; then
      cp -iv .config /boot/config-6.7.4
      cp -r Documentation -T /usr/share/doc/$Linux_Kernel
   fi

   chown -R 0:0 ../$Linux_Kernel


   install -v -m755 -d /etc/modprobe.d
   cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF

 cd /sources/
 #  rm -Rf $Linux_Kernel #rm extracted pkg
 #  echo -e "$DONE" 
 #  echo -e $Linux_Kernel "$TOOL_READY"
fi
###********************************



###OP_dosfstools: 0.1SBU
if [ -n "$OP_dosfstools" ] ;then
   echo -e "$START_JOB"
   echo $OP_dosfstools
   tar -xf $OP_dosfstools.tar.gz
   cd $OP_dosfstools

   ./configure --prefix=/usr      \
         --enable-compat-symlinks \
         --mandir=/usr/share/man  \
         --docdir=/usr/share/doc/$OP_dosfstools
   make
   if [ $? -ne 0 ]; then
      echo -e "$BUILD_FAILED"
      exit 1
   fi
   echo -e "$BUILD_SUCCEEDED"

   make check

   make install
   if [ $? -ne 0 ]; then
      echo -e "$BUILD_FAILED"
      exit 1
   fi
   echo -e "$BUILD_SUCCEEDED"

   cd /sources/
   rm -Rf $OP_dosfstools #rm extracted pkg
   echo -e "$DONE" 
   echo -e $OP_dosfstools "$TOOL_READY"
fi
###********************************


read -p "$PLUGIN_THE_USB_YOU_WANT_USE_INPUT_ANY_TO_CONTINUE" X
lsblk
EM_Boot=$(read_non_empty_string "$INPUT_USB_NAME")
mkfs.vfat /dev/$EM_Boot

fdisk /dev/$EM_Boot

mount --mkdir -v -t vfat /dev/$EM_Boot -o codepage=437,iocharset=iso8859-1 \
      /mnt/rescue

grub-install --target=x86_64-efi --removable \
             --efi-directory=/mnt/rescue --boot-directory=/mnt/rescue

umount /mnt/rescue

popd
echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$END_STEP8${STEP}*     #
    ############################################### ${NO_STYLE}
    "
