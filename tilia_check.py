import json
import requests

tilia_uri = 'http://tilia.neotomadb.org/Retrieve/'
dev_uri = 'http://tilia.neotomadb.org/Retrieve/'
headers = {'Content-Type': 'application/json'}

tilia_ends = requests.get(tilia_uri, headers=headers).json()

print("Request succeeded, obtained " + str(len(tilia_ends["data"])) + " SQL Server Tilia functions.")

for i in range(len(tilia_ends["data"])):
    print(tilia_ends["data"][i]["name"].lower())
