#! /usr/bin/python3

"""
Neotoma DB Function Checker

Simon Goring
2018 MIT License

Connect to a Neotoma Paleoecology Database using a JSON connection string
and return all the currently scripted queries. If a sql file exists in one
of the local schema directories but does not have an associated function,
then create that function.


NOTE: This requires the inclusion of a json file in the base directory called
connect_remote.json that uses the format:

{
 "host": "hostname",
 "port": 9999,
 "database": "databasename",
 "user": "username",
 "password": "passwordname"
}

Please ensure that this file is included in the .gitignore file.
"""

import json
import os
import psycopg2
import argparse
import copy
import re
import git
import sys

parser = argparse.ArgumentParser(description='Check Neotoma SQL functions against functions in the online database servers (`neotoma` and `neotomadev`).')

parser.add_argument('-dev', dest='isDev', default = False, help = 'Use the `dev` database? (`False` without the flag)', action = 'store_true')
parser.add_argument('-push', dest='isPush', default = False, help = 'Assume that SQL functions in the repository are newer, push to the db server.', action = 'store_true')
parser.add_argument('-g', dest='pullGit', nargs = '?', type = str, default = None, help = 'Pull from the remote git server before running?.')

args = parser.parse_args()

with open('.gitignore') as gi:
    good = False
    # This simply checks to see if you have a connection string in your repo.
    # I use `strip` to remove whitespace/newlines.
    for line in gi:
        if line.strip() == "connect_remote.json":
            good = True
            break

if good is False:
    print("The connect_remote.json file is not in your .gitignore file.  Please add it!")

with open('connect_remote.json') as f:
    data = json.load(f)

if args.pullGit is not None:
    repo = git.Repo('.')
    try:
        repo.heads[args.pullGit].checkout()
    except git.exc.GitCommandError:
        sys.exit("Stash or commit changes in the current branch before switching to " + args.pullGit + ".")

    repo.remotes.origin.pull()

if args.isDev:
    data['database'] = data['database'] + 'dev'

print("Using the " + data['database'] + ' Neotoma server.')

conn = psycopg2.connect(**data)

cur = conn.cursor()

# This query uses the catalog to find all functions and definitions within the
# neotomadev database.

cur.execute("""
  SELECT            n.nspname AS schema,
                      proname AS functionName,
    pg_get_functiondef(f.oid) AS function
  FROM            pg_catalog.pg_proc AS f
  INNER JOIN pg_catalog.pg_namespace AS n ON f.pronamespace = n.oid
  WHERE
    n.nspname IN ('ti','ndb','ts', 'mca', 'ecg', 'ap', 'da', 'emb', 'gen', 'doi')""")

# For each sql function in the named namespaces go in and write out the actual
# function declaration if the function does not currently exist in the GitHub
# repo.

print('Running!')

rewrite = []
z = 0

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
        file = open(newFile)
        textCheck = copy.deepcopy(file.read())
        serverFun = copy.deepcopy(record[2])

        textCheck = re.sub('[\s+\t+\n+\r+]','', textCheck)
        serverFun = re.sub('[\s+\t+\n+\r+]','', serverFun)
        match = serverFun == textCheck

        # Pushing and pulling are defined by the user.

        if match:
            print(match)

            if args.isPush == False:
                file = open(newFile, 'w')
                file.write(record[2])
                file.close()
                print('The file for ' + record[0] + '.' + record[1] + ' has been updated in the repository.')
            else:
                cur.execute(open("./function/" + record[0] + "/" + record[1] + ".sql", "r").read())
                conn.commit()
                print('The function for ' + record[0] + '.' + record[1] + ' has been updated in the `' + data['database'] + '` database.')

for schema in ['ti', 'ts', 'doi']:
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
        print(data)
        cur.execute(SQL, data)
        if cur.rowcount == 0:
            # Execute the new script if there is one.  Needs the commit.
            cur.execute(open("./function/" + schema + "/" + functs, "r").read())
            conn.commit()
            print("Executing " + schema + "." + functs.split(".")[0])
            rewrite.append(schema + "." + functs.split(".")[0])
            z = z + 1
        if cur.rowcount > 1:
            # TODO:  Need to add a script to check that the definitions are the same.
            print(schema + "." + functs.split(".")[0] + " has " +
                  str(cur.rowcount) + " definitions.")

print("The script has rewritten:")

for funs in rewrite:
    print("  * " + funs)
