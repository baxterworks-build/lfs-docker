#!/bin/bash
#https://www.linuxfromscratch.org/lfs/view/development/chapter05/gcc-pass1.html
#https://www.linuxfromscratch.org/lfs/view/development/chapter05/linux-headers.html
#https://www.linuxfromscratch.org/lfs/view/development/chapter05/glibc.html

source environment.sh
pushd $LFS/sources

$CURL $KERNEL_URL | tar -Jxf -
#pushd linux-$LINUX_VERSION
