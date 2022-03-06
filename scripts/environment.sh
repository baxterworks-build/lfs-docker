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
export BINUTILS_URL=$GNU_MIRROR/binutils/binutils-$BINUTILS_VERSION.tar.xz
export MPFR_URL=$GNU_MIRROR/mpfr/mpfr-$MPFR_VERSION.tar.xz
export GMP_URL=$GNU_MIRROR/gmp/gmp-$GMP_VERSION.tar.xz
export MPC_URL=$GNU_MIRROR/mpc/mpc-$MPC_VERSION.tar.gz
export GCC_URL=$GNU_MIRROR/gcc/gcc-${GCC_VERSION}/gcc-$GCC_VERSION.tar.xz
export GLIBC_URL=$GNU_MIRROR/glibc/glibc-$GLIBC_VERSION.tar.xz
export KERNEL_URL=$KERNEL_MIRROR/linux/kernel/v5.x/linux-$KERNEL_VERSION.tar.xz