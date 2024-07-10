"""_Check for non-breaking spaces in text fields_
   This issue arose as part of some text-searching that a 
   user was doing. The code here connects to a PostgreSQL
   database, 
"""
import json
import psycopg2
from psycopg2 import sql

print("\nRunning database tests.")
with open('../connect_remote.json', encoding='UTF-8') as f:
    data = json.load(f)

conn = psycopg2.connect(**data)
conn.autocommit = True
cur = conn.cursor()

# List all text columns.
TEXT_COLS = """
    select col.table_schema,
        col.table_name,
        col.ordinal_position as column_id,
        col.column_name,
        col.data_type,
        col.character_maximum_length as maximum_length
    from information_schema.columns col
    join information_schema.tables tab on tab.table_schema = col.table_schema
                                    and tab.table_name = col.table_name
                                    and tab.table_type = 'BASE TABLE'
    where col.data_type in ('character varying', 'character',
                            'text', '"char"', 'name')
        and col.table_schema not in ('information_schema', 'pg_catalog', 'public', 'tmp', 'pglogical')
    order by col.table_schema,
            col.table_name,
            col.ordinal_position;"""

cur.execute(TEXT_COLS)
tables = cur.fetchall()

EMPTY_SPACE = """
SELECT {}
FROM {}
WHERE {} ~ '.*[\u00A0\u1680\u180E\u2000-\u200B\u202F\u205F\u3000\uFEFF].*'"""

runcounter = []

for row in tables:
    tableobj = {'schema': row[0], 'table': row[1], 'column': row[3]}
    cur.execute(
        sql.SQL(EMPTY_SPACE).format(sql.Identifier(row[3]),
                                    sql.Identifier(row[0], row[1]),
                                    sql.Identifier(row[3])),
        tableobj)
    tableobj.update({'rows': cur.fetchall()})
    runcounter.append(tableobj)

FIELDS = list(filter(lambda x: len(x['rows']) > 0, runcounter))

len(FIELDS)

UPDATE_QUERY = """
UPDATE {}
SET {} = regexp_replace({},
    '[\u00A0\u1680\u180E\u2000\u200B\u202F\u205F\u3000\uFEFF]',
    ' ')
    WHERE {} ~ '.*[\u00A0\u1680\u180E\u2000-\u200B\u202F\u205F\u3000\uFEFF].*'"""

for row in FIELDS:
    cur.execute(
        sql.SQL(UPDATE_QUERY).format(sql.Identifier(row['schema'], row['table']),
                                     sql.Identifier(row['column']),
                                     sql.Identifier(row['column']),
                                     sql.Identifier(row['column'])))
