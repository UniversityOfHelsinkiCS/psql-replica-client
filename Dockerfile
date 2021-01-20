FROM postgres:13.1

COPY ./certs/* /var/lib/postgresql/certs/

RUN chown -R postgres:postgres /var/lib/postgresql/certs/
RUN chmod 600 /var/lib/postgresql/certs/*

ENV PGSSLROOTCERT=/var/lib/postgresql/certs/root.crt
ENV PGSSLCERT=/var/lib/postgresql/certs/postgresql.crt
ENV PGSSLKEY=/var/lib/postgresql/certs/postgresql.key

COPY ./setup-client.sh /docker-entrypoint-initdb.d/setup-client.sh
RUN chmod 0666 /docker-entrypoint-initdb.d/setup-client.sh