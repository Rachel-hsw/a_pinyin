#!/usr/bin/env python3.6
# freq_a_char.py, a_pinyin/core_tools/py/char_count/
import os, sys

import util


def freq_a_char(data, f):
    d = data['data']
    k = [int(i) for i in list(d.keys())]
    k.sort()
    o = ''
    for i in k[::-1]:
        if i >= f:
            o += d[str(i)]
        else:
            break
    return o


def main(args):
    data_file, f = args[0], args[1]
    f = int(f)
    data = util.load_json(data_file)

    result = freq_a_char(data, f)
    print(result)

if __name__ == '__main__':
    main(sys.argv[1:])
