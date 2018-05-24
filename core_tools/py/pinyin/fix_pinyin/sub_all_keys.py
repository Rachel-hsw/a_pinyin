#!/usr/bin/env python3.6
# sub_all_keys.py, a_pinyin/core_tools/py/pinyin/fix_pinyin/
import os, sys
import json


def sub_all_keys(raw):
    # keys and count
    d = raw['data']
    c = {}
    for char in d:
        for i in d[char]:
            # FIXME
            if not 'title' in i:
                print("FIXME: " + char + ' ' + str(i))

            k = i['title']
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
    # count of merge
    cm = {}
    for i in o:
        cm[i] = len(o[i])

    return {
        'merge': o,
        'count': c,

        'merge_count': cm
    }


def main(args):
    f_data = args[0]

    # load json file
    with open(f_data, 'rt') as f:
        text = f.read()
    raw = json.loads(text)

    result = sub_all_keys(raw)
    text = json.dumps(result, indent=4, sort_keys=True, ensure_ascii=False)
    # print result
    print(text)

if __name__ == '__main__':
    main(sys.argv[1:])
