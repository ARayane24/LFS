#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

cd /LFS/bash_sources
source /.bashrc
#***************************************************************************#
   echo -e "${STEP}
    ###############################################
    #   *${NO_STYLE}$START_STEP4${STEP}*   #
    ############################################### ${NO_STYLE}
    "

mkdir -pv /{boot,home,mnt,opt,srv}
mkdir -pv /etc/{opt,sysconfig}
mkdir -pv /lib/firmware
mkdir -pv /media/{floppy,cdrom}
mkdir -pv /usr/{,local/}{include,src}
mkdir -pv /usr/local/{bin,lib,sbin}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv /usr/{,local/}share/man/man{1..8}
mkdir -pv /var/{cache,local,log,mail,opt,spool}
mkdir -pv /var/lib/{color,misc,locate}

## add other dirs bellow to follow Filesystem Hierarchy Standard (FHS) (available at https://refspecs.linuxfoundation.org/fhs.shtml)
#mkdir ...


ln -sfv /run /var/run
ln -sfv /run/lock /var/lock

install -dv -m 0750 /root         # only root
install -dv -m 1777 /tmp /var/tmp #sticky bit



ln -sv /proc/self/mounts /etc/mtab # currently mounted parts like fstab. but, fstab is for automaticly mount the parts while booting

cat > /etc/hosts << EOF
127.0.0.1  localhost $(hostname)
::1        localhost
EOF


### let the os recognized "root"
cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/usr/bin/false
daemon:x:6:6:Daemon User:/dev/null:/usr/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false
uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false
nobody:x:65534:65534:Unprivileged User:/dev/null:/usr/bin/false
EOF


cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
input:x:24:
mail:x:34:
kvm:x:61:
uuidd:x:80:
wheel:x:97:
users:x:999:
nogroup:x:65534:
EOF


# create user named tester
echo "tester:x:101:101::/home/tester:/bin/bash" >> /etc/passwd
echo "tester:x:101:" >> /etc/group
install -o tester -d /home/tester


SAVE="
export NEXT_STEP=/LFS/bash_sources/step4.2.sh
"
echo "$SAVE" >> /.bashrc
source /.bashrc


echo -e "$DONE"
exec /usr/bin/bash --login -c "bash $NEXT_STEP"