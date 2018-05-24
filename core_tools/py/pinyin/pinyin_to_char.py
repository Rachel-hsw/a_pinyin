#!/usr/bin/env python3.6
# pinyin_to_char.py, a_pinyin/core_tools/py/pinyin/
#
import os, sys
import math, json
import datetime


CLASS_LIST = [
    'a',
    'b',
    'c',
    'd',
    'e'
]


def process_one_class(o, class_name, raw, char_to_pinyin):
    for c in raw:
        pinyin = char_to_pinyin[c]
        # process multi pinyin
        if type(pinyin) != list:
            pinyin = [pinyin]
        for p in pinyin:
            if not p in o:
                o[p] = {}
            if not class_name in o[p]:
                o[p][class_name] = ''
            o[p][class_name] += c
    return o


def pinyin_to_char(char_to_pinyin, char_sort):
    o = {}

    for c in CLASS_LIST:
        process_one_class(o, c, char_sort[c], char_to_pinyin)

    o['_last_update'] = last_update()
    return o


def last_update():
    return datetime.datetime.utcnow().isoformat() + 'Z'

def load_json(name):
    with open(name, 'rb') as f:
        text = f.read().decode('utf-8')
    return json.loads(text)

def save_json(name, data):
    text = json.dumps(data, indent=4, sort_keys=True, ensure_ascii=False) + '\n'
    with open(name, 'wb') as f:
        f.write(text.encode('utf-8'))


def main(args):
    f_char_to_pinyin, f_char_sort, f_pinyin_to_char = args[0], args[1], args[2]

    char_to_pinyin = load_json(f_char_to_pinyin)
    char_sort = load_json(f_char_sort)

    result = pinyin_to_char(char_to_pinyin, char_sort)
    save_json(f_pinyin_to_char, result)

if __name__ == '__main__':
    main(sys.argv[1:])
