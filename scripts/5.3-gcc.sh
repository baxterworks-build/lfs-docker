#!/bin/bash
#https://www.linuxfromscratch.org/lfs/view/development/chapter05/gcc-pass1.html
source environment.sh

#TODO: move the sources to a different container? gcc is running me out of drive space after ~5 builds
cd /lfs/sources/
tar axf gcc-*
tar axf mpc-*
tar axf mpfr-*
tar axf gmp-*
rm *.xz *.gz

cd /lfs/sources/gcc-*
mv -v ../mpfr-* mpfr
mv -v ../gmp-* gmp
mv -v ../mpc-* mpc

cd $LFS/sources/gcc* && mkdir build
#TODO: another place that will need care for aarch64
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac

cd build

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



time make -j$JOBS &> $LOGS/gcc.make.log
make install &> $LOGS/gcc.install.log

#Create header specified at the bottom of this section of LFS
cd $LFS/sources/gcc*
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
`dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/install-tools/include/limits.h

rm -rf /lfs/sources/*
#TODO: remove hardcoded arch here
sha256sum /lfs/tools/bin/x86_64-lfs-linux-gnu-{gcc*,g++*,c++*} > $LOGS/gcc.sha256sum
find /lfs > $LOGS/gcc.contents.log
