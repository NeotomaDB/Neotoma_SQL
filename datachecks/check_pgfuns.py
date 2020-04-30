import json
import psycopg2
import re
import datetime

with open('connect_remote.json') as f:
    data = json.load(f)

conn = psycopg2.connect(**data)
conn.autocommit = True
cur = conn.cursor()

with open('datachecks/neotoma_fun_raw.json') as f:
    functions = json.load(f)

date = datetime.datetime.now().strftime("%Y%m%d")
filename = 'datachecks/checks' + date + '.json'

for i in functions:
    params = ""
    if list(i[1].keys())[0] != '':
        for j in i[1].keys():
            params = params + "" + j + ":=" + i[1].get(j) + ", "
            params = re.sub(", $", "", params)
            query = "SELECT * FROM " + i[0] + "(" + params + ")"
    else:
        query = "SELECT * FROM " + i[0] + "()"
    try:
        aa = cur.execute(query)
        error = {'function': i[0], 'msg': 'Function Passed'}
        if os.stat(filename).st_size == 0:
            with open(filename, "a") as f:
                input = [error]
                json.dump(input, f)
        else:
            with open(filename, "r") as f:
                input = json.load(f)
                input.append(error)
                json.dump(input, open(filename, "w"))
    except psycopg2.ProgrammingError as inst:
        errmsg = re.sub(r'\"', '\'', str(inst))
        error = {'function': i[0], 'msg': errmsg}
        if os.stat(filename).st_size == 0:
            with open(filename, "a") as f:
                input = [error]
                json.dump(input, f)
        else:
            with open(filename, "r") as f:
                input = json.load(f)
                input.append(error)
                json.dump(input, open(filename, "w"))
