#!/bin/bash
#https://www.linuxfromscratch.org/lfs/downloads/development/LFS-BOOK-r11.1-20-NOCHUNKS.html#ch-tools-glibc
source environment.sh
cd /lfs/sources
mkdir -p /lfs/patches
mv *.patch /lfs/patches #stops tar & cd getting confused when globbing
tar axf glibc*.tar.xz && rm -v glibc*.tar.xz
cd /lfs/sources/glibc-*

#TODO: I assume uname -m returns aarch64 and breaks this switch on aarch64
case $(uname -m) in
    i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
    ;;
    x86_64) mkdir $LFS/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
    ;;
esac

patch -Np1 -i $LFS/patches/glibc-2.35-fhs-1.patch
mkdir -v build && cd build

echo "rootsbindir=/usr/sbin" > configparms
../configure                             \
      --prefix=/usr                      \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=3.2                \
      --with-headers=$LFS/usr/include    \
      libc_cv_slibdir=/usr/lib &> glibc.configure.log && make -j$JOBS &> glibc.make.log && make DESTDIR=$LFS install

sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd
$LFS/tools/libexec/gcc/$LFS_TGT/11.2.0/install-tools/mkheaders