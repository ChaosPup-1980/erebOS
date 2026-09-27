#!/usr/bin/env bash

set -e

PROJECT="$HOME/Projects/erebOS"
IMAGE="$PROJECT/build/erebOS-lfs.img"
LFS="/mnt/lfs"

echo "=== Starting erebOS build session ==="

if [ "$(readlink -f /bin/sh)" != "/usr/bin/bash" ]; then
    echo "Switching /bin/sh to Bash for LFS..."
    sudo ln -sf bash /bin/sh
fi

sudo mkdir -p "$LFS"

if ! mountpoint -q "$LFS"; then
    echo "Mounting erebOS build filesystem..."
    sudo mount -o loop -t ext4 "$IMAGE" "$LFS"
else
    echo "$LFS is already mounted."
fi

export LFS

echo
echo "erebOS build environment ready."
echo "/bin/sh -> $(readlink -f /bin/sh)"
findmnt "$LFS"
echo
echo "Run:"
echo "  export LFS=/mnt/lfs"
