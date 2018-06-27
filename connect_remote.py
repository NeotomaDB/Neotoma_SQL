# Connect to the Neotoma Dev database and return all the currently scripted
# queries.
# NOTE: This requires the inclusion of a json file in the base directory called
#       connect_remote.json that uses the format:
#
#  {
#     "host": "hostname",
#     "port": 9999,
#     "database": "databasename",
#     "user": "username",
#     "password": "passwordname"
#  }
#
#  Please ensure that this file is included in the .gitignore file.
#

import psycopg2
import json
import os

with open('connect_remote.json') as f:
    data = json.load(f)

conn = psycopg2.connect(**data)

cur = conn.cursor()

# This query usues the catalog to find all functions and definitions within the
# neotomadev database.

cur.execute("""
  SELECT            n.nspname AS schema,
                      proname AS functionName,
    pg_get_functiondef(f.oid) AS function
  FROM            pg_catalog.pg_proc AS f
  INNER JOIN pg_catalog.pg_namespace AS n ON f.pronamespace = n.oid
  WHERE
    n.nspname IN ('ti','ndb','ts', 'mca', 'ecg', 'ap', 'da', 'emb', 'gen')""")

# For each sql function in the named namespaces go in and write out the actual
# function declaration if the function does not currently exist in the GitHub
# repo.
#
# TODO: Need to actually compare the files, could possibly overwrite them?

for record in cur:
    newFile = "./function/" + record[0] + "/" + record[1] + ".sql"
    testPath = "./function/" + record[0]
    if os.path.isdir(testPath) != True:
        os.mkdir(testPath)

    if os.path.exists(newFile) != True:
        file = open(newFile, 'w')
        file.write(record[2])
        file.close()
