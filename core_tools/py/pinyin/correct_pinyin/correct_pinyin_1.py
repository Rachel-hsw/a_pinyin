#!/usr/bin/env python3.6
# correct_pinyin_1.py, a_pinyin/core_tools/py/pinyin/correct_pinyin/
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
    text = json.dumps(data, indent=4, sort_keys=True, ensure_ascii=False) + '\n'
    #text = json.dumps(data, sort_keys=True, ensure_ascii=False) + '\n'
    with open(tmp, 'wb') as f:
        f.write(text.encode('utf-8'))
    os.replace(tmp, filename)


def correct_pinyin(char_to_pinyin, char_sort):
    o = {
        'a': {},
        'b': {},
    }
    # only for A, B class chars
    a = char_sort['a']
    b = char_sort['b']

    for c in char_to_pinyin:
        # check multi-pinyin
        p = char_to_pinyin[c]
        if not isinstance(p, list):
            continue

        # check A, B
        if c in a:
            o['a'][c] = p
        elif c in b:
            o['b'][c] = p
    o['_last_update'] = last_update()
    return o

def main(args):
    f_char_to_pinyin, f_char_sort, f_o = args[0], args[1], args[2]

    char_to_pinyin = load_json(f_char_to_pinyin)
    char_sort = load_json(f_char_sort)

    result = correct_pinyin(char_to_pinyin, char_sort)
    save_json(f_o, result)

if __name__ == '__main__':
    main(sys.argv[1:])
