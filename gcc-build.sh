#!/bin/sh
mkdir /lfs
export LFS=/lfs
export LFS_TGT=$(uname -m)-lfs-linux-gnu
export GNU=https://ftpmirror.gnu.org/gnu

mkdir $LFS/sources
pushd $LFS/sources

curl -L $GNU/mpfr/mpfr-4.1.0.tar.xz | tar -xf -
curl -L $GNU/gmp/gmp-6.2.0.tar.xz | tar -xf - 
curl -L $GNU/mpc/mpc-1.1.0.tar.xz | tar -xf -
curl -L $GNU/gcc/gcc-10.2.0/gcc-10.2.0.tar.xz | tar -xf -

pushd gcc*

mv -v mpfr-4.1.0 mpfr
tar -xf ../gmp-6.2.0.tar.xz
mv -v gmp-6.2.0 gmp
tar -xf ../mpc-1.1.0.tar.gz
mv -v mpc-1.1.0 mpc

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
    --enable-languages=c,c++

make -j24