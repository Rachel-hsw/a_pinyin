#!/usr/bin/env python3.6
# print_result.py, a_pinyin/core_tools/py/core_hmm/
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


def print_result(raw):
    o = {
        'I': {},
        'A': {},
        'count': 0,
    }

    char_map = raw['char_map']
    I = raw['I']
    A = raw['A']
    # I
    for i in range(len(I)):
        o['I'][I[i]] = char_map[i]
    # A
    for i in range(len(char_map)):
        for j in range(len(char_map)):
            if A[i][j] == 0:
                continue
            c = A[i][j]  # trans count
            if not c in o['A']:
                o['A'][c] = []
            o['A'][c].append(char_map[i] + char_map[j])
    # remove < 10,000
    for i in range(0, 10_000):
        if i in o['A']:
            o['A'].pop(i)
    # count A
    for i in o['A']:
        o['count'] += len(o['A'][i])
    # re-shape A
    for i in o['A']:
        if len(o['A'][i]) == 1:
            o['A'][i] = o['A'][i][0]

    o['_last_update'] = last_update()
    return o

def main(args):
    f_result, f_out = args[0], args[1]

    raw = load_json(f_result)
    o = print_result(raw)

    save_json(f_out, o)

if __name__ == '__main__':
    main(sys.argv[1:])
