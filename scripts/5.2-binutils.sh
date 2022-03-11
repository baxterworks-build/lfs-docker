#!/bin/bash
source environment.sh
#TODO: remove pushd/popd
cd $LFS/sources

tar axf binutils-*xz && rm -v binutils*.tar.*
mkdir -p binutils-$BINUTILS_VERSION/build
cd binutils-$BINUTILS_VERSION
ls -la $LFS_PATCHES/binutils*
patch -p1 < $LFS_PATCHES/binutils*
cd build
echo "1 SBU is?"

time { 
  ../configure --prefix=$LFS/tools       \
             --with-sysroot=$LFS        \
             --target=$LFS_TGT          \
             --disable-nls              \
             --disable-werror &> $LOGS/binutils.configure.log && ( make -j$JOBS && make install ) &> $LOGS/binutils.make.log ; } || true

sha256sum /lfs/tools/bin/* > $LOGS/binutils.sha256sum