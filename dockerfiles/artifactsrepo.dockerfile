ARG NEXUS_IMG=sonatype/nexus3:latest
# dumper build to prepare files
FROM $NEXUS_IMG as dumper

COPY --chown=nexus:nexus ../setup/nexus /setup
USER nexus
RUN mkdir /nexus-data/etc \
    && cp /setup/nexus.properties /nexus-data/etc

# final build
FROM $NEXUS_IMG

COPY --from=dumper --chmod=nexus:nexus /nexus-data/etc /nexus-data/etc
