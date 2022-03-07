# LFS in a docker container

Based on https://www.linuxfromscratch.org/lfs/downloads/development/LFS-BOOK-r11.1-20-NOCHUNKS.html

# Modifications
* Downloading and extracting as much of the sources as possible up-front, so I'm not having to do repetitive curl | tar steps in every container
* Step 5.4.1, kernel headers are done as part of my prerequisites script so I'm not copying an entire Linux source tree every time I take the /lfs path between containers


# Troubleshooting log
gcc/libgcc: configure: error: cannot compute suffix of object files: cannot compile
If gcc can't find binutils, things get very wonky!
*Assuming* this was a missing `/lfs/tools/bin/as` binary or similar

buildkite:  Error: Failed to remove "/var/lib/buildkite-agent/builds/debian-1/baxterworks/lfs-in-docker" (unlinkat /var/lib/buildkite-agent/builds/debian-1/baxterworks/lfs-in-docker/output/logs/binutils.configure.log: permission denied)
"Fixed" by using userns remapping and mapping the buildkite agent (uid/gid 998) to the same ID inside the container

docker on btrfs: failing on copy step, "solved" by changing VM back to ext4 with overlay driver... revisit this as it's a bad solution. Perhaps something changed in kernel 5.17? https://github.com/moby/moby/issues/37965