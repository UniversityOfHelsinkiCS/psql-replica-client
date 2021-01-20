#!/bin/bash
echo "*:*:*:$PG_REP_USER:$PG_REP_PASSWORD" > ~/.pgpass
chmod 0600 ~/.pgpass
echo "Cleaning up old cluster directory"
rm -rf ${PGDATA}/*
until PGPASSWORD=${PG_REP_PASSWORD} pg_basebackup -h ${PG_REP_HOST} -p $PG_REP_PORT -D ${PGDATA} -U ${PG_REP_USER} -P -Xs -R
do
echo "Waiting for host to connect..."
sleep 1s
done
cat >> ${PGDATA}/postgresql.conf <<EOF
max_standby_streaming_delay = 300s
ssl_cert_file = '/var/lib/postgresql/certs/server.crt'
ssl_key_file = '/var/lib/postgresql/certs/server.key'
primary_conninfo = 'host=$PG_REP_HOST port=$PG_REP_PORT user=$PG_REP_USER password=$PG_REP_PASSWORD'
primary_slot_name = '$REP_SLOT_NAME'
EOF
echo "hostssl replication all 0.0.0.0/0 md5 clientcert=1" >> "$PGDATA/pg_hba.conf"
set -e
chown postgres. ${PGDATA} -R
chmod 700 ${PGDATA} -R