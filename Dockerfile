FROM debian:sid AS debian-builder
ARG GNU=https://ftpmirror.gnu.org/
ENV GNU=$GNU
RUN mkdir /lfs
WORKDIR /lfs
COPY environment.sh /lfs/
COPY 0-prereqs.sh /lfs/
RUN ./0-prereqs.sh

FROM debian-builder AS s5.3-gcc-pass-1 
RUN mkdir -p /lfs
WORKDIR /lfs
COPY *.sh /lfs/
COPY patches /lfs/patches
RUN ./5.3-gcc-build.sh

FROM s5.3-gcc-pass-1 AS 5.5-glibc

