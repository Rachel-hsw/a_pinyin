#!/usr/bin/env python3.6
# print_symbol2.py, a_pinyin/core_tools/py/core_symbol2/
import os, sys
import json


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


def print_symbol2(raw, max_i):
    d = raw['data']
    c = [i for i in d]
    c.sort(key = lambda x: - d[x])

    o = {}

    count = 1
    for i in c:
        print(str(count) + '\t' + i + '\t' + str(d[i]))

        o[i] = d[i]
        count += 1
        if count > max_i:
            break
    return o

def main(args):
    f_char_count, f_o_count = args[0], args[1]

    raw = load_json(f_char_count)
    o = print_symbol2(raw, 74)  # TODO 74 ? or 64 ?

    save_json(f_o_count, o)

if __name__ == '__main__':
    main(sys.argv[1:])
