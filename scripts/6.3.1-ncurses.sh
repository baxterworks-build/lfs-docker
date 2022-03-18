#!/bin/bash
source environment.sh
cd $LFS/sources

tar axf ncurses*.gz && rm -v ncurses-*.gz
cd ncurses-*

sed -i s/mawk// configure

mkdir build
cd build
  ../configure &> $LOGS/ncurses.host.configure.log
  make -C include &> $LOGS/ncurses.host.include.log
  make -C progs tic &> $LOGS/ncurses.host.progs.log

cd ..

./configure --prefix=/usr                \
            --host=$LFS_TGT              \
            --build=$(./config.guess)    \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --with-shared                \
            --without-debug              \
            --without-ada                \
            --without-normal             \
            --disable-stripping          \
            --enable-widec &> $LOGS/ncurses.configure.log

make -j$JOBS &> $LOGS/ncurses.make.log

make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install &> $LOGS/ncurses.tic.log

echo "INPUT(-lncursesw)" > $LFS/usr/lib/libncurses.so

find /lfs > $LOGS/ncurses.contents.log