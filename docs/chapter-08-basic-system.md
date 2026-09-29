# Chapter 8 — Installing Basic System Software

Base: Linux From Scratch 13.1-systemd

## Status

Chapter 8 is in progress.

Current checkpoint:

- Completed through Binutils 2.47
- 20 Chapter 8 packages installed
- Next package: GMP 6.3.0

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

## Next step

Resume Chapter 8 with GMP 6.3.0.
