#!/usr/bin/env python3.6
# raw_pinyin_mandarin.py, a_pinyin/core_tools/unicode_tools/

import os, sys
import json

# input / output file
F_I = '../../unicode_data/Unihan/Unihan_Readings.txt'
F_O = '../../unicode_data/base/raw_pinyin.json'


def parse_one(line):
    p = line.split('\t', 2)
    if p[1] != 'kMandarin':
        return None  # ignore this line
    # create one item
    code_u = p[0]
    pinyin_raw = p[2]
    code = int(code_u.split('+', 1)[1], 16)
    char = chr(code)
    o = {
        'code': code,
        'char': char,
        'code_u': code_u,
        'pinyin_raw': pinyin_raw,
    }
    return o

def parse(raw_text):
    o = []
    lines = raw_text.splitlines()
    for l in lines:
        # ignore comment and empty line
        if l.startswith('#') or (l.strip() == ''):
            continue
        one = parse_one(l)  # parse one line
        if one != None:
            o.append(one)
    return o

def parse_pinyin(o):
    # all pinyin chars
    ALL_C = [
        ' ',
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'w', 'x', 'y', 'z',
        'à', 'á', 'è', 'é', 'ì', 'í', 'ò', 'ó', 'ù', 'ú', 'ü',
        'ā', 'ē', 'ě', 'ī', 'ń', 'ň', 'ō', 'ū', 'ǎ', 'ǐ', 'ǒ', 'ǔ', 'ǘ', 'ǚ', 'ǜ', 'ǹ', 'ḿ',
    ]
    # bad pinyin chars
    B_C = [' ']
    # translate chars
    T_C = {
        'ā': 'a', 'á': 'a', 'ǎ': 'a', 'à': 'a',
        'ō': 'o', 'ó': 'o', 'ǒ': 'o', 'ò': 'o',
        'ē': 'e', 'é': 'e', 'ě': 'e', 'è': 'e',
        'ī': 'i', 'í': 'i', 'ǐ': 'i', 'ì': 'i',
        'ū': 'u', 'ú': 'u', 'ǔ': 'u', 'ù': 'u',
        'ü': 'v', 'ǘ': 'v', 'ǚ': 'v', 'ǜ': 'v',
        'ń': 'n', 'ň': 'n', 'ǹ': 'n',
        'ḿ': 'm',
    }

    def p_i(i):
        return json.dumps(i, sort_keys=True, ensure_ascii=False)

    for i in o:
        r = i['pinyin_raw']
        # get list of each pinyin
        raw_list = []
        for s in r.split(' '):
            s = s.strip()
            if s != '':
                raw_list.append(s)
        # process each pinyin
        pinyin = {}
        for raw in raw_list:
            raw = raw.strip()
            # check empty
            if raw == '':
                print('WARNING: empty pinyin for item ' + p_i(i))
                continue
            # check bad chars
            b_c = False
            for c in raw:
                if c in B_C:
                    # DEBUG
                    print('DEBUG: bad char [' + c + '] in [' + raw + ']')
                    b_c = True
                    break
            if b_c:
                print('WARNING: bad pinyin char in item ' + p_i(i))
                continue
            # check unknow char
            for c in raw:
                if not c in ALL_C:
                    print('WARNING: unknow pinyin char [' + c + '] in item ' + p_i(i))
            # translate chars
            one = ''
            for c in raw:
                one += T_C.get(c, c)
            # check one pinyin
            if one.strip() == '':
                # DEBUG
                print('DEBUG: empty pinyin for item ' + p_i(i))
            for c in one:
                if (ord(c) < ord('a')) or (ord(c) > ord('z')):
                    print('DEBUG: bad result pinyin [' + one + '] for item ' + p_i(i))
            pinyin[one] = True  # remove same pinyin for same char
        # set pinyin result
        i['pinyin'] = list(pinyin.keys())
        # DEBUG
        if len(i['pinyin']) > 1:
            print('DEBUG: char with more than one pinyin ' + str(i))
    return o

def main(args):
    with open(F_I, 'rt') as f:
        raw_text = f.read()
    o = parse(raw_text)
    # DEBUG
    print('DEBUG: count = ' + str(len(o)))

    o = parse_pinyin(o)
    result = json.dumps(o, sort_keys=True, indent=4, ensure_ascii=False) + '\n'
    with open(F_O, 'wt') as f:
        f.write(result)

if __name__ == '__main__':
    exit(main(sys.argv[1:]))
