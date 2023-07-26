#! /bin/bash
set -e

rm -rf /var/lib/postgresql/data/*
echo "master_db:*:*:$POSTGRES_REPLICATION_USER:$POSTGRES_REPLICATION_PASSWORD" > /var/lib/postgresql/.pgpass
chown postgres:postgres /var/lib/postgresql/.pgpass
chmod 0600 /var/lib/postgresql/.pgpass
unset PGPASSWORD
PGPASSFILE=/var/lib/postgresql/.pgpass pg_basebackup \
    --host=master_db \
    --username=$POSTGRES_REPLICATION_USER \
    --pgdata=/var/lib/postgresql/data/ \
    --wal-method=stream \
    --write-recovery-conf