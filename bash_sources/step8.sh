#!/bin/bash
# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing


echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$START_STEP8${STEP}*   #
    ############################################### ${NO_STYLE}
    "

pushd /sources

echo -e "$START_EXTRACTION"
extract_tar_files /sources "$SC_LFS_Bootscripts  $SC_BLFS_Bootscripts  $OP_dhcpcd   $OP_dosfstools $Linux_Kernel"
echo -e "$DONE"

###SC_LFS_Bootscripts: 0.1SBU
if [ -n "$SC_LFS_Bootscripts" ] ;then
    echo -e "$START_JOB" " 0.1 SBU"
    echo $SC_LFS_Bootscripts
    cd $SC_LFS_Bootscripts

    make install
    if [ $? -ne 0 ]; then
        echo -e "$BUILD_FAILED"
        exit 1
    fi
    echo -e "$BUILD_SUCCEEDED"

    cd /sources
    rm -Rf $SC_LFS_Bootscripts #rm extracted pkg
    echo -e "$DONE" 
    echo -e $SC_LFS_Bootscripts "$TOOL_READY"
fi
###********************************


bash /usr/lib/udev/init-net-rules.sh 
cat /etc/udev/rules.d/70-persistent-net.rules # enp60s0
export network_card_name=$(grep 'NAME="' /etc/udev/rules.d/70-persistent-net.rules | sed -E 's/.*NAME="([^"]*)".*/\1/'
)
export network_card_ip="192.168.1.21"

cd /etc/sysconfig/
cat > ifconfig.eth0 <<EOF
ONBOOT=yes
IFACE=$network_card_name
SERVICE=ipv4-static
IP=$network_card_ip
GATEWAY=192.168.0.1
PREFIX=24
BROADCAST=192.168.0.255
EOF

cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf
domain 
#nameserver <IP address of your primary nameserver>
#nameserver <IP address of your secondary nameserver>
# End /etc/resolv.conf
EOF

echo "$DESTRO_HOSTNAME" > /etc/hostname

cat > /etc/hosts <<EOF
# Begin /etc/hosts
127.0.0.1 localhost.localdomain localhost
127.0.1.1 $DESTRO_HOSTNAME
# End /etc/hosts
EOF

cat > /etc/inittab << "EOF"
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

LOGLEVEL="3"
UNICODE="1"
KEYMAP="uk"
FONT="Lat2-Terminus16"

# End /etc/sysconfig/console
EOF


## sys local
echo -e "$CHOOSE_SYS_LOCAL"
ALL_SYS_LOCALS=$(locale -a | sort)
printf "%s\n" "$ALL_SYS_LOCALS"

while true; do
   chosen_local=$(read_non_empty_string "$INPUT_SYS_L_VALUE")
   if echo "$ALL_SYS_LOCALS" | grep -q "^$chosen_local$"; then
      echo -e "$VALID_SYS_L $chosen_local"
      break
   fi
   echo -e "$NOT_VALID_SYS_L"
done


CHOOSEN_CHARMAP="$(LC_ALL="$chosen_local" locale charmap)"
formatted_locale=$(echo "$chosen_local" | sed -E 's/\.(utf8|UTF-8|[a-zA-Z0-9_-]+)$//')

cat > /etc/profile <<EOF
# Begin /etc/profile

for i in $(locale); do
  unset ${i%=*}
done

if [[ "$TERM" = linux ]]; then
  export LANG=C.UTF-8
else
   #format : <ll>_<CC>.<charmap><@modifiers>
  export LANG=$formatted_locale.$CHOOSEN_CHARMAP
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

# file system           mount-point    type     options             dump  fsck
#                                                                         order

$DISTRO_PARTITION_NAME  /              ext4     defaults            1     1
/dev/nvme0n1p4          swap           swap     pri=1               0     0
/dev/nvme0n1p6          /boot          ext4     noauto,defaults     1     2 
/dev/nvme0n1p1          /boot/efi      vfat     codepage=437,iocharset=iso8859-1 0 1
proc                    /proc          proc     nosuid,noexec,nodev 0     0
sysfs                   /sys           sysfs    nosuid,noexec,nodev 0     0
devpts                  /dev/pts       devpts   gid=5,mode=620      0     0
tmpfs                   /run           tmpfs    defaults            0     0
devtmpfs                /dev           devtmpfs mode=0755,nosuid    0     0
tmpfs                   /dev/shm       tmpfs    nosuid,nodev        0     0
cgroup2                 /sys/fs/cgroup cgroup2  nosuid,noexec,nodev 0     0

# End /etc/fstab
EOF
cd /sources




###Linux_Kernel: 2.5SBU
if [ -n "$Linux_Kernel" ] ;then
   echo -e "$START_JOB" " 2.5 SBU"
   echo $Linux_Kernel
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

   mount /boot
   mount --mkdir -v -t vfat /dev/nvme0n1p1 -o codepage=437,iocharset=iso8859-1 \
      /boot/efi

   cp -iv arch/x86/boot/bzImage /boot/vmlinuz-6.10.5-$DISTRO_NAME
   cp -iv System.map /boot/System.map-6.10.5

   if $ADD_OPTIONNAL_DOCS; then
      cp -iv .config /boot/config-6.10.5
      cp -r Documentation -T /usr/share/doc/$Linux_Kernel
   fi

   chown -R 0:0 ../$Linux_Kernel

   grub-install --target=x86_64-efi --removable
   mountpoint /sys/firmware/efi/efivars || mount -v -t efivarfs efivarfs /sys/firmware/efi/efivars

   cat >> /etc/fstab <<EOF
efivarfs /sys/firmware/efi/efivars efivarfs defaults 0 0
EOF

   grub-install --bootloader-id=$DISTRO_NAME --recheck

   cd /sources/
   #  rm -Rf $Linux_Kernel #rm extracted pkg
   #  echo -e "$DONE" 
   #  echo -e $Linux_Kernel "$TOOL_READY"
fi
###********************************

cat > /boot/grub/grub.cfg << EOF
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod part_gpt
insmod ext2
set root=(hd0,6)

insmod efi_gop
insmod efi_uga
if loadfont /boot/grub/fonts/unicode.pf2; then
  terminal_output gfxterm
fi

menuentry "GNU/Linux, $DISTRO_NAME" {
  linux   /vmlinuz-6.10.5-$DISTRO_NAME root=$DISTRO_PARTITION_NAME ro
}

menuentry "Firmware Setup" {
  fwsetup
}
EOF





## Find or Create the EFI System Partition
echo -e "$MAKING_EFI_System_Partition"
lsblk
EFI_System_Partition=$(read_non_empty_string "$INPUT_EFI_System_Partition_NAME")
mkfs.vfat /dev/$EFI_System_Partition

fdisk /dev/$EFI_System_Partition

mount --mkdir -v -t vfat /dev/$EFI_System_Partition -o codepage=437,iocharset=iso8859-1 \
      /boot/efi

cat >> /etc/fstab << EOF
/dev/$EFI_System_Partition /boot/efi vfat codepage=437,iocharset=iso8859-1 0 1
EOF
echo -e "$DONE"
###*********************************

echo 12.2 > /etc/lfs-release

cat > /etc/lsb-release <<EOF
DISTRIB_ID="$DISTRO_NAME"
DISTRIB_RELEASE="0"
DISTRIB_CODENAME="$DISTRO_NAME"
DISTRIB_DESCRIPTION="$DISTRO_NAME was made by from scratch with help of LFS-BLFS"
EOF

cat > /etc/os-release <<EOF
NAME="$DESTRO_HOSTNAME"
VERSION="0"
ID=$DISTRO_NAME
PRETTY_NAME="Linux $DISTRO_NAME"
VERSION_CODENAME="$DISTRO_NAME"
HOME_URL="https://github.com/ARayane24/LFS"
EOF


popd
echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$END_STEP8${STEP}*     #
    ############################################### ${NO_STYLE}
    "

echo -e "$DONE"
echo -e "$END_OF_BASH_WORK"

logout

umount -v $LFS/dev/pts
mountpoint -q $LFS/dev/shm && umount -v $LFS/dev/shm
umount -v $LFS/dev
umount -v $LFS/run
umount -v $LFS/proc
umount -v $LFS/sys

umount -v $LFS/home
umount -v $LFS

umount -v $LFS

cd $LFS
tar -cvJpf $HOME/${DISTRO_NAME}-temp-os.tar.xz .
echo -e "$DONE"
echo $HOME/${DISTRO_NAME}-temp-os.tar.xz