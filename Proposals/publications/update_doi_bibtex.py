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
from time import sleep
from crossref.restful import Works, Etiquette

csv.field_size_limit(sys.maxsize)


def clean_doi(doi_string:str):
    """_Clean a DOI string_

    Args:
        doi_string (str): _A text string that purportedly contains a DOI._

    Raises:
        Exception: _Raises a TypeError if the object passed is not a string._

    Returns:
        _str_: _A cleaned DOI string._
    """
    if type(doi_string) is not str:
        raise Exception('TypeError', f'The doi passed is not a string.')
    outcome = re.match(r'.*(\b10\.\d{4,9}/[-.;()/:\w]+)', doi_string)
    if outcome is None:
        return None
    else:
        return outcome.group(1)


def break_citation(citation:str):
    """_Break Citation String Apart_
    Args:
        citation (str): _A citation string from the Neotoma Database._
    Raises:
        Exception: _A ValueError exception if the object could not be parsed._
    Returns:
        _dict_: _A dict representation of the anystyle output._
    """    
    with open('/tmp/temp.txt', 'w') as wr:
        wr.write(citation)
    outcome = subprocess.run(['anystyle', '-f', 'json', 'parse', '/tmp/temp.txt'], capture_output = True)
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
    try:
        response = requests.get(url, headers=header, timeout = 10)
    except requests.exceptions.ReadTimeout as e:
        return None
    if response.status_code == 200:
        return response.text.strip()
    else:
        return None


def check_crossref(cite_object:str):
    url = 'https://api.crossref.org/works'
    try:
        url_call = requests.get(url,
                            headers = {'Accept': 'application/json',
                                       'User-Agent': 'Neotoma Publication Augmenter; mailto:goring@wisc.edu'},
                            params = {'rows':1,
                                    'mailto':'goring@wisc.edu',
                                    'select':'DOI,title,container-title,published',
                                    'query':f'query.title={cite_object}'}, timeout = 10)
    except requests.exceptions.ReadTimeout as e:
        return None
    if url_call.status_code == 200:
        cross_ref = json.loads(url_call.content)
        if cross_ref.get('message').get('total-results') > 0:
            return cross_ref.get('message').get('items', '')[0]
        else:
            return None
    else:
        return None


def call_publications():
    """_Get Publications from Neotoma_
    Returns:
        _dict_: _A dictionary of Neotoma Publications_
    """    
    try:
        result = requests.get("https://api.neotomadb.org/v2.0/data/publications?limit=100000", timeout = 10)
    except requests.exceptions.ReadTimeout as e:
        return None
    if result.status_code == 200:
        pubs = json.loads(result.content).get('data').get('result')
        return pubs
    else:
        return None


db_data = [i.get('publication') for i in call_publications()]

# For each row
for i in db_data:
    print(f'publicationid: {i.get('publicationid')}')
    if any([j in ['bibtex', 'newdoi', 'json'] for j in i.keys()]):
        continue
    if i.get('doi', '') or '' != '':
        try:
            outcome = clean_doi(i.get('doi'))
            if outcome != i.get('doi'):
                i['notes'] = i.get('notes', '') + f'DOI mismatch, regex returns {outcome}; '
                print('DOI mismatch.')
            else:
                print('DOI match:')
                bibtex = return_bibtex(outcome)
                if bibtex is None:
                    print(f'Issue with DOI {outcome}')
                    i['notes'] = (i.get('notes', '') or '') + f' CrossRef DOI does not exists; '
                else:
                    i['bibtex'] = bibtex
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
            bibtex = return_bibtex(outcome.get('DOI'))
            i['bibtex'] = i.get('bibtex', '') + bibtex
        else:
            print('No new match.')


with open('output.csv', 'w') as file:
    writer = csv.DictWriter(file, fieldnames=['publicationid', 'citation', 'doi', 'notes', 'newdoi', 'json', 'bibtex'])
    writer.writeheader()
    for i in db_data:
        row = {j: i.get(j) for j in ['publicationid', 'citation', 'doi', 'notes', 'newdoi', 'json', 'bibtex']}
        writer.writerow(row)

