#!/usr/bin/env python3.6
# freq_to_char.py, a_pinyin/core_tools/py/char_count/
import os, sys

import util


def freq_to_char(raw):
    t = {}
    for c in raw['data']:
        f = raw['data'][c]
        if not f in t:
            t[f] = c
        else:
            t[f] += c
    # sort each freq
    for f in t:
        tf = list(t[f])
        tf.sort()
        t[f] = ('').join(tf)
    o = {
        '_last_update': util.last_update(),
        'data': t,
    }
    return o


def main(args):
    input_file, output_file = args[0], args[1]

    data = util.load_json(input_file)
    result = freq_to_char(data)
    util.write_json(output_file, result)

if __name__ == '__main__':
    main(sys.argv[1:])
