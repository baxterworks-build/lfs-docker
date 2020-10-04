#!/bin/bash
set -eou pipefail
set +h


export LFS=/lfs
export LFS_TGT=$(uname -m)-lfs-linux-gnu
export PATH=$LFS/tools/bin:/bin:/usr/bin
#export GNU=https://ftpmirror.gnu.org/gnu
export GNU=http://gnu.mirror.constant.com

apt update; apt -y install --no-install-recommends xz-utils gcc g++ bison make curl ca-certificates

mkdir /lfs
mkdir $LFS/sources
pushd $LFS/sources

curl -L $GNU/binutils/binutils-2.35.tar.xz | tar -Jxf -
mkdir binutils-2.35/build
pushd binutils-2.35/build

../configure --prefix=$LFS/tools       \
             --with-sysroot=$LFS        \
             --target=$LFS_TGT          \
             --disable-nls              \
             --disable-werror &> configure-binutils-output.log
make -j24 &> make-binutils-output.log
make install > /dev/null
popd

curl -sL $GNU/gcc/gcc-10.2.0/gcc-10.2.0.tar.xz | tar -Jxf -
pushd gcc-10.2.0

curl -sL $GNU/mpfr/mpfr-4.1.0.tar.xz | tar -Jxf -
curl -sL $GNU/gmp/gmp-6.2.0.tar.xz | tar -Jxf -
curl -sL $GNU/mpc/mpc-1.2.0.tar.gz | tar -zxf -

mv -v mpfr-4.1.0 mpfr
mv -v gmp-6.2.0 gmp
mv -v mpc-1.2.0 mpc

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

make -j24 &> gcc-build-output.log


