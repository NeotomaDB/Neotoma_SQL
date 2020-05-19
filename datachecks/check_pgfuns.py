import os
import json
import psycopg2
import re
import datetime
import uuid
import time

print("\nRunning database tests.")
with open('../connect_remote.json') as f:
    data = json.load(f)

conn = psycopg2.connect(**data)
conn.autocommit = True
cur = conn.cursor()

with open('neotoma_fun_test.json') as f:
    functions = json.load(f)

date = datetime.datetime.now().strftime("%Y%m%d")
filename = 'checks' + uuid.uuid4().hex + '.json'

for i in functions:
    params = ""
    printText = "Now testing %s" % i[0]
    printText = printText + (79 - len(printText)) * " "
    print(printText, end="\r", flush=True)
    if list(i[1].keys())[0] != '':
        for j in i[1].keys():
            params = params + "" + str(j) + ":=" + str(i[1].get(j)) + ", "
        params = re.sub(", $", "", params)
        query = "SELECT * FROM " + i[0] + "(" + params + ") LIMIT 3"
    else:
        query = "SELECT * FROM " + i[0] + "() LIMIT 3"
    try:
        start = time.time()
        cur.execute(query)
        end = time.time()
        error = {'function': i[0],
                 'msg': str(cur.fetchall()),
                 'timer': (end - start)}
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
        end = time.time()
        errmsg = re.sub(r'\"', '\'', str(inst))
        error = {'function': i[0], 'msg': errmsg, 'timer': (end - start)}
        if os.path.exists(filename) is False:
            with open(filename, "a") as f:
                input = [error]
                json.dump(input, f)
        else:
            with open(filename, "r") as f:
                input = json.load(f)
                input.append(error)
                json.dump(input, open(filename, "w"))
    except psycopg2.errors.ForeignKeyViolation as inst:
        end = time.time()
        errmsg = re.sub(r'\"', '\'', str(inst))
        error = {'function': i[0], 'msg': errmsg, 'timer': (end - start)}
        if os.path.exists(filename) is False:
            with open(filename, "a") as f:
                input = [error]
                json.dump(input, f)
        else:
            with open(filename, "r") as f:
                input = json.load(f)
                input.append(error)
                json.dump(input, open(filename, "w"))
    except psycopg2.errors.UniqueViolation as inst:
        end = time.time()
        errmsg = re.sub(r'\"', '\'', str(inst))
        error = {'function': i[0], 'msg': errmsg, 'timer': (end - start)}
        if os.path.exists(filename) is False:
            with open(filename, "a") as f:
                input = [error]
                json.dump(input, f)
        else:
            with open(filename, "r") as f:
                input = json.load(f)
                input.append(error)
                json.dump(input, open(filename, "w"))

conn.close()
