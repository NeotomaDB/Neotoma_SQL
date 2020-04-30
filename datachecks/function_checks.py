import csv
import json
import re

"""
Pulling the set of functions out of Postgres to build a raw testing set:
SELECT nspname || '.' || proname as  name,
       json_agg(
       		json_build_object(
       			'name',
       			(string_to_array(longstring.params, ' '))[1],
                'type',
                array_to_string((string_to_array(longstring.params, ' '))[2:],
                ' ')
                )
       		) AS params
FROM    pg_catalog.pg_namespace n
JOIN    pg_catalog.pg_proc p
ON      pronamespace = n.oid
JOIN 	(
		  SELECT unnest(regexp_split_to_array(pg_get_function_arguments(p.oid), ', ')) AS params, proname AS funname
		  FROM    pg_catalog.pg_namespace n
		  JOIN    pg_catalog.pg_proc p
		  ON      pronamespace = n.oid
		  WHERE   nspname IN ('ap','da','ecg','ti','ts')
		) AS longstring
ON longstring.funname = p.proname
WHERE   nspname IN ('ap','da','ecg','ti','ts')
GROUP BY nspname, proname;
"""


with open('datachecks/neotoma_fun.csv') as f:
  funcfile = csv.reader(f)
  silent = next(f)
  functions = list(funcfile)

test_funs = []
for i in functions:
  i[1] = re.sub("\'", '"', i[1])
  i[1]=re.sub("\: None", ':""', i[1])
  keys = list(map(lambda x: {x.get('name'):x.get('type')}, json.loads(i[1])))
  dictout = {}
  dictout.update(list(d.items())[0] for d in keys)
  test_funs.append([i[0], dictout])

with open('datachecks/neotoma_fun_raw.json', 'w') as f:
    json.dump(test_funs, f)
