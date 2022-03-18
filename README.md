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

docker import/export is not docker load/save: https://pspdfkit.com/blog/2019/docker-import-export-vs-load-save/

libstdcpp: `/lfs/sources/gcc-11.2.0/build/include/fenv.h:58:11: error: 'fenv_t' has not been declared in '::'` - this was fixed by copying /lfs/tools from the gcc image, but then this caused `../libstdc++-v3/configure: line 7738: /usr/bin/file: No such file or directory`. Added file to debian-builder/package-cache

libstdcpp: `configure: error: Link tests are not allowed after GCC_NO_EXECUTABLES.` - https://stackoverflow.com/questions/46487529/crosscompiling-gcc-link-tests-are-not-allowed-after-gcc-no-executables-when-che suggests glibc was missing

ncurses: `/lfs/tools/lib/gcc/x86_64-lfs-linux-gnu/11.2.0/../../../../x86_64-lfs-linux-gnu/bin/ld: cannot find crt1.o: No such file or directory` - needed to bring the glibc /lfs/usr tree across

ncurses: missing iostream and `/lfs/tools/lib/gcc/x86_64-lfs-linux-gnu/11.2.0/../../../../x86_64-lfs-linux-gnu/bin/ld: cannot find -lstdc++: No such file or directory` - need libstdc++ /lfs tree

# todo
* .buildkite/pipeline.yml:20: put logs in different paths & change artifact_paths so there's no duplicate logs

* Dockerfile.bash:1: this is generic enough, can the copy and run commands be templated using an environment variable?

* Makefile:58: exclude package-cache from clean?

* Makefile:62: clear the todo section before creating it again

* Makefile:72: accept an argument to save a single image instead of all of them

* Makefile:76: look up how make rule parameters work, create a generic target that passes a $TARGET to the Dockerfile so that m4, ncurses and bash can be rolled into it

* scripts/0-prereqs.sh:22: use the $LFS variable consistently, use absolute paths everywhere

* scripts/5.3-gcc.sh:19: another place that will need care for aarch64

* scripts/5.3-gcc.sh:5: move the sources to a different container? gcc is running me out of drive space after ~5 builds

* scripts/5.3-gcc.sh:60: remove hardcoded arch here

* scripts/5.5-glibc.sh:10: I assume uname -m returns aarch64 and breaks this switch on aarch64

* scripts/5.6-libstdcpp.sh:23: /lfs/sources/gcc-11.2.0/build/include/fenv.h:58:11: error: 'fenv_t' has not been declared in '::'

* scripts/6.4.1-bash.sh:16: what have I missed that means $LFS/bin doesn't exist?

