#!/usr/bin/env python3.6
# all_keys.py, a_pinyin/core_tools/py/pinyin/fix_pinyin/
import os, sys
import json


def all_keys(raw):
    # keys and count
    d = raw['data']
    c = {}
    for i in d:
        for k in d[i]:
            if k in c:
                c[k] += 1
            else:
                c[k] = 1
    # merge result
    o = {}
    for i in c:
        if c[i] in o:
            if isinstance(o[c[i]], list):
                o[c[i]].append(i)
            else:
                o[c[i]] = [o[c[i]], i]
        else:
            o[c[i]] = i
    return {
        'merge': o,
        'count': c,
    }


def main(args):
    f_data = args[0]

    # load json file
    with open(f_data, 'rt') as f:
        text = f.read()
    raw = json.loads(text)

    result = all_keys(raw)
    text = json.dumps(result, indent=4, sort_keys=True, ensure_ascii=False)
    # print result
    print(text)

if __name__ == '__main__':
    main(sys.argv[1:])
