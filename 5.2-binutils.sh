#!/bin/bash
source environment.sh

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