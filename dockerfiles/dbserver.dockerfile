# dumper build to prepare database
FROM postgres AS dumper

COPY setup/postgres/postgres-init.sql /docker-entrypoint-initdb.d/

# temove the exec "$@" content that exists in the docker-entrypoint.sh file so it will not start the PostgreSQL daemon
RUN ["sed", "-i", "s/exec \"$@\"/echo \"skipping...\"/", "/usr/local/bin/docker-entrypoint.sh"]

ENV PGCTLTIMEOUT=300
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=password
ENV PGDATA=/data

# the dumper will simply load the database into /data
RUN ["/usr/local/bin/docker-entrypoint.sh", "postgres"]

# final build stage
FROM postgres

COPY --from=dumper /data $PGDATA
