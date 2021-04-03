#!/bin/bash
set -eou pipefail
set +h

export CURL="curl -L --silent --show-error --fail "
export LFS=/lfs
export LFS_TGT=$(uname -m)-lfs-linux-gnu
export PATH=$LFS/tools/bin:/bin:/usr/bin
#export GNU=https://ftpmirror.gnu.org/gnu
export GNU=http://gnu.mirror.constant.com

export BINUTILS_VERSION=2.36.1
export GCC_VERSION=10.2.1
export MPFR_VERSION=4.1.0
export GMP_VERSION=6.2.1
export MPC_VERSION=1.2.1

export BINUTILS_URL=$GNU/binutils/binutils-$BINUTILS_VERSION.tar.xz
export MPFR_URL=$GNU/mpfr/mpfr-$MPFR_VERSION.tar.xz
export GMP_URL=$GNU/gmp/gmp-$GMP_VERSION.tar.xz
export MPC_URL=$GNU/mpc/mpc-$MPC_VERSION.tar.gz
export GCC_URL=$GNU/gcc/gcc-${GCC_VERSION}/gcc-$GCC_VERSION.tar.xz

echo "Installing host (Debian) dependencies, stand by"
(apt update; apt -y install --no-install-recommends xz-utils gcc g++ bison make curl ca-certificates) &> /dev/null

echo "Host is ready, hold on to your butts"
echo

mkdir /lfs
mkdir $LFS/sources
pushd $LFS/sources

echo "binutils: $BINUTILS_URL"
$CURL $BINUTILS_URL | tar -Jxf -
mkdir binutils-$BINUTILS_VERSION/build
pushd binutils-$BINUTILS_VERSION/build

../configure --prefix=$LFS/tools       \
             --with-sysroot=$LFS        \
             --target=$LFS_TGT          \
             --disable-nls              \
             --disable-werror &> configure-binutils-output.log
make -j24 &> make-binutils-output.log
make install > /dev/null
popd

echo "gcc: $GCC_URL"
$CURL $GCC_URL | tar -Jxf -
pushd gcc-$GCC_VERSION

$CURL $MPFR_URL | tar -Jxf -
$CURL $GMP_URL | tar -Jxf -
$CURL $MPC_URL | tar -zxf -

mv -v mpfr-$MPFR_VERSION mpfr
mv -v gmp-$GMP_VERSION gmp
mv -v mpc-$MPC_VERSION mpc

mkdir build
pushd build

../configure                                       \
    --target=$LFS_TGT                              \
    --prefix=$LFS/tools                            \
    --with-glibc-version=2.11                      \
    --with-sysroot=$LFS                            \
    --with-newlib                                  \
    --without-headers                              \
    --enable-initfini-array                        \
    --disable-nls                                  \
    --disable-shared                               \
    --disable-multilib                             \
    --disable-decimal-float                        \
    --disable-threads                              \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-libstdcxx                            \
    --enable-languages=c,c++ &> configure-gcc-output.log

make -j &> gcc-build-output.log


