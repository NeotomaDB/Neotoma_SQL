#!/bin/bash

contactid=""
username=""
password=""
taxonomyexpert=""
databaseid=""

#########################
# The command line help #
#########################
display_help() {
    echo "Usage: $0 [option...]" >&2
    echo
    echo "   -c contactid           New steward's contact ID"
    echo "   -u username            New steward's username"
    echo "   -p password            New steward's password"
    echo "   -t taxonomyexpert      Is the steward a taxonomy expert? [true|false]"
    echo "   -d database            Which database is the steward associate with?"
    echo
    # echo some stuff here for the -a or --add-options
    exit 1
}

run_command() {
    psql -h ${PGHOST} -p ${PGPORT} -d ${PGDB} -U ${PGUSER} -c \
      "SELECT * FROM ts.insertsteward(_contactid:=$contactid, _username:=$username, _password:=$password, _taxonomyexpert:=$taxonomyexpert, _databaseid:=$databaseid );"
}

while getopts "hw:c:u:p:t:d:" optionName; do
  case "$optionName" in
    h)
      display_help
      exit 0
      ;;
    c)
      contactid="$OPTARG";;
    u)
      username="'$OPTARG'";;
    p)
      password="'$OPTARG'";;
    t)
      taxonomyexpert="$OPTARG";;
    d)
      databaseid="$OPTARG";;
    [?])
      display_help
      exit 0
      ;;
  esac
done
run_command
