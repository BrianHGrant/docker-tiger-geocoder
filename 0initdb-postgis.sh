#!/bin/sh

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

# Create the 'template_postgis' template db
"${psql[@]}" <<- 'EOSQL'
CREATE DATABASE template_postgis;
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_postgis';
EOSQL

# Load PostGIS into both template_database and $POSTGRES_DB
for DB in template_postgis "$POSTGRES_DB"; do
	echo "Loading PostGIS extensions into $DB"
	"${psql[@]}" --dbname="$DB" <<-'EOSQL'
  CREATE EXTENSION postgis;
  CREATE EXTENSION fuzzystrmatch;
  CREATE EXTENSION address_standardizer;
  CREATE EXTENSION postgis_tiger_geocoder;
  CREATE EXTENSION postgis_topology;
  GRANT USAGE ON SCHEMA tiger TO PUBLIC;
  GRANT USAGE ON SCHEMA tiger_data TO PUBLIC;
  GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tiger TO PUBLIC;
  GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tiger_data TO PUBLIC;
  GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA tiger TO PUBLIC;
  ALTER DEFAULT PRIVILEGES IN SCHEMA tiger_data GRANT SELECT, REFERENCES ON TABLES TO PUBLIC;
EOSQL
done
