#!/usr/bin/env bash
set -eou pipefail
set +h

: "$PROJECT_ARCH"

export JOBS=${JOBS:-$(nproc)}
export LFS=${LFS:-/lfs}
export PATH=$LFS/tools/bin:/bin:/usr/bin
export LFS_PATCHES=$LFS/patches/
export LFS_TGT=$(uname -m)-lfs-linux-gnu
export CURL="curl -L --show-error --fail "
export LOGS=${LOGS:-$LFS/logs}


#TODO: How does Automated Linux From Scratch do this?
export BINUTILS_VERSION=2.39
export GCC_VERSION=12.1.0
export GLIBC_VERSION=2.36
export GMP_VERSION=6.2.1
export KERNEL_VERSION=5.18.14
export MPC_VERSION=1.2.1
export MPFR_VERSION=4.1.0


export GNU_MIRROR=${GNU_MIRROR:-"https://mirror.aarnet.edu.au/pub/gnu/"}
export KERNEL_MIRROR=https://mirror.aarnet.edu.au/pub/ftp.kernel.org/
#export KERNEL_MIRROR=http://cdn.kernel.org/

#TODO: https://stackoverflow.com/questions/2520085/how-do-i-conditionally-redirect-the-output-of-a-command-to-dev-null
