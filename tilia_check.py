""" Check all newly written functions for the Neotoma postgres DB against
    the old functions written in SQL Server T-SQL.
    by: Simon Goring  """

from sys import argv
from re import sub
from colorama import Fore
from colorama import Style
import requests

tilia_uri = 'http://tilia.neotomadb.org/Retrieve/'
dev_uri = 'http://tilia-dev.neotomadb.org:3001/retrieve/'
headers = {'Content-Type': 'application/json'}

if len(argv) == 1:
    argv.append('miss')

tilia_ends = requests.get(tilia_uri, headers=headers).json()
dev_ends = requests.get(dev_uri, headers=headers).json()

print("tilia succeeded, obtained "     + str(len(tilia_ends["data"])) +
      " SQL Server Tilia functions.")
print("tilia-dev succeeded, obtained " + str(len(dev_ends["data"])) +
      " Postgres Tilia functions.")

# Get all the names of the functions curently in the database
#  remove the schema indicator.
dev_fun = [x["name"].split(".")[1] for x in dev_ends["data"]]

matched = 0
missing = 0
wrong_param = 0

for i in tilia_ends["data"]:

    if i["name"].lower() in dev_fun:
        matched = matched + 1

        devIndex = dev_fun.index(i["name"].lower())

        tilia_params = [x["name"].lower() for x in i["params"]]

        # Need to check for `None` values . . .
        if not dev_ends["data"][devIndex]["params"][0]["name"] is None:
            dev_params = [sub('_', '', x["name"]) for x in dev_ends["data"][devIndex]["params"]]
            emptyParam = False
        else:
            dev_params = [x["name"] for x in dev_ends["data"][devIndex]["params"]]
            emptyParam = True

        if ((set(tilia_params) == set(dev_params)) |
                (bool(tilia_params == []) & bool(emptyParam is True))):
            if argv[1] == "all":
                print(f"{Fore.GREEN}Found match{Style.RESET_ALL}: " + i["name"].lower())
        else:
            print(f"{Fore.YELLOW}Match with unmatched parameters{Style.RESET_ALL}: " +
                  i["name"].lower())
            print("New:")
            print(dev_params)
            print(tilia_params)
            wrong_param = wrong_param + 1

    # Need to match params now too.
    else:
        print(f"{Fore.RED}Missing{Style.RESET_ALL}: " + i["name"].lower())
        missing = missing + 1

print(f"\n{Fore.GREEN}Total Matched:{Style.RESET_ALL}:" + str(matched))
print(f"{Fore.YELLOW}Matched with wrong parameters:{Style.RESET_ALL}:" + str(wrong_param))
print(f"{Fore.RED}Total Missed:{Style.RESET_ALL}:" + str(missing))
