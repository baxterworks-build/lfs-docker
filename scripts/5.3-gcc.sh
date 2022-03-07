#!/bin/bash
#https://www.linuxfromscratch.org/lfs/view/development/chapter05/gcc-pass1.html
source environment.sh
cd $LFS/sources/gcc* && mkdir build && cd build

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



make -j$JOBS &> $LOGS/gcc.make.log
make install &> $LOGS/gcc.install.log

#Create header specified at the bottom of this section of LFS
cd $LFS/sources/gcc*
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
`dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/install-tools/include/limits.h || true



