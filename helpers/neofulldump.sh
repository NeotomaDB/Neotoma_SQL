#!/bin/bash
<<<<<<< HEAD
# Create local file dumps of the Neotoma Database.
# Created June 7, 2021 by Simon Goring
#
# Usage:
# This function requires the use of a username:
# > bash neofulldump.sh username
#
# The script results in two separate files being created (and then compressed using `tar`).
# * ./archives/neotoma_dump_schema_${now}.tar 
#   * A schema-only version of the database.
# * ./archives/neotoma_dump_full_${now}.tar
#   * A complete dump of the database.
#
# The following flags are used in the duplication.
# * -Fc: Use a custom format (to support use by pg_restore).
# * -O:  Do not output commands to set ownership of objects to match the original database.
# * -v:  Use verbose mode.
# * -h:  Defines the host
# * -U:  Defines the user ($1 comes from the arguments provided to the script).
# * -s:  Schema only (For the first dump).
# * -W:  Request password.
# * -d:  The name of the database to be dumped.
#
#  Note two directories are created during code exection: `dumps` and `archives`.  These
#  directories can exist prior to execution, but `dumps` will be deleted at the end of
#  code execution.  For this reason, the `dumps` folder has the current date appended to the script
#  so that it doesn't mess everything up.

if [ $# -eq 0 ]; then
    echo "Please provide your username, and password e.g.:"
    echo "> bash neofulldump.sh username password"
    exit 1
fi
now=`date +"%Y-%m-%d"`
mkdir -p dumps${now}
mkdir -p archives
export PGPASSWORD=$2
pg_dump -Fc -O -v -h db5.cei.psu.edu -U $1 -s neotoma > ./dumps${now}/neotoma_ndb_schema_${now}.sql
tar -cvf ./archives/neotoma_dump_schema_${now}.tar -C ./dumps${now} neotoma_ndb_schema_${now}.sql

pg_dump -Fc -O -v -h db5.cei.psu.edu -U $1 --schema=ndb -d neotoma > ./dumps${now}/neotoma_ndb_only_${now}.sql
tar -cvf ./archives/neotoma_ndb_only_${now}.tar -C ./dumps${now} neotoma_ndb_only_${now}.sql

pg_dump -Fc -O -h db5.cei.psu.edu -U $1 -n ndb -v -d neotoma > ./dumps${now}/neotoma_ndb_full_${now}.sql
tar -cvf ./archives/neotoma_ndb_full_${now}.tar -C ./dumps${now} neotoma_ndb_full_${now}.sql
rm ./dumps${now}/*
rmdir ./dumps${now}
=======
if [ $# -eq 0 ]; then
    echo "Please provide your username, e.g.:"
    echo "> bash neofulldump.sh postgres"
    exit 1
fi
now=`date +"%Y-%m-%d"`
mkdir -p dumps
mkdir -p archives
pg_dump -Fc -O -v -h db5.cei.psu.edu -U $1 -s neotoma > ./dumps/neotoma_ndb_schema_${now}.sql
pg_dump -Fc -O -v -h db5.cei.psu.edu -U $1 -N gen -N tmp -W -v -d neotoma > ./dumps/neotoma_dump_full_${now}.sql
tar -cvf ./archives/neotoma_dump_full_${now}.tar -C ./dumps neotoma_dump_full_${now}.sql
rm ./dumps/neotoma_dump_full_${now}.sql
pg_dump -Fc -O -h db5.cei.psu.edu -U $1 -N gen -n ndb -W -v -d neotoma > ./dumps/neotoma_dump_ndb_${now}.sql
tar -cvf ./archives/neotoma_dump_ndb_${now}.tar -C ./dumps neotoma_dump_ndb_${now}.sql
rm ./dumps/neotoma_dump_ndb_${now}.sql
rmdir ./dumps
>>>>>>> 9e2ea20b36954d3a88d2b6f48da67cecb4c72804
