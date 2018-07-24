import json
import requests
from colorama import Fore
from colorama import Style
from sys import argv

tilia_uri = 'http://tilia.neotomadb.org/Retrieve/'
dev_uri = 'http://tilia-dev.neotomadb.org:3001/retrieve/'
headers = {'Content-Type': 'application/json'}

if len(argv) == 1:
    argv.append('miss')

tilia_ends = requests.get(tilia_uri, headers=headers).json()
dev_ends = requests.get(dev_uri, headers=headers).json()

print("tilia succeeded, obtained "     + str(len(tilia_ends["data"])) + " SQL Server Tilia functions.")
print("tilia-dev succeeded, obtained " + str(len(dev_ends["data"])) + " Postgres Tilia functions.")

dev_fun = [x["name"] for x in dev_ends["data"]]

index = 35

tilia_params = tilia_ends["data"][index]["params"]
fun = dev_fun.index(tilia_ends["data"][index]["name"].lower())
dev_params = dev_ends["data"][fun]["params"]

t_par_names = [x["name"].lower() for x in tilia_params]
dev_par_names = [x["name"] for x in dev_params]

matched = 0
missing = 0
wrong_param = 0

for i in tilia_ends["data"]:
    if i["name"].lower() in dev_fun:
        matched = matched + 1

        devIndex = dev_fun.index(i["name"].lower())

        tilia_params = [x["name"].lower() for x in i["params"]]
        dev_params = [x["name"] for x in dev_ends["data"][devIndex]["params"]]

        if ((set(t_par_names) == set(dev_par_names)) | (bool(t_par_names == []) & bool(dev_par_names == [None]))):
            print(f"{Fore.GREEN}Found match{Style.RESET_ALL}: " + i["name"].lower())

        else:
            print(f"{Fore.YELLOW}Match with unmatched parameters{Style.RESET_ALL}: " + i["name"].lower())
            wrong_param = wrong_param + 1

    # Need to match params now too.
    else:
        print(f"{Fore.RED}Missing{Style.RESET_ALL}: " + i["name"].lower())
        missing = missing + 1

print(f"\n{Fore.GREEN}Total Matched:{Style.RESET_ALL}:" + str(matched))
print(f"{Fore.YELLOW}Matched with wrong parameters:{Style.RESET_ALL}:" + str(wrong_param))
print(f"{Fore.RED}Total Missed:{Style.RESET_ALL}:" + str(missing))
