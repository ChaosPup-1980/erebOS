# LFS Chapter 6 — Cross Compiling Temporary Tools

Base: Linux From Scratch 13.1-systemd

## Result

Chapter 6 completed successfully.

Temporary tools built:

- M4 1.4.21
- Ncurses 6.6
- Bash 5.3
- Coreutils 9.11
- Diffutils 3.12
- File 5.48
- Findutils 4.11.0
- Gawk 5.4.1
- Grep 3.12
- Gzip 1.14
- Make 4.4.1
- Patch 2.8
- Sed 4.10
- Tar 1.35
- Xz 5.8.3
- Binutils 2.47 Pass 2
- GCC 16.2.0 Pass 2

## GCC Pass 2

Result: PASS

Combined build/install timing:

- real: 18m2.886s
- user: 60m3.006s
- sys: 4m27.128s

Verified:

- gcc installed
- g++ installed
- cc -> gcc
- libstdc++.so.6.0.36 installed
- libgcc_s.so.1 installed
- x86-64 target architecture
- /lib64/ld-linux-x86-64.so.2 program interpreter

## Build issue encountered

M4 initially failed with:

    #error "Assumed value of MB_LEN_MAX wrong"

Cause:

The temporary GCC internal limits.h header was incomplete.

Resolution:

- removed the conflicting include-fixed limits.h
- recreated GCC's internal limits.h from limitx.h, glimits.h, and limity.h
- verified Glibc headers compiled successfully
- rebuilt M4 from a clean source tree

Result:

M4 rebuilt successfully with no package-level workaround required.

## Chapter Status

PASS
