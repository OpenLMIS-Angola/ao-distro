#!/bin/bash

: ${SUPERSET_ADMIN_USERNAME:?"Need to set SUPERSET_ADMIN_USERNAME"}
: ${SUPERSET_ADMIN_PASSWORD:?"Need to set SUPERSET_ADMIN_PASSWORD"}

fabmanager create-admin --app superset --username ${SUPERSET_ADMIN_USERNAME} --firstname Admin --lastname Admin --email noreply --password ${SUPERSET_ADMIN_PASSWORD} &&
superset db upgrade &&
superset import_datasources -p /etc/superset/datasources/database.yaml &&
superset import_dashboards -p /etc/superset/dashboards/openlmis_uat_dashboards.json &&
superset init && gunicorn -w 2 --timeout 60 -b 0.0.0.0:8088 --reload --limit-request-line 0 --limit-request-field_size 0 superset:app
