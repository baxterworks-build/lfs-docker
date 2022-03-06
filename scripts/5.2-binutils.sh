#!/bin/bash
source environment.sh
pushd $LFS/sources
mkdir binutils-$BINUTILS_VERSION/build
pushd binutils-$BINUTILS_VERSION
ls -la $LFS_PATCHES/binutils*
patch -p1 < $LFS_PATCHES/binutils*
popd

pushd binutils-$BINUTILS_VERSION/build
echo "1 SBU is?"

time { 
  ../configure --prefix=$LFS/tools       \
             --with-sysroot=$LFS        \
             --target=$LFS_TGT          \
             --disable-nls              \
             --disable-werror &> $LOGS/binutils.configure.log && ( make -j$(nproc) && make install ) &> $LOGS/binutils.make.log ; } || true
popd
popd