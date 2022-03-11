#!/bin/bash
#https://www.linuxfromscratch.org/lfs/view/development/chapter05/gcc-pass1.html
source environment.sh
cd /lfs/sources/
tar axf gcc-*
rm *.xz

cd /lfs/sources/gcc-*
cd $LFS/sources/gcc* && mkdir build
cd build

../libstdc++-v3/configure           \
    --host=$LFS_TGT                 \
    --build=$(../config.guess)      \
    --prefix=/usr                   \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/11.2.0 
    #&> $LOGS/libstdcpp.configure.log
make -j$(nproc) #&> $LOGS/libstdcpp.make.log

#TODO: /lfs/sources/gcc-11.2.0/build/include/fenv.h:58:11: error: 'fenv_t' has not been declared in '::'
exit 1
make DESTDIR=$LFS install &> $LOGS/libstdcpp.install.log

cd /
rm -rf /lfs/sources/*

