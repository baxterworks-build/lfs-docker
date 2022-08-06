#!/bin/bash
source environment.sh
cd $LFS/sources

tar axf ncurses*.gz && rm -v ncurses-*.gz
cd ncurses-*

sed -i s/mawk// configure

mkdir build
cd build
  ../configure 2>&1 | tee $LOGS/ncurses.host.configure.log
  make -C include 2>&1 | tee $LOGS/ncurses.host.include.log
  make -C progs tic 2>&1 | tee $LOGS/ncurses.host.progs.log

cd ..

./configure --prefix=/usr                \
            --host=$LFS_TGT              \
            --build=$(./config.guess)    \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --with-shared                \
            --without-normal             \
            --with-cxx-shared            \
            --without-debug              \
            --without-ada                \
            --disable-stripping          \
            --enable-widec 2>&1 | tee $LOGS/ncurses.configure.log

make -j$JOBS &> $LOGS/ncurses.make.log

make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install &> $LOGS/ncurses.tic.log

echo "INPUT(-lncursesw)" > $LFS/usr/lib/libncurses.so

find /lfs > $LOGS/ncurses.contents.log