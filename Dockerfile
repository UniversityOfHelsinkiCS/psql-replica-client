FROM postgres:9.6-alpine
RUN apk add build-base
RUN apk add make
RUN apk add curl
RUN curl -L https://github.com/ncopa/su-exec/archive/dddd1567b7c76365e1e0aac561287975020a8fad.tar.gz | tar xvz && \
cd su-exec-* && make && mv su-exec /usr/local/bin && cd .. && rm -rf su-exec-*
RUN apk add --update iputils

COPY ./certs/* /var/lib/postgresql/certs/

RUN chown -R postgres:postgres /var/lib/postgresql/certs/
RUN chmod 600 /var/lib/postgresql/certs/*
RUN ls -la /var/lib/postgresql/certs/

ENV PGSSLROOTCERT=/var/lib/postgresql/certs/root.crt
ENV PGSSLCERT=/var/lib/postgresql/certs/postgresql.crt
ENV PGSSLKEY=/var/lib/postgresql/certs/postgresql.key

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["su-exec", "postgres", "postgres"]