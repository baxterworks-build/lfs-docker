#!/usr/bin/env bash
source environment.sh

mkdir -pv /lfs/
mkdir -pv /lfs/patches
mkdir -pv /lfs/logs
mkdir -pv /lfs/sources

#https://askubuntu.com/questions/347555/how-do-i-list-all-installed-packages-with-specific-version-numbers
#https://askubuntu.com/questions/538261/how-to-tweak-dpkg-l-output
#https://unix.stackexchange.com/questions/20536/reformatting-output-with-aligned-columns
#tl;dr don't use dpkg --get-selections, use dpkg-query
dpkg-query -W -f='${binary:Package}\t${Version}\n' | column -t > $LOGS/debian-packages.log
cat /etc/apt/sources.list >> $LOGS/debian-builder-apt-sources.log 
cat /etc/apt/sources.list.d/* >> $LOGS/debian-builder-apt-sources.log || true 

cd /lfs/sources

for u in $BINUTILS_URL $MPFR_URL $GMP_URL $MPC_URL $GCC_URL; do
    $CURL -O $u
    t=$(basename $u)
    tar axf $t
    rm -v $t
done;
#TODO: move the sources to a different container? gcc is running me out of drive space after ~5 builds
cd /lfs/sources/gcc-$GCC_VERSION
mv -v ../mpfr-$MPFR_VERSION mpfr
mv -v ../gmp-$GMP_VERSION gmp
mv -v ../mpc-$MPC_VERSION mpc

#Do the kernel headers step out of order, so we're not copying an entire kernel source tree
#across multiple containers
#TODO: use the $LFS variable consistently, use absolute paths everywhere
cd /lfs/sources/ && $CURL $KERNEL_URL | tar -Jxf -
cd linux-*
( make headers && find usr/include -name '.*' -delete && rm usr/include/Makefile && cp -rv usr/include $LFS/usr ) &> $LOGS/kernel-headers.log
rm -rf sources/linux-*

cd /lfs/sources
$CURL $GLIBC_URL | tar -Jxf -
