import hashlib
import json
import os
import requests
from requests.exceptions import HTTPError

def raw_issue_request(method, url, token, data=None, binary=False):
    headers = {'Authorization': 'token ' + token}
    if data is not None and not binary:
        data = json.dumps(data)
    response = requests.request(method, url, headers=headers, data=data)
    try:
        response.raise_for_status()
        try:
            data = json.loads(response.content)
        except ValueError:
            data = response.content
    except HTTPError as error:
        print('Caught an HTTPError: %s', str(error))
        print ('Body:\n', response.content)
        raise

    return data


def issue_request(method, endpoint, 
                  *args, **kwargs):
    baseurl='https://api.figshare.com/v2/{endpoint}'
    return raw_issue_request(method, baseurl.format(endpoint=endpoint), *args, **kwargs)


def create_article(title, token):
    data = {
        'title': title  # You may add any other information about the article here as you wish.
    }
    result = issue_request('POST', 'account/articles', data=data)
    print('Created article:', result['location'], '\n')

    result = raw_issue_request('GET', result['location'], token)

    return result['id']


def list_files_of_article(article_id):
    result = issue_request('GET', 'account/articles/{}/files'.format(article_id))
    print('Listing files for article {}:'.format(article_id))
    if result:
        for item in result:
            print('  {id} - {name}'.format(**item))
    else:
        print('  No files.')

    print


def get_file_check_data(file_name):
    chunkSize = 1048576
    with open(file_name, 'rb') as fin:
        md5 = hashlib.md5()
        size = 0
        data = fin.read(chunkSize)
        while data:
            size += len(data)
            md5.update(data)
            data = fin.read(chunkSize)
        return md5.hexdigest(), size


def initiate_new_upload(article_id, file_name, token):
    endpoint = 'account/articles/{}/files'
    endpoint = endpoint.format(article_id)

    md5, size = get_file_check_data(file_name)
    data = {'name': os.path.basename(file_name),
            'md5': md5,
            'size': size}

    result = issue_request('POST', endpoint, data=data)
    print('Initiated file upload:', result['location'], '\n')

    result = raw_issue_request('GET', result['location'], token)

    return result


def complete_upload(article_id, file_id):
    issue_request('POST', 'account/articles/{}/files/{}'.format(article_id, file_id))


def upload_parts(file_info, token, file_path):
    url = '{upload_url}'.format(**file_info)
    result = raw_issue_request('GET', url, token)

    print('Uploading parts:')
    with open(file_path, 'rb') as fin:
        for part in result['parts']:
            upload_part(file_info, fin, part, token)
    print


def upload_part(file_info, stream, part, token):
    udata = file_info.copy()
    udata.update(part)
    url = '{upload_url}/{partNo}'.format(**udata)

    stream.seek(part['startOffset'])
    data = stream.read(part['endOffset'] - part['startOffset'] + 1)

    raw_issue_request('PUT', url, token, data=data, binary=True)
    print ('  Uploaded part {partNo} from {startOffset} to {endOffset}'.format(**part))
