#!/usr/bin/env bash
source environment.sh

mkdir -pv /lfs/
#TODO: update patches from https://www.linuxfromscratch.org/lfs/downloads/development/LFS-BOOK-r11.1-154-NOCHUNKS.html#ch-materials-patches
mkdir -pv /lfs/patches
mkdir -pv /lfs/logs
mkdir -pv /lfs/sources

#https://askubuntu.com/questions/347555/how-do-i-list-all-installed-packages-with-specific-version-numbers
#https://askubuntu.com/questions/538261/how-to-tweak-dpkg-l-output
#https://unix.stackexchange.com/questions/20536/reformatting-output-with-aligned-columns
#tl;dr don't use dpkg --get-selections, use dpkg-query
dpkg-query -W -f='${binary:Package}\t${Version}\n' | column -t > $LOGS/debian-packages.log
cat /etc/apt/sources.list >> $LOGS/debian-builder-apt-sources.log 
#cat /etc/apt/sources.list.d/* >> $LOGS/debian-builder-apt-sources.log || true 

cd /lfs/sources


#Do the kernel headers step out of order, so we're not copying an entire kernel source tree
#across multiple containers
#TODO: use the $LFS variable consistently, use absolute paths everywhere
#cd /lfs/sources/ && $CURL $KERNEL_URL | tar -Jxf -
#cd linux-*
#( make headers && find usr/include -name '.*' -delete && rm usr/include/Makefile && cp -rv usr/include $LFS/usr ) &> $LOGS/kernel-headers.log
#rm -rf sources/linux-*

#cd /lfs/sources
#$CURL $GLIBC_URL | tar -Jxf -
