#!/usr/bin/env bash
set -eou pipefail
set +h

export CURL="curl -L --show-error --fail "
#export CURL="curl -L --silent --show-error --fail "
export JOBS=${JOBS:-$(nproc)}
export LFS=${LFS:-/lfs}
export LFS_TGT=$(uname -m)-lfs-linux-gnu
export LFS_PATCHES=$LFS/patches/
export PATH=$LFS/tools/bin:/bin:/usr/bin
export LOGS=${LOGS:-$LFS/logs}
export BINUTILS_VERSION=2.38
export GCC_VERSION=11.2.0
export MPFR_VERSION=4.1.0
export GMP_VERSION=6.2.1
export MPC_VERSION=1.2.1
export GLIBC_VERSION=2.35
export KERNEL_VERSION=5.16.12

export GNU_MIRROR=${GNU_MIRROR:-"https://mirror.aarnet.edu.au/pub/gnu/"}
export KERNEL_MIRROR=https://mirror.aarnet.edu.au/pub/ftp.kernel.org/
#export KERNEL_MIRROR=http://cdn.kernel.org/