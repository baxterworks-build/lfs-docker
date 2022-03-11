#TODO: this is generic enough, can the copy and run commands be templated using an environment variable?
ARG PROJECT
ARG PROJECT_ARCH

FROM $PROJECT-$PROJECT_ARCH-sources AS sources
FROM $PROJECT-$PROJECT_ARCH-debian-builder

COPY --from=sources /lfs/sources/bash-* /lfs/sources/

WORKDIR /lfs
COPY scripts/environment.sh /lfs/
COPY scripts/6.4.1-bash.sh /lfs/
RUN ./6.4.1-bash.sh