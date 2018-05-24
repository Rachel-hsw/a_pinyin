#!/usr/bin/env python3.6
# h_chars.py, a_pinyin/core_tools/py/h_chinese/
import os, sys
import math
import json


def load_json(filename):
    with open(filename, 'rb') as f:
        text = f.read().decode('utf-8')
    return json.loads(text)


def calc_h(char_count, char_list):
    all_char = len(char_list)
    print('DEBUG: ' + str(all_char) + ' unique chars')

    count = 0
    for i in char_list:
        count += char_count[i]
    print('DEBUG: ' + str(count) + ' chars')

    # calc H()
    h = 0
    for i in char_list:
        p = char_count[i] / count
        h -= p * math.log(p, 2)
    print('DEBUG: H = ' + str(h) + ' bit')

    return h


def main(args):
    f_char_count, f_char_sort = args[0], args[1]

    char_count = load_json(f_char_count)
    char_sort = load_json(f_char_sort)

    # calc class A, B, C, D
    print('\nDEBUG: class A')
    calc_h(char_count['data'], char_sort['a'])

    print('\nDEBUG: class B')
    calc_h(char_count['data'], char_sort['b'])

    print('\nDEBUG: class C')
    calc_h(char_count['data'], char_sort['c'])

    print('\nDEBUG: class D')
    calc_h(char_count['data'], char_sort['d'])

    print('\nDEBUG: class A + B')
    calc_h(char_count['data'], char_sort['a'] + char_sort['b'])

    print('\nDEBUG: class A + B + C')
    calc_h(char_count['data'], char_sort['a'] + char_sort['b'] + char_sort['c'])

    print('\nDEBUG: class A + B + C + D')  # can not calc class E
    calc_h(char_count['data'], char_sort['a'] + char_sort['b'] + char_sort['c'] + char_sort['d'])

if __name__ == '__main__':
    main(sys.argv[1:])
