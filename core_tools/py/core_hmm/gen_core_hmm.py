#!/usr/bin/env python3.6
# gen_core_hmm.py, a_pinyin/core_tools/py/core_hmm/
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


def gen_core_hmm(char_to_pinyin, pinyin_freq, hmm_args):
    o = {
      'char_to_pinyin': {},
      'pinyin_sort': [],

      'char_map': hmm_args['char_map'],
      'I': hmm_args['I'],
      'A': hmm_args['A'],
    }
    # gen pinyin_set and pinyin_sort
    char_map = o['char_map'][2:]  # remove first 'Ex'

    pinyin_set = {}
    for c in char_map:
        p = char_to_pinyin[c]
        if not isinstance(p, list):
            p = [p]
        # gen char_to_pinyin
        o['char_to_pinyin'][c] = p

        for pinyin in p:
            pinyin_set[pinyin] = True
    for pinyin in pinyin_freq['pinyin_sort']:
        if pinyin in pinyin_set:
            o['pinyin_sort'].append(pinyin)

    o['_last_update'] = last_update()
    return o


def main(args):
    f_char_to_pinyin, f_pinyin_freq, f_hmm_args, f_o = args[0], args[1], args[2], args[3]

    char_to_pinyin = load_json(f_char_to_pinyin)
    pinyin_freq = load_json(f_pinyin_freq)
    hmm_args = load_json(f_hmm_args)

    o = gen_core_hmm(char_to_pinyin, pinyin_freq, hmm_args)

    save_json(f_o, o)

if __name__ == '__main__':
    main(sys.argv[1:])
