#!/usr/bin/env python3.6
# count_A.py, a_pinyin/core_tools/py/core_hmm/
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


def count_a(raw):
    o = {
        'count': {},
        'rate': {},
    }
    # init o
    o['count']['  >0'] = 0  # add one special
    for i in range(0, 8):
        for j in range(1, 10):
            n = j * (10 ** i)
            o['count'][str(i) + ' >' + str(n)] = 0
    o['count']['all'] = 0

    A = raw['A']
    for k in range(len(A)):
        # DEBUG
        print(" " + str(k) + " / " + str(len(A)))
        for l in range(len(A)):
            d = A[k][l]
            # check for >0
            if d > 0:
                o['count']['  >0'] += 1
            for i in range(0, 8):
                for j in range(1, 10):
                    n = j * (10 ** i)
                    if d > n:
                        o['count'][str(i) + ' >' + str(n)] += 1
            o['count']['all'] += 1
    # rate
    for i in o['count']:
        o['rate'][i] = o['count'][i] / o['count']['all']

    o['_last_update'] = last_update()
    return o

def main(args):
    f_raw, f_o = args[0], args[1]

    raw = load_json(f_raw)
    o = count_a(raw)

    save_json(f_o, o)

if __name__ == '__main__':
    main(sys.argv[1:])
