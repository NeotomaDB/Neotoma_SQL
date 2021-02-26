#!/bin/bash
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
