#!/usr/bin/env python3.6
# char_count_simple.py, a_pinyin/core_tools/py/char_count/
import os, sys

import util


# output file
OUT_CHAR_ASCII = 'char_count_ascii.json'
OUT_CHAR_CHINESE = 'char_count_chinese.json'
OUT_CHAR_OTHER = 'char_count_other.json'


CHAR_ASCII_MAX = 127

def count(raw, char):
    o = {
        'ascii': {},
        'chinese': {},
        'other': {},
    }
    for c in raw['data']:
        # check is ascii char
        if ord(c) <= CHAR_ASCII_MAX:
            o['ascii'][c] = raw['data'][c]
        # check is chinese char
        elif c in char:
            o['chinese'][c] = raw['data'][c]
        # other char
        else:
            o['other'][c] = raw['data'][c]
    return o


def save_result(filename, data):
    o = {
        '_last_update': last_update(),
        '_meta': {
            'char': len(list(data.keys())),
            'count': sum(list(data.values())),
        },
        'data': data,
    }
    util.write_json(filename, o)

def main(args):
    raw_count, char_file, out_dir = args[0], args[1], args[2]

    raw = util.load_json(raw_count)
    char = util.load_json(char_file)
    result = count(raw, char)
    # save result
    save_result(os.path.join(out_dir, OUT_CHAR_ASCII), result['ascii'])
    save_result(os.path.join(out_dir, OUT_CHAR_CHINESE), result['chinese'])
    save_result(os.path.join(out_dir, OUT_CHAR_OTHER), result['other'])

if __name__ == '__main__':
    main(sys.argv[1:])
