#!/usr/bin/env bash
set -eou pipefail
set +h
#set -x

export CURL="curl -L --silent --show-error --fail "
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
export LINUX_VERSION=5.14.15

export GNU_MIRROR=${GNU_MIRROR:-"http://gnu.mirror.constant.com"}
export KERNEL_MIRROR=http://cdn.kernel.org/
export BINUTILS_URL=$GNU_MIRROR/binutils/binutils-$BINUTILS_VERSION.tar.xz
export MPFR_URL=$GNU_MIRROR/mpfr/mpfr-$MPFR_VERSION.tar.xz
export GMP_URL=$GNU_MIRROR/gmp/gmp-$GMP_VERSION.tar.xz
export MPC_URL=$GNU_MIRROR/mpc/mpc-$MPC_VERSION.tar.gz
export GCC_URL=$GNU_MIRROR/gcc/gcc-${GCC_VERSION}/gcc-$GCC_VERSION.tar.xz