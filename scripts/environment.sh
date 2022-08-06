#!/usr/bin/env bash
set -eou pipefail
set +h
export JOBS=${JOBS:-$(nproc)}
export LFS=${LFS:-/lfs}
export PATH=$LFS/tools/bin:/bin:/usr/bin
export LFS_PATCHES=$LFS/patches/
export LFS_TGT=$(uname -m)-lfs-linux-gnu
export CURL="curl -L --show-error --fail "
export LOGS=${LOGS:-$LFS/logs}


#todo: How does Automated Linux From Scratch do this?
#export ACL_VERSION=2.3.1
#export ATTR_VERSION=2.5.1
export BINUTILS_VERSION=2.38
export GCC_VERSION=12.1.0
export GLIBC_VERSION=2.35
export GMP_VERSION=6.2.1
export KERNEL_VERSION=5.18.14
export MPC_VERSION=1.2.1
export MPFR_VERSION=4.1.0


export GNU_MIRROR=${GNU_MIRROR:-"https://mirror.aarnet.edu.au/pub/gnu/"}
export KERNEL_MIRROR=https://mirror.aarnet.edu.au/pub/ftp.kernel.org/
#export KERNEL_MIRROR=http://cdn.kernel.org/