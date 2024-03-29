ARG PROJECT
ARG PROJECT_ARCH

FROM $PROJECT-$PROJECT_ARCH-sources AS sources
FROM $PROJECT-$PROJECT_ARCH-debian-builder

COPY --from=sources /lfs/sources/m4-* /lfs/sources/

WORKDIR /lfs
COPY scripts/environment.sh /lfs/
COPY scripts/6.2.1-m4.sh /lfs/
RUN ./6.2.1-m4.sh