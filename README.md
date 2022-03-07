# LFS in a docker container

Based on https://www.linuxfromscratch.org/lfs/downloads/development/LFS-BOOK-r11.1-20-NOCHUNKS.html

# Modifications
* Downloading and extracting as much of the sources as possible up-front, so I'm not having to do repetitive curl | tar steps in every container
* Step 5.4.1, kernel headers are done as part of my prerequisites script so I'm not copying an entire Linux source tree every time I take the /lfs path between containers


# Troubleshooting log
gcc/libgcc: configure: error: cannot compute suffix of object files: cannot compile
If gcc can't find binutils, things get very wonky!
*Assuming* this was a missing `/lfs/tools/bin/as` binary or similar

# todo
* scripts/0-prereqs.sh:29: use the $LFS variable consistently, use absolute paths everywhere

* scripts/5.5-glibc.sh:6: I assume uname -m returns aarch64 and breaks this switch on aarch64

* .buildkite/pipeline.yml:13: put logs in different paths & change artifact_paths so there's no duplicate logs

