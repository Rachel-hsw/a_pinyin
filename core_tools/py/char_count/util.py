# util.py, a_pinyin/core_tools/py/char_count/
import os, sys

import json
import datetime


WRITE_REPLACE_SUFFIX = '.tmp'


def load_json(filename):
    with open(filename, 'rb') as f:
        text = f.read().decode('utf-8')
    return json.loads(text)

def write_replace(filename, blob):
    tmp_file = filename + WRITE_REPLACE_SUFFIX
    with open(tmp_file, 'wb') as f:
        f.write(blob)
    os.rename(tmp_file, filename)

def write_json(filename, data):
    text = json.dumps(data, indent=4, sort_keys=True, ensure_ascii=False) + '\n'
    write_replace(filename, text.encode('utf-8'))

def last_update():
    return datetime.datetime.utcnow().isoformat() + 'Z'
