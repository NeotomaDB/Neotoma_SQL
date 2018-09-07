""" Connect to the Neotoma Dev database and return all the currently scripted
    queries. If a sql file exists in one of the local schema directories but
    does not have an associated function, then create that function. """

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

import json
import os
import psycopg2

with open('.gitignore') as gi:
    good = False
    # This simply checks to see if you have a connection string in your repo.
    # I use `strip` to remove whitespace/newlines.
    for line in gi:
        if line.strip() == "connect_remote.json":
            good = True
            break

if good is False:
    print("Your connect_remote file is not in your .gitignore file.  Please add it!")

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

for record in cur:
    # This checks each function in the database and then tests whether there
    # is a file associated with it.
    newFile = "./function/" + record[0] + "/" + record[1] + ".sql"
    testPath = "./function/" + record[0]
    if os.path.isdir(testPath) is False:
        # If there is no directory for the schema, make it.
        os.mkdir(testPath)

    if os.path.exists(newFile) is False:
        # If there is no file for the function, make it:
        print(record[0] + '.' + record[1] + ' has been added.')
        file = open(newFile, 'w')
        file.write(record[2])
        file.close()

    if os.path.exists(newFile) is True:
        # If there is a file, check to see if they are the same, so we
        # can check for updated functions.
        oldFile = open(newFile)
        match = set(oldFile).intersection(record[2])
        if len(match) > 1:
            print(len(match))
            print(record[0] + '.' + record[1] + ' has been updated.')
            file = open(newFile, 'w')
            file.write(record[2])
            file.close()

for schema in ['ti', 'ts']:
    # Now check all files to see if they are in the DB. . .
    for functs in os.listdir("./function/" + schema + "/"):
        #
        SQL = """
          SELECT            n.nspname AS schema,
                              proname AS functionName,
            pg_get_functiondef(f.oid) AS function
          FROM            pg_catalog.pg_proc AS f
          INNER JOIN pg_catalog.pg_namespace AS n ON f.pronamespace = n.oid
          WHERE
            n.nspname = %s AND proname = %s"""
        data = (schema, functs.split(".")[0])
        cur.execute(SQL, data)
        if cur.rowcount == 0:
            # Execute the new script if there is one.  Needs the commit.
            cur.execute(open("./function/" + schema + "/" + functs, "r").read())
            conn.commit()
            print("Executing " + schema + "." + functs.split(".")[0])
        if cur.rowcount > 1:
            print(schema + "." + functs.split(".")[0] + " has " +
                  str(cur.rowcount) + " definitions.")
