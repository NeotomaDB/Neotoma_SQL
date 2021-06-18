import hashlib
import json
import requests
from requests.exceptions import HTTPError
import time
import yaml
from lib.pgBackup import backup_database
import lib.figShare as fs

# The following two functions are drawn from this code on StackOverflow:
# https://stackoverflow.com/a/39999652/14302148

token = '<insert access token here>'
FILE_PATH = '/path/to/work/directory/cat.obj'

TITLE = 'A 3D cat object model'

article_id = fs.create_article(TITLE, token)

# Then we upload the file.
file_info = fs.initiate_new_upload(article_id, FILE_PATH, token)

# Until here we used the figshare API; following lines use the figshare upload service API.
fs.upload_parts(file_info=file_info, token=token, file_path=FILE_PATH)

# We return to the figshare API to complete the file upload process.
fs.complete_upload(article_id, file_info['id'])
