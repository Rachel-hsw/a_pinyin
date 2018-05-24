#!/usr/bin/env python3.6
# gen_pinyin_cut.py, a_pinyin/core_tools/py/pinyin_cut/
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


def gen_pinyin_cut(pinyin_freq, pinyin_cut_mm):
    o = {
        'pinyin_sort': pinyin_freq['pinyin_sort'],
        'I': pinyin_cut_mm['I'],
        'A': pinyin_cut_mm['A'],
        'pinyin_freq': pinyin_freq['pinyin_freq'],
        'pinyin_freq_count': 0,

        '_last_update': '',
    }
    # pinyin_freq_count
    for i in o['pinyin_freq']:
        o['pinyin_freq_count'] += o['pinyin_freq'][i]

    o['_last_update'] = last_update()
    return o

def main(args):
    f_pinyin_freq, f_pinyin_cut_mm, f_o = args[0], args[1], args[2]

    pinyin_freq = load_json(f_pinyin_freq)
    pinyin_cut_mm = load_json(f_pinyin_cut_mm)

    o = gen_pinyin_cut(pinyin_freq, pinyin_cut_mm)

    save_json(f_o, o)

if __name__ == '__main__':
    main(sys.argv[1:])
