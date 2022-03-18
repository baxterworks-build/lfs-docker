#!/bin/bash
source environment.sh
cd $LFS/sources

tar axf bash*.gz && rm -v bash-*.gz
cd bash-*

./configure --prefix=/usr                   \
            --build=$(support/config.guess) \
            --host=$LFS_TGT                 \
            --without-bash-malloc &> $LOGS/bash.configure.log

make -j$JOBS &> $LOGS/bash.make.log
make DESTDIR=$LFS install &> $LOGS/bash.install.log

#TODO: what have I missed that means $LFS/bin doesn't exist?
mkdir -p $LFS/bin
ln -sv bash $LFS/bin/sh

sha256sum $LFS/usr/bin/bash &> $LOGS/bash.sha256sum
rm -rf /lfs/sources
find /lfs > $LOGS/bash.contents.log