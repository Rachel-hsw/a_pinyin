#!/usr/bin/env python3.6
# gen_core_freq.py, a_pinyin/core_tools/py/core_freq/
import os, sys
import json
import datetime

def last_update():
    return datetime.datetime.utcnow().isoformat() + 'Z'

def gen_core_freq(char_count, pinyin_to_char):
    o = {
        'char_count': {
            'char': 0,
            'count': 0,
            'data': {},
        },
        'pinyin_to_char': {
            # 'PINYIN': {
            #     'a': '',
            #     'b': '',
            #     'c': '',
            #     'd': '',
            #     'e': '',
            # }
        },
    }
    # char_count
    o['char_count']['char'] = char_count['_meta']['char']
    o['char_count']['count'] = char_count['_meta']['count']
    o['char_count']['data'] = char_count['data']
    # pinyin_to_char
    o['pinyin_to_char'] = pinyin_to_char
    o['pinyin_to_char'].pop('_last_update')

    o['_last_update'] = last_update()
    return o


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

def main(args):
    f_char_count, f_pinyin_to_char, f_o = args[0], args[1], args[2]

    char_count = load_json(f_char_count)
    pinyin_to_char = load_json(f_pinyin_to_char)

    o = gen_core_freq(char_count, pinyin_to_char)

    save_json(f_o, o)

if __name__ == '__main__':
    main(sys.argv[1:])
