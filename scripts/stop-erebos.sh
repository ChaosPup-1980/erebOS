#!/usr/bin/env bash

set -e

LFS="/mnt/lfs"

echo "=== Closing erebOS build session ==="

if mountpoint -q "$LFS"; then
    echo "Unmounting erebOS build filesystem..."
    sudo umount "$LFS"
fi

if [ "$(readlink -f /bin/sh)" != "/usr/bin/dash" ]; then
    echo "Restoring Ubuntu /bin/sh to Dash..."
    sudo ln -sf dash /bin/sh
fi

echo
echo "erebOS session closed."
echo "/bin/sh -> $(readlink -f /bin/sh)"
