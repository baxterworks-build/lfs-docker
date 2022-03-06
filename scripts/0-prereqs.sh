#!/usr/bin/env bash
source environment.sh

echo "Installing host (Debian) dependencies, stand by"
(apt update; apt -y install --no-install-recommends xz-utils gcc g++ bison make curl ca-certificates patch less texinfo) &> /dev/null

mkdir -pv /lfs/
mkdir -pv /lfs/patches
mkdir -pv /lfs/logs
mkdir -pv /lfs/sources
pushd /lfs/sources

set -x
for u in $BINUTILS_URL $MPFR_URL $GMP_URL $MPC_URL $GCC_URL; do
    $CURL -O $u
    t=$(basename $u)
    tar axf $t
    rm -v $t
done;

pushd gcc-$GCC_VERSION
mv -v ../mpfr-$MPFR_VERSION mpfr
mv -v ../gmp-$GMP_VERSION gmp
mv -v ../mpc-$MPC_VERSION mpc
popd

set +x