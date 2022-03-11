#!/bin/bash
mkdir -p exported/
for i in $(docker images --filter reference=lfs-$(uname -m)* --format={{.Repository}}); do
	echo exported/$i.tar.zst
	docker export $i | zstd -c -T0 - > exported/$i.tar.zst
done;
