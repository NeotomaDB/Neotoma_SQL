#!/bin/bash

run_command() {
  for table in $(psql -h ${PGHOST} -p ${PGPORT} -d ${PGDB} -U ${PGUSER} \
    -c "select tablename from pg_tables where schemaname = '${PGSCHEMA}';" | \
    tail -n +3 | head -n -2); do
      psql -h ${PGHOST} -p ${PGPORT} -d ${PGDB} -U ${PGUSER} \
           -c "VACUUM (ANALYZE) ${PGSCHEMA}.${table};";
  done
}

display_help() {
    echo "Usage: $0 -s schemaname" >&2
    echo
    echo "   -s schema           The schema to be analyzed."
    echo
    echo " The script assumes that you have a ~/.pgpass file that contains your password"
    echo " information.  The file is described in detail on the Postgres documentation:"
    echo " https://www.postgresql.org/docs/current/libpq-pgpass.html"
    echo
    exit 1
}

while getopts "hw:s:" optionName; do
  case "$optionName" in
    h)
      display_help
      exit 0
      ;;
    s)
      PGSCHEMA="$OPTARG";;
    [?])
      display_help
      exit 0
      ;;
  esac
done
run_command
