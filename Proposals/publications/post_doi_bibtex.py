'''
This script will read in the modified outputs.csv file and post new DOIs to Neotoma.
'''

# We'll read in the `outputs.csv` file, and then for each row, update the DOI column.
import psycopg2
import dotenv
import os
import json
import csv
import requests
import urllib

dotenv.load_dotenv()

dbauth = json.loads(os.getenv('DBAUTH'))

conn = psycopg2.connect(**dbauth, connect_timeout=5)

QUERY = """INSERT INTO ndb.publications(publicationid, doi, bibtex)
           VALUES (%(publicationid)s, %(doi)s, %(bibtex)s)
           ON CONFLICT (publicationid)
           DO UPDATE SET    doi = EXCLUDED.doi,
                         bibtex = EXCLUDED.bibtex;"""


def return_bibtex(doi_string:str):
    url = 'https://doi.org/' + urllib.request.quote(doi_string)
    header = {
        'Accept': 'application/x-bibtex',
        'User-Agent': 'Neotoma Publication Augmenter; mailto:goring@wisc.edu'
    }
    try:
        response = requests.get(url, headers=header, timeout = 10)
    except requests.exceptions.ReadTimeout as e:
        return None
    if response.status_code == 200:
        return response.text.strip()
    else:
        return None


with open('output.csv', 'r') as newdois:
    reader = csv.DictReader(newdois)
    for i in reader:
        bibtex = return_bibtex(i.get('doi'))
        if bibtex is not None:
            with conn.cursor() as cur:
                cur.execute(QUERY, {'doi': i.get('doi'),
                                    'bibtex': bibtex,
                                    'publicationid': int(i.get('publicationid'))})
                conn.commit()
                cur.close()
            print(f'Added bibtex and DOI for publication {i.get('publicationid')}.')
        else:
            print(f'Could not resolve bibtex/ DOI for publication {i.get('publicationid')}: {i.get('doi')}.')
