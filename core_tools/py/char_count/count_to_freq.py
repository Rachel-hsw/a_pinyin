#!/usr/bin/env python3.6
# count_to_freq.py, a_pinyin/core_tools/py/char_count/
import os, sys

import util


def count_to_freq(raw):
    d = {int(i): raw['data'][i] for i in raw['data']}
    k = list(d.keys())
    k.sort()
    o = {}

    count_char = 0
    count_freq = 0
    for i in k[::-1]:
        count_char += len(d[i])
        count_freq += i * len(d[i])
        o[count_char] = count_freq
    oo = {
        '_last_update': util.last_update(),
        'data': o,
    }
    return oo

def make_csv(data):
    o = []
    # title line
    l = 'char_count,char_freq'
    o.append(l)
    # each data item
    k = list(data.keys())
    k.sort()
    for i in k:
        l = str(i) + ',' + str(data[i])
        o.append(l)
    return ('\n').join(o) + '\n'


def main(args):
    data_file, result_file, csv_file = args[0], args[1], args[2]
    data = util.load_json(data_file)
    result = count_to_freq(data)
    util.write_json(result_file, result)
    # save .csv file
    text = make_csv(result['data'])
    util.write_replace(csv_file, text.encode('utf-8'))

if __name__ == '__main__':
    main(sys.argv[1:])
