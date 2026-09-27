# erebOS Build Session Workflow

## Starting an erebOS session

Before performing LFS build work:

1. Change to the erebOS project directory.
2. Ensure /bin/sh points to Bash.
3. Ensure the erebOS build filesystem is mounted at /mnt/lfs.
4. Set LFS=/mnt/lfs.
5. Verify the environment before continuing.

Normal startup commands:

    cd ~/Projects/erebOS
    ./scripts/start-erebos.sh
    export LFS=/mnt/lfs

Verification commands:

    readlink -f /bin/sh
    findmnt /mnt/lfs
    echo "$LFS"

Expected state:

- /bin/sh resolves to /usr/bin/bash
- /mnt/lfs is mounted from the erebOS build image
- LFS=/mnt/lfs

## Ending an erebOS session

Run:

    cd ~/Projects/erebOS
    ./scripts/stop-erebos.sh

This unmounts the erebOS build filesystem and restores Ubuntu's normal /bin/sh link to Dash.

Expected final state:

    /bin/sh -> /usr/bin/dash

## Important

Do not perform LFS build operations unless the erebOS filesystem is mounted and LFS is set correctly.

## Host Bash configuration

Ubuntu's /etc/bash.bashrc is temporarily moved to
/etc/bash.bashrc.NOUSE during active LFS build sessions to prevent
host shell configuration from contaminating the sterile LFS environment.

The erebOS start and stop scripts handle this automatically.
