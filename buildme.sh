#!/usr/bin/bash -x
docker build --build-arg GNU=https://mirror.aarnet.edu.au/pub/gnu/ -t voltagex/lfs-gcc-1 .
#--volume $PWD/output:/lfs 
