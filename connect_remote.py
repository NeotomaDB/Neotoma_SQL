import psycopg2
import json
import os

with open('connect_remote.json') as f:
    data = json.load(f)

conn = psycopg2.connect(**data)

cur = conn.cursor()

cur.execute("""
  SELECT            n.nspname AS schema,
                      proname AS functionName,
    pg_get_functiondef(f.oid) AS function
  FROM            pg_catalog.pg_proc AS f
  INNER JOIN pg_catalog.pg_namespace AS n ON f.pronamespace = n.oid
  WHERE
    n.nspname IN ('ti','ndb','ts', 'mca', 'ecg', 'ap', 'da', 'emb', 'gen')""")

for record in cur:
    newFile = "./" + record[0] + "/" + record[1] + ".sql"
    testPath = "./" + record[0]
    if os.path.isdir(testPath) != True:
        os.mkdir(testPath)

    if os.path.exists(newFile) != True:
        file = open(newFile, 'w')
        file.write(record[2])
        file.close()
