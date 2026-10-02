# Chapter 8 — Installing Basic System Software

Base: Linux From Scratch 13.1-systemd

## Status

Chapter 8 is complete.

Final checkpoint:

- Completed through E2fsprogs 1.47.4
- All Chapter 8 package builds completed
- Final Chapter 8 cleanup completed
- Optional stripping deliberately skipped
- Next stage: LFS Chapter 9 — System Configuration

## Completed packages

1. Man-pages 6.18
2. Iana-Etc 20260805
3. Glibc 2.44
4. Zlib 1.3.2
5. Bzip2 1.0.8
6. Xz 5.8.3
7. Lz4 1.10.0
8. Zstd 1.5.7
9. File 5.48
10. Readline 8.3
11. PCRE2 10.47
12. M4 1.4.21
13. Bc 7.0.3
14. Flex 2.6.4
15. Tcl 8.6.18
16. Expect 5.45.4
17. DejaGNU 1.6.3
18. Ninja 1.13.2
19. Pkgconf 3.0.5
20. Binutils 2.47

## Build settings

Build parallelism is deliberately limited on the Acer Nitro:

- MAKEFLAGS=-j4
- TESTSUITEFLAGS=-j4
- NINJAJOBS=4

## Test notes

### Glibc 2.44

Results: 6777 PASS, 581 UNSUPPORTED, 16 XFAIL, 1 FAIL.

The only failure was io/tst-lchmod, which is a documented expected failure in the LFS chroot environment.

### Tcl 8.6.18

47159 total tests: 43704 passed, 3455 skipped, 0 failed.

### Expect 5.45.4

29 passed, 0 failed.

### DejaGNU 1.6.3

300 expected passes.

### Pkgconf 3.0.5

32 passed, 0 failed.

### Binutils 2.47

The critical Binutils test suite was run with make -k check.

The only failure reported was:

FAIL: tmpdir/gp-gmon

This is the documented known gprofng failure for this LFS build and was accepted.

Installed ld, as and objdump report GNU Binutils 2.47.20260726.

Static Binutils libraries were removed according to the LFS instructions.

## Chapter 8 completion

Chapter 8 — Installing Basic System Software — completed successfully on 2026-10-02.

All Chapter 8 packages were built, tested where applicable, installed, and verified.

### erebOS-specific decisions

- Build parallelism remained limited to `MAKEFLAGS=-j4` to control sustained thermal load on the Acer Nitro build host.
- Libffi 3.8.0 was built with `--with-gcc-arch=haswell`, targeting the MacBookAir6,2 rather than the Nitro host CPU.
- GRUB 2.14 was built for `x86_64-efi` only, matching the MacBook Air target. No bootloader was installed to a physical disk during Chapter 8.
- The optional Chapter 8 stripping stage was deliberately skipped. Debugging symbols are being retained while erebOS remains under active development and hardware bring-up.

### Notable expected test results

- Findutils 4.11.0: `test-regex-el` was the sole known test failure.
- Groff 1.24.1: `neqn-smoke-test.sh` was the sole known test failure.
- Tar 1.35: test 233, `capabilities: binary store/restore`, was the sole known failure.
- Vim 9.2.1025: test suite completed with `FAILED: 0`.
- Systemd 261.2: 1829 tests passed, 32 skipped, with only the documented chroot failure `systemd:test-namespace`.
- Procps-ng 4.0.7: 8 tests passed, 0 failed.
- Util-linux 2.42.2: all 367 tests passed.
- E2fsprogs 1.47.4: 393 tests passed; `m_assume_storage_prezeroed` was the sole documented expected failure.

### Final cleanup

The Chapter 8 cleanup was completed:

- `/tmp` contents removed
- obsolete libtool `.la` files removed
- temporary LFS cross-toolchain remnants removed
- temporary `tester` account removed

Verification confirmed no matching temporary toolchain files or `.la` files remained.

## Next step

LFS Chapter 9 — System Configuration.

Before beginning Chapter 9, create and verify an offline Chapter 8 recovery snapshot.
