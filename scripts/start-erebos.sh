#!/usr/bin/env bash

set -e

PROJECT="$HOME/Projects/erebOS"
IMAGE="$PROJECT/build/erebOS-lfs.img"
LFS="/mnt/lfs"

echo "=== Starting erebOS build session ==="

if [ "$(readlink -f /bin/sh)" != "/usr/bin/bash" ]; then
    echo "Switching host /bin/sh to Bash..."
    sudo ln -sf bash /bin/sh
fi

if [ -e /etc/bash.bashrc ] && [ ! -e /etc/bash.bashrc.NOUSE ]; then
    echo "Temporarily disabling host /etc/bash.bashrc..."
    sudo mv /etc/bash.bashrc /etc/bash.bashrc.NOUSE
fi

sudo mkdir -p "$LFS"

if ! mountpoint -q "$LFS"; then
    echo "Mounting erebOS filesystem..."
    sudo mount -o loop -t ext4 "$IMAGE" "$LFS"
fi

sudo mkdir -p "$LFS"/{dev,proc,sys,run}

if ! mountpoint -q "$LFS/dev"; then
    sudo mount --bind /dev "$LFS/dev"
fi

if ! mountpoint -q "$LFS/dev/pts"; then
    sudo mount -t devpts devpts \
        -o gid=5,mode=0620 "$LFS/dev/pts"
fi

if ! mountpoint -q "$LFS/proc"; then
    sudo mount -t proc proc "$LFS/proc"
fi

if ! mountpoint -q "$LFS/sys"; then
    sudo mount -t sysfs sysfs "$LFS/sys"
fi

if ! mountpoint -q "$LFS/run"; then
    sudo mount -t tmpfs tmpfs "$LFS/run"
fi

if [ -h "$LFS/dev/shm" ]; then
    sudo install -d -m 1777 "$LFS$(realpath /dev/shm)"
elif ! mountpoint -q "$LFS/dev/shm"; then
    sudo mount -t tmpfs -o nosuid,nodev tmpfs "$LFS/dev/shm"
fi

echo
echo "erebOS environment ready."
echo "/bin/sh -> $(readlink -f /bin/sh)"
echo
findmnt | grep "$LFS"

echo
echo "To enter erebOS:"
echo
echo "sudo chroot /mnt/lfs /usr/bin/env -i \\"
echo "    HOME=/root TERM=\"\$TERM\" \\"
echo "    PS1='(erebOS chroot) \\u:\\w\\\$ ' \\"
echo "    PATH=/usr/bin:/usr/sbin \\"
echo "    MAKEFLAGS='-j4' TESTSUITEFLAGS='-j4' \\"
echo "    /bin/bash --login"
