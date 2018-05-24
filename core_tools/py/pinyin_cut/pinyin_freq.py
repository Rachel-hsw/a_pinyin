#!/usr/bin/env python3.6
# pinyin_freq.py, a_pinyin/core_tools/py/pinyin_cut/
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


def pinyin_freq(char_count, char_to_pinyin):
    o = {
        'pinyin_freq': {},  # pinyin: freq
        'freq_pinyin': {},  # freq: pinyin
        'count_pinyin': None,
        'pinyin_sort': [],

        # count for pinyin to char
        'pinyin_to_char_count': {},

        '_last_update': '',
    }

    pinyin_to_char = {}

    d = char_count['data']
    p = {}  # pinyin_freq
    for c in d:
        # add each pinyin for this char
        pinyin = char_to_pinyin[c]
        if not isinstance(pinyin, list):
            pinyin = [pinyin]
        for i in pinyin:
            if i in p:
                p[i] += d[c]
            else:
                p[i] = d[c]
            # update pinyin_to_char
            if not i in pinyin_to_char:
                pinyin_to_char[i] = {}
            pinyin_to_char[i][c] = True
    o['pinyin_freq'] = p
    o['count_pinyin'] = len(p)

    # gen pinyin_to_char_count
    ptc = o['pinyin_to_char_count']
    for i in pinyin_to_char:
        l = len(pinyin_to_char[i])
        if not l in ptc:
            ptc[l] = []
        ptc[l].append(i)
    # clean pinyin_to_char
    for i in ptc:
        if len(ptc[i]) == 1:
            ptc[i] = ptc[i][0]

    # gen freq_pinyin
    r = o['freq_pinyin']
    for i in p:
        count = p[i]
        if count in r:
            r[count].append(i)
        else:
            r[count] = [i]
    # gen pinyin_sort
    count = list(r.keys())
    count.sort()
    for i in range(len(count) - 1, -1, -1):
        o['pinyin_sort'] += r[count[i]]

    # simple output
    for i in r:
        if len(r[i]) == 1:
            r[i] = r[i][0]

    o['_last_update'] = last_update()
    return o

def main(args):
    f_char_count, f_char_to_pinyin, f_pinyin_freq = args[0], args[1], args[2]

    char_count = load_json(f_char_count)
    char_to_pinyin = load_json(f_char_to_pinyin)

    o = pinyin_freq(char_count, char_to_pinyin)

    save_json(f_pinyin_freq, o)

if __name__ == '__main__':
    main(sys.argv[1:])
