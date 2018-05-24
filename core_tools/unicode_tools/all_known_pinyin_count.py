#!/usr/bin/env python3.6
# all_known_pinyin_count.py, a_pinyin/core_tools/unicode_tools/

import os, sys
import json

# input / output file
F_I = '../../unicode_data/base/raw_pinyin.json'
F_O = '../../unicode_data/base/all_pinyin.json'
F_O_C2P = '../../unicode_data/base/char_to_pinyin.json'
F_O_P2C = '../../unicode_data/base/pinyin_to_char.json'


def count(d):
    o = {}
    o['count_chars'] = len(d)
    # DEBUG
    print('DEBUG: count ' + str(o['count_chars']) + ' chars ')
    # count all pinyin
    all_pinyin_count = 0
    # remove save pinyin for all chars
    pinyin = {}
    for i in d:
        for p in i['pinyin']:
            all_pinyin_count += 1
            pinyin[p] = True
    o['count_all_pinyin'] = all_pinyin_count
    o['rate_all_pinyin'] = all_pinyin_count / len(d)
    pinyin = list(pinyin.keys())
    pinyin.sort()
    o['pinyin'] = pinyin
    o['count_pinyin'] = len(pinyin)
    o['rate_pinyin'] = len(d) / len(pinyin)
    print('DEBUG: all pinyin count ' + str(all_pinyin_count) + ' (' + str(o['rate_all_pinyin']) + '), pinyin count ' + str(o['count_pinyin']) + ' (' + str(o['rate_pinyin']) + ')')
    return o

def char_to_pinyin(d):
    o = {}
    for i in d:
        c = i['char']
        pinyin = {}
        for p in i['pinyin']:
            pinyin[p] = True
        pinyin = list(pinyin.keys())
        pinyin.sort()
        if len(pinyin) == 1:
            o[c] = pinyin[0]
        else:
            o[c] = pinyin
    return o

def pinyin_to_char(d):
    o = {}
    for i in d:
        c = i['char']
        for p in i['pinyin']:
            if not p in o:
                o[p] = [c]
            else:
                o[p].append(c)
    # sort pinyin
    for p in o:
        char = {}
        for c in o[p]:
            char[c] = True
        char = list(char.keys())
        char.sort()  # sort with unicode
        # merge chars to str
        o[p] = ('').join(char)
    return o

def u_range(d):
    s = {}
    for i in d:
        s[i['code']] = True
    ss = list(s.keys())
    ss.sort()

    o = []
    # check unicode range
    r = None
    for i in ss:
        if r == None:
            r = [i]
        elif len(r) == 1:
            if i == r[0] + 1:
                r.append(i)
            else:  # reset range
                o.append(r[0])
                # DEBUG
                #print('DEBUG: 1')
                r = [i]
        else:  # len(r) == 2
            if i == r[1] + 1:
                r[1] = i
            else:  # reset range
                o.append(r)
                # DEBUG
                l = r[1] - r[0] + 1
                if l > 10:
                    print('DEBUG: ' + str(l))

                r = [i]
    # add last range
    o.append(r)
    return o


def main(args):
    with open(F_I, 'rt') as f:
        raw_text = f.read()
    data = json.loads(raw_text)

    o = count(data)
    #u = u_range(data)
    #o['u_range'] = u
    def write_result(fi, data):
        result = json.dumps(data, sort_keys=True, indent=4, ensure_ascii=False) + '\n'
        with open(fi, 'wt') as f:
            f.write(result)
    write_result(F_O, o)
    # char -> pinyin, pinyin -> char
    o = char_to_pinyin(data)
    write_result(F_O_C2P, o)
    o = pinyin_to_char(data)
    write_result(F_O_P2C, o)

if __name__ == '__main__':
    exit(main(sys.argv[1:]))
