# erebOS

**erebOS** is a Linux From Scratch (LFS)/Beyond Linux From Scratch (BLFS) project to build a lightweight, purpose-built Linux system for use as a headless home-lab server.

The project is being developed as both a practical system and a learning exercise – building a usable Linux environment from source while understanding and documenting the decisions, problems, fixes, and concepts encountered along the way.

Rather than producing a general-purpose desktop distribution, erebOS is intended for a specific role and specific hardware. The finished system will run on a repurposed MacBook Air and provide a minimal Linux foundation for self-hosted services, networking experiments, automation, monitoring, and other home-lab workloads.

**Status:** Work in progress. The base LFS system is currently under construction.

## Goals

The main goals of erebOS are to:

- Build a complete Linux system from source using Linux From Scratch.
- Extend the base system with selected BLFS components required for a practical and adaptable headless server.
- Keep the final system relatively small and understandable.
- Avoid installing software simply because it is part of a conventional distribution.
- Configure the kernel and userspace around the target hardware and role.
- Develop a repeatable workflow for entering, leaving, maintaining, and rebuilding the LFS environment.
- Document the entire process as both a technical reference and a record of what was learned.
- Ultimately deploy the finished system on physical MacBook Air hardware as part of a home lab.

erebOS is not intended to become a general-purpose Linux distribution or compete with established projects such as Debian, Ubuntu, Arch, or Gentoo.

The point of the project is to understand and control the system beneath the services that will eventually run on it.

## Target System

erebOS is being built initially on a separate Linux workstation before being transferred to its intended hardware.

### Build host

The LFS environment is currently being constructed on an Ubuntu-based build machine.

Project scripts are provided to help prepare the host for an erebOS build session and restore the host to its normal configuration afterwards.

### Target hardware

The finished system is intended to run on a repurposed MacBook Air as a headless home-lab server.

The final hardware configuration and hardware-specific kernel requirements will be documented as deployment work progresses.

## Design Direction

The finished erebOS system is expected to prioritize:

**Minimalism**  
Only software required for the system's intended role should be installed.

**Understandability**  
Important parts of the operating system should remain understandable and traceable.

**Headless operation**  
The target system does not require a ‘conventional’ desktop environment.

**Remote administration**  
Routine management will be performed over the network.

**Reproducibility**  
Build procedures, configuration decisions, package versions, and system changes should be documented sufficiently to reconstruct or repair the system.

**Practicality over purity**  
erebOS is a learning and home-lab project, not an exercise in avoiding useful tools for ideological reasons. Components will be selected according to what makes technical sense for the finished system.

## Project Structure

```text
erebOS/
├── docs/
│   ├── phase-00-build-host.md
│   ├── chapter-06-temporary-tools.md
│   ├── chapter-07-chroot.md
│   ├── chapter-08-basic-system.md
│   ├── session-workflow.md
│   └── source-verification.md
│
├── host-checks/
│   └── ...
│
├── package-lists/
│   └── lfs-13.1/
│
├── scripts/
│   ├── start-erebos.sh
│   └── stop-erebos.sh
│
└── README.md
```

### `docs/`

Detailed build notes, procedures, explanations, and project documentation.

The README provides the overview; the documentation directory contains the actual build record.

### `host-checks/`

Captured host-system validation results used to verify that the build environment meets LFS requirements.

### `package-lists/`

Package information associated with the LFS version used by the project.

### `scripts/`

Small utilities used to prepare and restore the build environment.

These currently include session start/stop tooling for tasks such as mounting the erebOS filesystem, setting the LFS environment variable, and ensuring the host shell configuration is appropriate for LFS work.

## Build Workflow

The erebOS build follows the general structure of Linux From Scratch rather than replacing it with a fully automated installer.

At high level, the process consists of:

1. Preparing and validating the build host.
2. Preparing the target filesystem.
3. Downloading and verifying source packages.
4. Building the initial cross-toolchain.
5. Building temporary tools.
6. Entering the new system through chroot.
7. Building the final base system.
8. Configuring the system and Linux kernel.
9. Making the system independently bootable.
10. Adding selected BLFS packages.
11. Configuring networking and remote administration.
12. Deploying the completed system to the target MacBook Air.
13. Adding and documenting home-lab services.

Detailed commands and build notes are kept under [`docs/`](docs/).

## Documentation Philosophy

One of the goals of erebOS is to preserve the process rather than only presenting the finished result.

That means the documentation may include:

- failed builds
- incorrect assumptions
- troubleshooting steps
- configuration changes
- recovery procedures
- experiments that were later abandoned
- explanations of unfamiliar Linux concepts
- reasons behind design decisions

Over time, the project documentation is intended to become a maintenance and troubleshooting manual for the finished system.

## Current Progress

The project currently includes documentation and tooling covering the early LFS build environment and construction stages.

Current work includes:

- build-host preparation
- host requirement checks
- source verification
- temporary tool construction
- chroot preparation
- base-system construction
- repeatable erebOS session start/stop procedures

The repository will continue to evolve as the base LFS installation is completed and the project moves into BLFS, hardware configuration, networking, and home-lab deployment.

## Planned Work

Future stages are expected to include:

- completion of the base LFS system
- Linux kernel configuration for the target hardware
- bootloader configuration
- networking
- SSH-based remote administration
- selected BLFS server components
- system logging and monitoring
- storage configuration
- security hardening
- backup and recovery procedures
- deployment to the target MacBook Air
- home-lab service configuration
- architecture and boot-process diagrams
- final system documentation

The exact software stack will be decided as the system develops rather than being fixed in advance.

## References

erebOS is built using the Linux From Scratch and Beyond Linux From Scratch projects as its primary technical references.

- Linux From Scratch
- Beyond Linux From Scratch

The repository documents the erebOS implementation and project-specific decisions rather than replacing the official LFS/BLFS documentation.

## Project Scope

erebOS is a personal technical and educational project, intended as a tool for learning Linux and its systems at a deeper level than previous Linux personal experiences.
