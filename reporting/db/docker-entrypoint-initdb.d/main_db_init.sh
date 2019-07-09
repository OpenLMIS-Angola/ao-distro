#!/bin/bash
set -e

PGPASSWORD=$OLMIS_DATABASE_PASSWORD psql -v ON_ERROR_STOP=1 --username "$OLMIS_DATABASE_USER" --dbname "$OLMIS_DATABASE_NAME" --host "$OLMIS_DATABASE_URL" < /docker-entrypoint-initdb.d/templates/MainDbCreateMaterializedViews.sql
