#!/usr/bin/env bash
source environment.sh

echo "Installing host (Debian) dependencies, stand by"
(apt update; apt -y install --no-install-recommends xz-utils gcc g++ bison make curl ca-certificates patch less) &> /dev/null

echo "Host is ready, hold on to your butts"
echo
