# LFS in a docker container

Based on https://www.linuxfromscratch.org/lfs/downloads/development/LFS-BOOK-r11.1-154-NOCHUNKS.html, which is `32feb4ba2` in git://git.linuxfromscratch.org/lfs

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

ncurses: `../c++/etip.h:347:15: fatal error: iostream.h: No such file or directory` and `/lfs/tools/lib/gcc/x86_64-lfs-linux-gnu/11.2.0/../../../../x86_64-lfs-linux-gnu/bin/ld: cannot find -lstdc++: No such file or directory`

Argh: https://www.mail-archive.com/lfs-support@lists.linuxfromscratch.org/msg06889.html

iostream.h not being found is a furphy, this means libstdc++ wasn't installed properly -     --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/11.2.0 when it should have been using the GCC version variable.
Useful fragment found while searching for this:
https://serverfault.com/questions/225798/can-i-make-find-return-non-0-when-no-matching-files-are-found

`find / -name iostream.h | grep .`

Although iostream.h was never going to be found!


## Came back 5 months later, how do I know what changed between the version of the book I was using?

* You shouldn't be using the `development` version.

* OK, you're using the development version, the -number is from `git describe`. git describe works by finding the last tag, then counting the number of commits from that tag.

* 2022-03-18 I was using https://www.linuxfromscratch.org/lfs/downloads/development/LFS-BOOK-r11.1-20-NOCHUNKS.html despite there being a perfectly good stable version on the 1st of March.

* 2022-08-06, `git describe` on git://git.linuxfromscratch.org/lfs says `r11.1-154-g32feb4ba2` but 

```
voltagex@debian:~/src/book-lfs$ git describe HEAD~105
r11.1-23-g940c8495a
voltagex@debian:~/src/book-lfs$ git describe HEAD~106
r11.1-22-g102a7f64c
voltagex@debian:~/src/book-lfs$ git describe HEAD~107
r11.1-15-gc9629e034
```

makes no sense, so this was a nice idea but let's just bump the versions in `environment.sh` and not learn any lessons about using development builds of books (back in my day, these were called 'drafts').


# todo
* Dockerfile.bash:1: this is generic enough, can the copy and run commands be templated using an environment variable?

* Dockerfile.package-cache:8: check if `file` was actually specified in the LFS book

* Dockerfile.package-cache:9: package-cache probably doesn't need to be separate from debian-builder

* Makefile:14: is there a better way to grab logs when a Dockerfile fails to build?

* Makefile:60: exclude package-cache from clean?

* Makefile:72: accept an argument to save a single image instead of all of them

* Makefile:76: look up how make rule parameters work, create a generic target that passes a $TARGET to the Dockerfile so that m4, ncurses and bash can be rolled into it

* scripts/0-prereqs.sh:25: use the $LFS variable consistently, use absolute paths everywhere

* scripts/0-prereqs.sh:5: update patches from https://www.linuxfromscratch.org/lfs/downloads/development/LFS-BOOK-r11.1-154-NOCHUNKS.html#ch-materials-patches

* scripts/5.2-binutils.sh:20: can cleanup / checksum / contents be generalised into a post-install script that's shared between all targets?

* scripts/5.3-gcc.sh:19: another place that will need care for aarch64

* scripts/5.3-gcc.sh:5: move the sources to a different container? gcc is running me out of drive space after ~5 builds

* scripts/5.3-gcc.sh:61: remove hardcoded arch here

* scripts/5.5-glibc.sh:14: this copies to $LFS/usr, no trailing slash in the instructions, is that right? Why do I need to do this differently

* scripts/5.5-glibc.sh:24: I assume uname -m returns aarch64 and breaks this switch on aarch64

* scripts/5.5-glibc.sh:51: shasum any binaries?

* scripts/5.6-libstdcpp.sh:23: shasum any binaries?

* scripts/6.4.1-bash.sh:16: what have I missed that means $LFS/bin doesn't exist?

* scripts/environment.sh:13: How does Automated Linux From Scratch do this?

* scripts/environment.sh:27: https://stackoverflow.com/questions/2520085/how-do-i-conditionally-redirect-the-output-of-a-command-to-dev-null

