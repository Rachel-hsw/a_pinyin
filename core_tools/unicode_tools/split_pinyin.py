#!/usr/bin/env python3.6
# split_pinyin.py, a_pinyin/core_tools/unicode_tools/

import os, sys
import json

# input / output file
F_I = '../../unicode_data/base/all_pinyin.json'
F_O = '../../unicode_data/base/split_pinyin.json'


# all knonw Initials list
I_L = [
    'b', 'p', 'm', 'f', 'd', 't', 'n', 'l',
    'g', 'k', 'h', 'j', 'q', 'x',
    'zh', 'ch', 'sh', 'r',
    'z', 'c', 's',
    'y', 'w',
]

# return [Initials, Vowel]
def parse_one_pinyin(raw):
    # check first char
    if not raw[0] in I_L:
        return ['', raw]  # no Initials, just Vowel
    # check 'zh', 'ch', 'sh'
    if (raw[0] in ['z', 'c', 's']) and (raw[1] == 'h'):
        return [ raw[0:2], raw[2:] ]
    # most common pinyin
    return [ raw[0], raw[1:] ]

def split_pinyin(d):
    o = {}
    o['I'] = I_L.copy()
    o['I'].sort()
    # I -> V tree
    o['tree'] = {}
    v = {}
    for p in d['pinyin']:
        r = parse_one_pinyin(p)
        if r[1] != '':
            v[r[1]] = True
        # I-V tree
        if not r[0] in o['tree']:
            o['tree'][r[0]] = { r[1]: True }
        else:
            o['tree'][r[0]][r[1]] = True
    o['V'] = list(v.keys())
    o['V'].sort()
    # I-V tree
    for i in o['tree']:
        o['tree'][i] = list(o['tree'][i].keys())
        o['tree'][i].sort()
    # count
    o['count_I'] = len(o['I'])
    o['count_V'] = len(o['V'])
    return o

def main(args):
    with open(F_I, 'rt') as f:
        raw_text = f.read()
    data = json.loads(raw_text)

    o = split_pinyin(data)
    result = json.dumps(o, sort_keys=True, indent=4, ensure_ascii=False) + '\n'
    with open(F_O, 'wt') as f:
        f.write(result)

if __name__ == '__main__':
    exit(main(sys.argv[1:]))
