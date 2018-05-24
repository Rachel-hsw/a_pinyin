#!/usr/bin/env python3.6
# correct_pinyin_2.py, a_pinyin/core_tools/py/pinyin/correct_pinyin/
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


def correct_pinyin(char_to_pinyin, correct):
    # correct class A
    a = correct['a']
    o = char_to_pinyin
    for i in a:
        o[i] = a[i]
    return o

def main(args):
    f_char_to_pinyin, f_correct, f_o = args[0], args[1], args[2]

    char_to_pinyin = load_json(f_char_to_pinyin)
    correct = load_json(f_correct)

    result = correct_pinyin(char_to_pinyin, correct)
    save_json(f_o, result)

if __name__ == '__main__':
    main(sys.argv[1:])
