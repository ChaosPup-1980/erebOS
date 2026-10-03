# Chapter 11 — Finalization

Base: Linux From Scratch 13.1-systemd

## Status

Chapter 11 build-side finalization is complete.

Completed on 2026-10-03.

The normal LFS final reboot is intentionally deferred because erebOS is
being built inside a filesystem image on an Acer Nitro build host and will
be deployed to a 2014 MacBook Air before its first native boot.

## System identity

The upstream LFS provenance is preserved in:

    /etc/lfs-release

with:

    13.1-systemd

The installed operating system identifies itself as erebOS.

### /etc/os-release

    NAME="erebOS"
    ID=erebos
    PRETTY_NAME="erebOS"
    HOME_URL="https://github.com/ChaosPup-1980/erebOS"
    BUILD_ID="lfs-13.1-systemd"

### /etc/lsb-release

    DISTRIB_ID="erebOS"
    DISTRIB_RELEASE="LFS-13.1-systemd"
    DISTRIB_DESCRIPTION="erebOS (Linux From Scratch 13.1-systemd)"

No artificial erebOS release number or codename has been assigned yet.

## Root account

The root account was verified with:

    passwd -S root

Status:

    P

This confirms that a usable root password is already configured.

The password itself is not recorded in project documentation.

## Final configuration review

The following files were reviewed before deployment:

- /etc/fstab
- /etc/hosts
- /etc/inputrc
- /etc/profile
- /etc/resolv.conf
- /etc/vimrc

/etc/resolv.conf is intentionally absent before first boot because
systemd-resolved is enabled.

/etc/vimrc was found to be missing during this review and was corrected
before deployment.

The installed /etc/vimrc follows the LFS configuration and includes:

- Vim defaults loaded before local customisation
- nocompatible mode
- normal backspace behaviour
- mouse support disabled
- syntax highlighting enabled
- dark-background handling for xterm and PuTTY terminals

## Firmware review

No general firmware bundle was installed.

This is intentional. Firmware will be added only for hardware that
actually requires it.

The first-boot-critical hardware path does not require external firmware:

- AHCI storage
- ext4 root filesystem
- EFI/SimpleDRM console
- USB keyboard
- Apple HID support
- Apple SMC
- BCM5974 trackpad

The Intel i915 module reports firmware names for newer Intel graphics
generations, but these are not required for the MacBookAir6,2 Haswell
graphics first-boot path.

Broadcom BCM4360 Wi-Fi support remains deferred until after wired
networking and SSH are operational.

## Wired recovery adapter

The USB Gigabit Ethernet adapter intended for initial networking and
recovery was positively identified on the build host:

    USB ID: 0b95:1790
    Device: ASIX AX88179 Gigabit Ethernet

The erebOS Linux 7.1.8 module tree contains a matching alias:

    alias usb:v0B95p1790d*dc*dsc*dp*icFFiscFFip00in* ax88179_178a

The kernel configuration contains:

    CONFIG_USB_NET_AX88179_178A=m

The ax88179_178a driver declares no external firmware requirement.

This confirms that the planned wired first-boot networking path is present
in the erebOS kernel.

## First-boot networking path

Planned path:

    MacBook Air USB
        -> ASIX AX88179
        -> ax88179_178a module
        -> systemd-networkd
        -> IPv4 DHCP
        -> wired home-lab network

Wired Ethernet remains the preferred initial administration and recovery
path.

Wi-Fi will be configured later through BLFS after the base system has
booted successfully.

## Next step

Prepare a final offline recovery snapshot of the completed LFS base system.

After that, begin deployment to the dedicated MacBook Air internal SSD:

1. identify the target SSD with certainty
2. create the GPT layout
3. create the EFI System Partition
4. create and label the ext4 root filesystem
5. deploy the erebOS filesystem
6. mount the real ESP
7. determine the real root PARTUUID
8. install GRUB to the MacBook Air
9. create the final grub.cfg
10. perform the first native erebOS boot

## Pre-deployment recovery snapshot

A final offline recovery snapshot was created after completion of the LFS
base system and all pre-deployment checks:

    backups/erebOS-predeployment.img

The source image was checked offline before copying:

    e2fsck -fn build/erebOS-lfs.img

Result:

    PASS

The recovery snapshot itself was then checked independently:

    e2fsck -fn backups/erebOS-predeployment.img

Result:

    PASS

Filesystem summary:

    erebOS-lfs: 357478/4194304 files (0.1% non-contiguous),
    2816477/16777216 blocks

Snapshot storage:

- logical size: 64 GB
- actual disk usage: approximately 23 GB

This is the canonical known-good recovery point immediately before
deployment to the physical MacBookAir6,2.
