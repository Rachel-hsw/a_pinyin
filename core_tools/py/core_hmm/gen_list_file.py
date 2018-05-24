#!/usr/bin/env python3.6
# gen_list_file.py, a_pinyin/core_tools/py/core_hmm/
import os, sys


def gen_list_file(src_dir, rel_path):
    o = []
    for i in os.listdir(src_dir):
        d = os.path.join(src_dir, i)
        if not os.path.isdir(d):
            continue
        for j in os.listdir(d):
            f = os.path.join(d, j)
            if os.path.isfile(f):
                o.append(os.path.relpath(f, rel_path))
    return o

def main(args):
    src_dir, out_file = args[0], args[1]

    result = gen_list_file(src_dir, os.path.dirname(out_file))

    print("DEBUG: got " + str(len(result)) + " files in list")
    text = ('\n').join(result) + '\n'
    with open(out_file, 'wt') as f:
        f.write(text)

if __name__ == '__main__':
    main(sys.argv[1:])
