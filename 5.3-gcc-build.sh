#!/bin/bash
#https://www.linuxfromscratch.org/lfs/view/development/chapter05/gcc-pass1.html
source environment.sh
mkdir -p $LFS
mkdir -p $LFS/sources
mkdir -p $LOGS
pushd $LFS/sources

echo "binutils: $BINUTILS_URL"
$CURL $BINUTILS_URL | tar -Jxf -
mkdir binutils-$BINUTILS_VERSION/build
pushd binutils-$BINUTILS_VERSION
ls -la $LFS_PATCHES/binutils*
patch -p1 < $LFS_PATCHES/binutils*
popd

pushd binutils-$BINUTILS_VERSION/build
echo "1 SBU is?"
time { ../configure --prefix=$LFS/tools       \
             --with-sysroot=$LFS        \
             --target=$LFS_TGT          \
             --disable-nls              \
             --disable-werror &> $LOGS/binutils.configure.log && make -j$JOBS &> $LOGS/binutils.make.log && make install > /dev/null; }
popd

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
    --enable-languages=c,c++ &> $LOGS/gcc.configure.log

make -j$JOBS &> $LOGS/gcc.make.log || true
make install &> $LOGS/gcc.install.log || true
pushd ..
set -x
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/install-tools/include/limits.h
set +x
popd

