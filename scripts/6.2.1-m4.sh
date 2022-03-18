#!/bin/bash
source environment.sh
cd $LFS/sources

tar axf m4-*xz && rm -v m4-*.xz
cd m4*
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess) &> $LOGS/m4.configure.log
make DESTDIR=$LFS install &> $LOGS/m4.make.log

rm -rf /lfs/sources/*
find /lfs > $LOGS/m4.contents.log