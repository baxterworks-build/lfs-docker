#!/bin/bash
source environment.sh
cd /lfs/sources/
tar axf gcc-$GCC_VERSION.tar.xz
rm *.xz

cd $LFS/sources/gcc-$GCC_VERSION && mkdir build
cd build

../libstdc++-v3/configure           \
    --host=$LFS_TGT                 \
    --build=$(../config.guess)      \
    --prefix=/usr                   \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/$GCC_VERSION &> $LOGS/libstdcpp.configure.log

make -j$JOBS &> $LOGS/libstdcpp.make.log
make DESTDIR=$LFS install &> $LOGS/libstdcpp.install.log
rm -rf /lfs/sources/*
#TODO: shasum any binaries?
find /lfs > $LOGS/libstdcpp.contents.log
