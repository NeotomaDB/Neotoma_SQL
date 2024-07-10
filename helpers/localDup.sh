#!/bin/bash
# Documentation for pg_dump is available at https://www.postgresql.org/docs/current/app-pgdump.html
# This script uses pg_dump to duplicate the whole database to a local version.
psql postgresql://postgres:postgres@localhost:5435 -c "DROP DATABASE IF EXISTS neotoma;"
pg_dump -C -v -O --no-owner -h localhost -p 5555 -d neotoma -U neotomaAdmin > ./archives/todaytest.sql
psql postgresql://postgres:postgres@localhost/neotoma:5435 -f ./archives/todaytest.sql

psql postgresql://postgres:postgres@localhost:5435 -c "CREATE DATABASE neotoma;"
pg_restore -U postgres -W -h localhost -p 5435 -d neotoma -f ./dumper.log > testlog.log
