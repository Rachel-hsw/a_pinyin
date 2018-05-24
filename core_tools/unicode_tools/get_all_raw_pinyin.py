#!/usr/bin/env python3.6
# get_all_raw_pinyin.py, a_pinyin/core_tools/unicode_tools/
#
import os, sys
import json


# input / output file
F_I = '../../unicode_data/Unihan/Unihan_Readings.txt'
F_O = '../../unicode_data/base/raw_pinyin.json'


def parse_one(line):
    p = line.split('\t', 2)

    # check line type
    if p[1] == 'kMandarin':
        pinyin_raw = [i.strip() for i in p[2].split(' ')]
        pinyin_raw = [i for i in pinyin_raw if i != '']
    elif p[1] == 'kHanyuPinlu':
        pinyin_raw = [i.strip() for i in p[2].split(' ')]
        pinyin_raw = [i for i in pinyin_raw if i != '']
        pinyin_raw = [i.split('(')[0].strip() for i in pinyin_raw]
    elif p[1] == 'kHanyuPinyin':
        pinyin_raw = [i.strip() for i in p[2].split(' ')]
        pniyin_raw = [i for i in pinyin_raw if i != '']

        pinyin_raw = [i.split(':', 1)[1].split(',') for i in pinyin_raw]
        pinyin_raw = [j.strip() for i in pinyin_raw for j in i]
        pinyin_raw = [i for i in pinyin_raw if i != '']
    else:
        return None  # ignore this line
    # create one item
    code_u = p[0]
    code = int(code_u.split('+', 1)[1], 16)
    char = chr(code)
    o = {
        'code': code,
        'char': char,
        'code_u': code_u,
        'pinyin_raw': pinyin_raw
    }
    return o

def parse(raw_text):
    o = []
    for l in raw_text.splitlines():
        # ignore comment and empty line
        if l.startswith('#') or (l.strip() == ''):
            continue
        one = parse_one(l.strip())  # one line
        if one != None:
            o.append(one)
    return o


# all pinyin chars
ALL_C = [
    ' ',
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'w', 'x', 'y', 'z',
    'à', 'á', 'è', 'é', 'ì', 'í', 'ò', 'ó', 'ù', 'ú', 'ü',
    'ā', 'ē', 'ě', 'ī', 'ń', 'ň', 'ō', 'ū', 'ǎ', 'ǐ', 'ǒ', 'ǔ', 'ǘ', 'ǚ', 'ǜ', 'ǹ', 'ḿ',
    '̀', '̄', '̌',
    'ế', 'ê', 'ề',
]
# bad pinyin chars
B_C = [' ', '.', ':']
# ignore pinyin chars
I_C = ['̀', '̄', '̌']
# translate chars
T_C = {
    'ā': 'a', 'á': 'a', 'ǎ': 'a', 'à': 'a',
    'ō': 'o', 'ó': 'o', 'ǒ': 'o', 'ò': 'o',
    'ē': 'e', 'é': 'e', 'ě': 'e', 'è': 'e', 'ế': 'e', 'ê': 'e', 'ề': 'e',
    'ī': 'i', 'í': 'i', 'ǐ': 'i', 'ì': 'i',
    'ū': 'u', 'ú': 'u', 'ǔ': 'u', 'ù': 'u',
    'ü': 'v', 'ǘ': 'v', 'ǚ': 'v', 'ǜ': 'v',
    'ń': 'n', 'ň': 'n', 'ǹ': 'n',
    'ḿ': 'm',
}

def parse_pinyin(o):
    # for DEBUG
    def p_i(i):
        return json.dumps(i, sort_keys=True, ensure_ascii=False)

    for i in o:
        raw_list = []
        for s in i['pinyin_raw']:
            s = s.strip()
            if (s != '') and (not s in raw_list):
                raw_list.append(s)
        # process each pinyin
        pinyin = {}
        for raw in raw_list:
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
                # check ignore char
                if c in I_C:
                    continue
                one += T_C.get(c, c)
            # check one pinyin
            for c in one:
                if (ord(c) < ord('a')) or (ord(c) > ord('z')):
                    print('DEBUG: bad result pinyin [' + one + '] for item ' + p_i(i))
            pinyin[one] = True  # remove same pinyin for same char
        # set pinyin result
        i['pinyin'] = list(pinyin.keys())
        i['pinyin_raw'] = None  # remove raw data
    return o

def merge_pinyin(raw):
    index = {}
    for i in raw:
        c = i['code']
        if c in index:
            index[c]['pinyin'] += i['pinyin']
        else:
            index[c] = i
    # merge pinyin
    for i in index:
        pinyin = {}
        for p in index[i]['pinyin']:
            pinyin[p] = True
        pinyin = list(pinyin.keys())
        pinyin.sort()  # sort pinyin
        index[i]['pinyin'] = pinyin
        # DEBUG
        if len(pinyin) > 1:
            print('DEBUG: char with more than one pinyin ' + str(index[i]))
    code = list(index.keys())
    code.sort()
    return [index[i] for i in code]


def main(args):
    with open(F_I, 'rt') as f:
        raw_text = f.read()

    o = parse(raw_text)
    o = parse_pinyin(o)
    o = merge_pinyin(o)
    # DEBUG
    print('DEBUG: count = ' + str(len(o)))

    text = json.dumps(o, indent=4, sort_keys=True, ensure_ascii=False) + '\n'
    with open(F_O, 'wb') as f:
        f.write(text.encode('utf-8'))

if __name__ == '__main__':
    main(sys.argv[:])
