# Chapter 10 — Making the LFS System Bootable

Base: Linux From Scratch 13.1-systemd

## Status

Chapter 10 is partially complete.

Completed on the build host:

- target filesystem layout defined
- /etc/fstab created
- Linux 7.1.8 configured for the MacBookAir6,2
- kernel and modules built successfully
- kernel artifacts installed under /boot
- kernel configuration preserved in Git
- GRUB 2.14 x86_64 EFI support verified

Deferred until deployment to the physical MacBook Air:

- creation of the real GPT partition table
- creation and mounting of the real EFI System Partition
- final GRUB installation
- final grub.cfg using the real root partition PARTUUID

## Target storage layout

The 2014 MacBook Air internal SSD is dedicated entirely to erebOS.

Planned layout:

    GPT
    ├── Partition 1   512 MiB   FAT32   EFI System Partition
    │                            filesystem label: EREBOS_EFI
    └── Partition 2   remainder  ext4    erebOS root filesystem
                                 filesystem label: erebOS-root

No dedicated swap partition is planned.

If swap is required after deployment, a swapfile can be added later without
changing the partition layout.

## /etc/fstab

The target filesystem table is:

    LABEL=erebOS-root   /            ext4   defaults                                     1  1
    LABEL=EREBOS_EFI    /boot/efi    vfat   rw,relatime,codepage=437,iocharset=iso8859-1,umask=0077  0  2

Stable filesystem labels are used instead of /dev/sdX device names.

The EFI System Partition will be mounted at:

    /boot/efi

The ESP mount point has been created in the erebOS root filesystem.

## Kernel

Kernel version:

    Linux 7.1.8

Kernel release:

    7.1.8

Build host:

    Acer Nitro 5 AN515-52

Build parallelism:

    MAKEFLAGS=-j4

Build command:

    time make

Build result:

    Kernel: arch/x86/boot/bzImage is ready (#1)

Build timing:

    real    9m50.410s
    user    34m40.550s
    sys     3m40.640s

## Kernel configuration strategy

The kernel was configured specifically for the target MacBookAir6,2 rather
than by detecting the Acer Nitro build host.

The process was:

    make mrproper
    make defconfig

followed by deliberate LFS and MacBookAir6,2 configuration changes.

make localmodconfig was not used because it would configure the kernel for
the Nitro rather than the target MacBook Air.

The first erebOS kernel prioritises reliable booting and diagnostics over
aggressive minimisation.

## No-initramfs design

The initial erebOS boot is designed without an initramfs.

For this reason, all components required to reach and mount the root
filesystem are built directly into the kernel.

Boot-critical storage configuration includes:

    CONFIG_ATA=y
    CONFIG_SATA_AHCI=y
    CONFIG_SCSI=y
    CONFIG_BLK_DEV_SD=y
    CONFIG_EXT4_FS=y

This provides the path:

    MacBook PCIe SSD
        -> AHCI
        -> SCSI disk layer
        -> ext4 root filesystem

EFI and partition support is also built in:

    CONFIG_EFI=y
    CONFIG_EFI_STUB=y
    CONFIG_EFI_PARTITION=y

## LFS/systemd kernel configuration

Important LFS 13.1-systemd settings include:

    CONFIG_WERROR=n
    CONFIG_PSI=y
    CONFIG_PSI_DEFAULT_DISABLED=n
    CONFIG_CGROUPS=y
    CONFIG_MEMCG=y
    CONFIG_CGROUP_SCHED=y
    CONFIG_RT_GROUP_SCHED=n
    CONFIG_DEVTMPFS=y
    CONFIG_DEVTMPFS_MOUNT=y
    CONFIG_LEGACY_TIOCSTI=n
    CONFIG_TMPFS=y
    CONFIG_TMPFS_POSIX_ACL=y

Diagnostic framebuffer support was enabled:

    CONFIG_SYSFB_SIMPLEFB=y
    CONFIG_DRM_PANIC=y
    CONFIG_DRM_PANIC_SCREEN="kmsg"
    CONFIG_DRM_FBDEV_EMULATION=y
    CONFIG_DRM_SIMPLEDRM=y
    CONFIG_FRAMEBUFFER_CONSOLE=y

These settings improve visibility of early boot failures before the full
graphics driver is loaded.

## MacBookAir6,2-specific kernel choices

Apple EFI support:

    CONFIG_APPLE_PROPERTIES=y

Internal keyboard support:

    CONFIG_HID_APPLE=y

USB and recovery input support is built into the kernel:

    CONFIG_USB=y
    CONFIG_USB_XHCI_HCD=y
    CONFIG_USB_XHCI_PCI=y
    CONFIG_HID=y
    CONFIG_HID_GENERIC=y
    CONFIG_USB_HID=y

Intel graphics is modular for the initial boot:

    CONFIG_DRM_I915=m

This allows SimpleDRM to remain available during the earliest boot stages
and preserves useful early-console diagnostics.

Additional target hardware is modular:

    CONFIG_MOUSE_BCM5974=m
    CONFIG_SENSORS_APPLESMC=m
    CONFIG_INTEL_POWERCLAMP=m
    CONFIG_X86_PKG_TEMP_THERMAL=m

Broad USB Ethernet coverage was included because the exact recovery adapter
chipset should not be assumed before target testing:

    CONFIG_USB_USBNET=m
    CONFIG_USB_NET_AX8817X=m
    CONFIG_USB_NET_AX88179_178A=m
    CONFIG_USB_RTL8152=m
    CONFIG_USB_NET_CDCETHER=m

Wired Ethernet remains the preferred initial networking and recovery path.

## Installed kernel artifacts

Installed under /boot:

    /boot/vmlinuz-7.1.8-lfs-13.1-systemd
    /boot/System.map-7.1.8
    /boot/config-7.1.8

Observed sizes:

    vmlinuz-7.1.8-lfs-13.1-systemd   approximately 14 MiB
    System.map-7.1.8                 approximately 8.2 MiB
    config-7.1.8                     approximately 146 KiB

Kernel modules were installed under:

    /usr/lib/modules/7.1.8

Installed module tree size:

    approximately 12 MiB

Kernel documentation was copied to:

    /usr/share/doc/linux-7.1.8

## Reproducible kernel configuration

The exact successful kernel configuration has been preserved in the
repository as:

    configs/kernel/linux-7.1.8-macbookair6-2.config

SHA256:

    1a7fc61a477f45ca394aba855148c671ca70289f95566fd261a8a3fbf152cf4e

This checksum matches /boot/config-7.1.8 from the built erebOS filesystem.

The kernel source tree was retained at:

    /sources/linux-7.1.8

and ownership was normalised to root:root after the build.

No /usr/src/linux symlink was created.

## GRUB

GRUB version:

    GRUB 2.14

Architecture/platform:

    x86_64 EFI

Verified module directory:

    /usr/lib/grub/x86_64-efi

Required modules confirmed present:

    part_gpt.mod
    ext2.mod
    linux.mod

No GRUB installation was performed against the Acer Nitro or the temporary
build image.

## Why final GRUB installation is deferred

The current /boot/efi directory is only a mount point inside the erebOS
build filesystem.

The real FAT32 EFI System Partition does not exist until the MacBook Air
internal SSD is partitioned.

Running grub-install during the Nitro-hosted build would therefore not
install GRUB to the real target ESP.

The final bootloader installation will be performed only after the target
SSD exists and the ESP is mounted at /boot/efi.

## Target deployment sequence

The planned deployment sequence is:

1. Boot a suitable Linux environment on the MacBook Air.
2. Confirm the internal SSD device identity before destructive changes.
3. Create a GPT partition table.
4. Create a 512 MiB EFI System Partition.
5. Create an ext4 root partition using the remaining space.
6. Label the filesystems:

       EREBOS_EFI
       erebOS-root

7. Deploy the erebOS root filesystem to the ext4 partition.
8. Mount the root filesystem.
9. Mount the EFI System Partition at /boot/efi.
10. Determine the actual root partition PARTUUID.
11. Enter the deployed erebOS environment.
12. Install GRUB for x86_64 EFI using the removable/fallback boot path.
13. Create grub.cfg using the real root PARTUUID.
14. Reboot and perform the first native MacBookAir6,2 boot.

The exact target disk device name must be verified before any partitioning
or formatting commands are issued.

## GRUB root identification

The final kernel command line will use the actual target root partition
PARTUUID rather than a guessed device name.

Conceptually:

    root=PARTUUID=<actual-root-partition-partuuid>

GRUB configuration should also search for the erebOS root filesystem rather
than relying on fixed GRUB disk numbering.

The real PARTUUID will only be recorded after the MacBook SSD has been
partitioned.

## Current checkpoint

Chapter 10 kernel work is complete.

The remaining Chapter 10 work is target-dependent and intentionally deferred
until deployment to the physical MacBook Air.

The current erebOS image now contains a complete base userspace, system
configuration, Linux 7.1.8 kernel, and kernel modules suitable for beginning
the target deployment phase.
