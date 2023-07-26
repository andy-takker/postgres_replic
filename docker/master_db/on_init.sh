#! /bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER $POSTGRES_REPLICATION_USER WITH REPLICATION PASSWORD '$POSTGRES_REPLICATION_PASSWORD';
EOSQL

echo "wal_level = replica" >> /var/lib/postgresql/data/postgresql.conf
echo "max_wal_senders = 2" >> /var/lib/postgresql/data/postgresql.conf
echo "max_replication_slots = 2" >> /var/lib/postgresql/data/postgresql.conf
echo "hot_standby = on" >> /var/lib/postgresql/data/postgresql.conf
echo "hot_standby_feedback = on" >> /var/lib/postgresql/data/postgresql.conf

echo "host replication $POSTGRES_REPLICATION_USER $POSTGRES_REPLICATION_HOST/24 md5" >> /var/lib/postgresql/data/pg_hba.conf
