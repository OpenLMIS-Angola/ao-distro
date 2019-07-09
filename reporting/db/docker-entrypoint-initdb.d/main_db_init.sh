#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$OLMIS_DATABASE_USER" --dbname "$OLMIS_DATABASE_NAME" --host "$OLMIS_DATABASE_URL" --password "$OLMIS_DATABASE_PASSWORD" < /docker-entrypoint-initdb.d/templates/MainDbCreateMaterializedViews.sql