#!/bin/bash
set -eou pipefail
set +h


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


apt update; apt -y install --no-install-recommends xz-utils gcc g++ bison make curl ca-certificates

mkdir /lfs
mkdir $LFS/sources
pushd $LFS/sources

curl -L $GNU/binutils/binutils-$BINUTILS_VERSION.tar.xz | tar -Jxf -
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

curl -sL $GNU/gcc/gcc-${GCC_VERSION}/gcc-$GCC_VERSION.tar.xz | tar -Jxf -
pushd gcc-$GCC_VERSION

curl -sL $GNU/mpfr/mpfr-$MPFR_VERSION.tar.xz | tar -Jxf -
curl -sL $GNU/gmp/gmp-$GMP_VERSION.tar.xz | tar -Jxf -
curl -sL $GNU/mpc/mpc-$MPC_VERSION.tar.gz | tar -zxf -

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


