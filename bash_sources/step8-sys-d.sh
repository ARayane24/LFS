#!/bin/bash
# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing



########################
###** Start chap 9 **###
########################


echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$START_STEP8${STEP}*   #
    ############################################### ${NO_STYLE}
    "

pushd /sources

## Network config
ln -s /dev/null /etc/systemd/network/99-default.link

export MAC_ADDRESS_NAME=$(read_non_empty_string "$INPUT_MAC_ADDRESS_eth_NAME")
export INTERFACE_NAME=$(read_non_empty_string "$INPUT_interface_eth_NAME")

cat > /etc/systemd/network/10-$INTERFACE_NAME.link <<EOF
[Match]
# Change the MAC address as appropriate for your network device
MACAddress=$MAC_ADDRESS_NAME

[Link]
Name=$INTERFACE_NAME
EOF

cat > /etc/systemd/network/10-eth-static.network <<EOF
[Match]
Name=$INTERFACE_NAME

[Network]
Address=192.168.0.2/24
Gateway=192.168.0.1
DNS=192.168.0.1
#Domains=<Your Domain Name>
EOF

cat > /etc/systemd/network/10-eth-dhcp.network <<EOF
[Match]
Name=$INTERFACE_NAME

[Network]
DHCP=ipv4

[DHCPv4]
UseDomains=true
EOF


export MAC_ADDRESS_NAME=$(read_non_empty_string "$INPUT_MAC_ADDRESS_wifi_NAME")
export INTERFACE_NAME=$(read_non_empty_string "$INPUT_interface_wifi_NAME")

cat > /etc/systemd/network/10-$INTERFACE_NAME.link <<EOF
[Match]
# Change the MAC address as appropriate for your network device
MACAddress=$MAC_ADDRESS_NAME

[Link]
Name=$INTERFACE_NAME
EOF

cat > /etc/systemd/network/10-wifi-static.network <<EOF
[Match]
Name=$INTERFACE_NAME

[Network]
Address=192.168.0.2/24
Gateway=192.168.0.1
DNS=192.168.0.1
#Domains=<Your Domain Name>
EOF

cat > /etc/systemd/network/10-wifi-dhcp.network <<EOF
[Match]
Name=$INTERFACE_NAME

[Network]
DHCP=ipv4

[DHCPv4]
UseDomains=true
EOF

cat > /etc/resolv.conf <<EOF
nameserver 8.8.8.8  # Google DNS
EOF

echo "$DESTRO_HOSTNAME" > /etc/hostname

cat > /etc/hosts <<EOF
# Begin /etc/hosts
127.0.0.1 localhost
127.0.1.1 $DESTRO_HOSTNAME
# End /etc/hosts
EOF


## Config console

cat > /etc/vconsole.conf <<EOF
FONT=Lat2-Terminus16
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

cat > /etc/locale.conf <<EOF
#format : <ll>_<CC>.<charmap><@modifiers>
LANG=$formatted_locale.$CHOOSEN_CHARMAP
EOF

cat > /etc/profile <<EOF
# Begin /etc/profile

for i in $(locale); do
  unset ${i%=*}
done

if [[ "$TERM" = linux ]]; then
  export LANG=C.UTF-8
else
  source /etc/locale.conf

  for i in $(locale); do
    key=${i%=*}
    if [[ -v $key ]]; then
      export $key
    fi
  done
fi

# End /etc/profile
EOF

## console commands edit capabilities 
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


cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF

mkdir -pv /etc/systemd/system/getty@tty1.service.d

cat > /etc/systemd/system/getty@tty1.service.d/noclear.conf << EOF
[Service]
TTYVTDisallocate=no
EOF

mkdir -pv /etc/systemd/coredump.conf.d

cat > /etc/systemd/coredump.conf.d/maxuse.conf << EOF
[Coredump]
MaxUse=5G
EOF


swap_partition=$(read_non_empty_string "$INPUT_swp_Partition_NAME")

## Creating the /etc/fstab File
cat > /etc/fstab <<EOF
# Begin /etc/fstab

# file system           mount-point    type     options             dump  fsck
#                                                                         order

$DISTRO_PARTITION_NAME  /              ext4     defaults            1     1
/dev/$swap_partition    swap           swap     pri=1               0     0

# End /etc/fstab
EOF


cd /sources
###Linux_Kernel: 2.5SBU
if [ -n "$Linux_Kernel" ] ;then
   echo -e "$START_JOB" " 2.5 SBU"
   echo $Linux_Kernel
   extract_tar_files /sources "$Linux_Kernel"
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

   cp -iv arch/x86/boot/bzImage /boot/vmlinuz-6.10.5-$DISTRO_NAME
   cp -iv System.map /boot/System.map-6.10.5

   if $ADD_OPTIONNAL_DOCS; then
      cp -iv .config /boot/config-6.10.5
      cp -r Documentation -T /usr/share/doc/$Linux_Kernel
   fi

   chown -R 0:0 ../$Linux_Kernel

    install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf <<EOF
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF

   cd /sources/
   #  rm -Rf $Linux_Kernel #rm extracted pkg
   echo -e "$DONE" 
   echo -e $Linux_Kernel "$TOOL_READY"
fi
###********************************

# debug_mode true

boot_partition_root=$(read_non_empty_string "$INPUT_boot_partition_root_NAME")

cat > /boot/grub/grub.cfg << EOF
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod part_gpt
insmod ext2
set root=$boot_partition_root


menuentry "GNU/Linux, $DISTRO_NAME" {
linux   /boot/vmlinuz-6.10.5-$DISTRO_NAME root=$DISTRO_PARTITION_NAME ro
}
EOF

## The end
echo "12.2" > /etc/lfs-release

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
