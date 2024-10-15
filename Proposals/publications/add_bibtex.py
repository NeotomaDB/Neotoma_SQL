# Read in all Neotoma publications from a Postgres table export
# Attempt to clean DOI fields to match the regex `\b10\.\d{4,9}/[-.;()/:\w]+`
# For records with DOIs, call out to crossref to get a formatted BibTex object
# For records without, call CrossRef with the article title to find a DOI.
# Return all objects to a CSV for hand validation.

import requests
import csv
import sys
import urllib
import re
import subprocess
import json
from crossref.restful import Works, Etiquette

csv.field_size_limit(sys.maxsize)

def clean_doi(doi_string:str):
    if type(doi_string) is not str:
        raise Exception('TypeError', f'The doi passed -- {doi_string} -- is not a string.')
    outcome = re.match(r'.*(\b10\.\d{4,9}/[-.;()/:\w]+)', doi_string)
    if outcome is None:
        return None
    else:
        return outcome.group(1)

def break_citation(citation:str):
    with open('temp.txt', 'w') as wr:
        wr.write(citation)
    outcome = subprocess.run(['anystyle', '-f', 'json', 'parse', 'temp.txt'], capture_output = True)
    if outcome.stdout == b'':
        raise Exception('ValueError', f'Could not perform extraction from: {citation}')
    else:
        return json.loads(outcome.stdout)

def return_bibtex(doi_string:str):
    url = 'https://doi.org/' + urllib.request.quote(doi_string)
    header = {
        'Accept': 'application/x-bibtex',
        'User-Agent': 'Neotoma Publication Augmenter; mailto:goring@wisc.edu'
    }
    response = requests.get(url, headers=header)
    return response.text.strip()

def check_crossref(cite_object:str):
    url = 'https://api.crossref.org/works'
    url_call = requests.get(url,
                            headers = {'Accept': 'application/json',
                                       'User-Agent': 'Neotoma Publication Augmenter; mailto:goring@wisc.edu'},
                            params = {'rows':1,
                                    'mailto':'goring@wisc.edu',
                                    'select':'DOI,title,container-title,published',
                                    'query':f'query.title={cite_object}'})
    if url_call.status_code == 200:
        cross_ref = json.loads(url_call.content)
        if cross_ref.get('message').get('total-results') > 0:
            return cross_ref.get('message').get('items', '')[0]
        else:
            return None
    else:
        return None

with open('data/neotoma_publications_202410071440.csv') as file:
    db_data = list(csv.DictReader(file))

# For each row
for i in db_data:
    if any([j in ['bibtex', 'newdoi', 'json'] for j in i.keys()]):
        continue
    if i.get('doi', '') != '':
        try:
            outcome = clean_doi(i.get('doi'))
            if outcome != i.get('doi'):
                i['notes'] = i.get('notes', '') + f'DOI mismatch, regex returns {outcome}; '
                print('DOI mismatch.')
            else:
                print('DOI match:')
                bibtex = return_bibtex(outcome)
                i['bibtex'] = i.get('bibtex', '') + bibtex
        except TypeError as e:
            print('DOI present but not of the correct type.')
    else:
        print('Trying to pull in new information:')
        if i.get('citation', '') != '' and i.get('articletitle', '') == '' and i.get('booktitle') == '':
            test_text = break_citation(i.get('citation'))[0]
            title = test_text.get('title', [''])[0]
        else:
            title = i.get('articletitle') or i.get('booktitle')
        if title == '':
            continue
        outcome = check_crossref(title)
        if outcome is not None:
            print('New match found.')
            i['newdoi'] = outcome.get('DOI')
            i['json'] = json.dumps(outcome)
        else:
            print('No new match.')

with open('output.csv', 'w') as file:
    writer = csv.DictWriter(file, fieldnames=['publicationid', 'citation', 'doi', 'notes', 'newdoi', 'json', 'bibtex'])
    writer.writeheader()
    for i in db_data:
        row = {j: i.get(j) for j in ['publicationid', 'citation', 'doi', 'notes', 'newdoi', 'json', 'bibtex']}
        writer.writerow(row)
