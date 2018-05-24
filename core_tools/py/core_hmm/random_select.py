#!/usr/bin/env python3.6
# random_select.py, a_pinyin/core_tools/py/core_hmm/
import os, sys
import random


def random_select(raw, rate):
    o = []
    for i in raw:
        if (len(i.strip()) > 0) and (random.random() < rate):
            o.append(i)
    # DEBUG
    print("DEBUG: raw " + str(len(raw)) + " items, rate " + str(rate) + ", select " + str(len(o)) + ", real rate " + str(len(o) / len(raw)))
    return o

def main(args):
    f_raw, rate, f_out = args[0], float(args[1]), args[2]

    with open(f_raw, 'rt') as f:
        text = f.read()
    result = random_select(text.splitlines(), rate)

    text = ('\n').join(result) + '\n'
    with open(f_out, 'wt') as f:
        f.write(text)

if __name__ == '__main__':
    main(sys.argv[1:])
