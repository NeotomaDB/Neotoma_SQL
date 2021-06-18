#!/bin/bash
# Documentation for pg_dump is available at https://www.postgresql.org/docs/current/app-pgdump.html
# This script uses pg_dump to duplicate the whole database to a local version.
export PGPASSWORD=$1
psql -h localhost -U postgres -c "DROP DATABASE IF EXISTS neotoma;"
psql -h localhost -U postgres -c "CREATE DATABASE neotoma;"
export PGPASSWORD=$2
pg_dump -C -v -O -h db5.cei.psu.edu -U sug335 -d neotoma | psql -W -h localhost -U postgres neotoma
