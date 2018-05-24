#!/usr/bin/env python3.6
# clean_count.py, a_pinyin/core_tools/py/core_hmm/
import os, sys
import json
import datetime


def last_update():
    return datetime.datetime.utcnow().isoformat() + 'Z'

def load_json(filename):
    with open(filename, 'rb') as f:
        text = f.read().decode('utf-8')
    return json.loads(text)

def save_json(filename, data, tmp_suffix = '.tmp'):
    tmp = filename + tmp_suffix
    #text = json.dumps(data, indent=4, sort_keys=True, ensure_ascii=False) + '\n'
    text = json.dumps(data, sort_keys=True, ensure_ascii=False) + '\n'
    with open(tmp, 'wb') as f:
        f.write(text.encode('utf-8'))
    os.replace(tmp, filename)


CLEAN_LIMIT = 90  # result of count_A.py

def clean_count(raw):
    o = {
        'char_map': raw['char_map'],
        'I': raw['I'],
        'A': raw['A'],
        'al': [],  # count of each A line
    }
    # clean A
    for i in range(len(o['A'])):
        for j in range(len(o['A'])):
            if o['A'][i][j] < CLEAN_LIMIT:
                o['A'][i][j] = 0
    # count A
    for i in range(len(o['A'])):
        count = 0
        for j in range(len(o['A'])):
            count += o['A'][i][j]
        o['al'].append(count)

    o['_last_update'] = last_update()
    return o

def main(args):
    f_raw, f_o = args[0], args[1]

    raw = load_json(f_raw)
    o = clean_count(raw)

    save_json(f_o, o)

if __name__ == '__main__':
    main(sys.argv[1:])
