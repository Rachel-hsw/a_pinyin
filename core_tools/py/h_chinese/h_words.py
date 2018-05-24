#!/usr/bin/env python3.6
# h_words.py, a_pinyin/core_tools/py/h_chinese/
import os, sys
import math
import sqlite3


def calc_h(c):
    c.execute('SELECT sum(count), count(*) FROM a_pinyin_data_word_count')
    count, all_word = c.fetchone()

    print('DEBUG: ' + str(count) + ' words, ' + str(all_word) + ' unique words')

    # calc H()
    h = 0
    c.execute('SELECT count FROM a_pinyin_data_word_count')
    for i in c:
        p = i[0] / count
        h -= p * math.log(p, 2)
    print('DEBUG: H = ' + str(h) + ' bit')

    return h


def main(args):
    f_db = args[0]

    # open database
    conn = sqlite3.connect(f_db)

    c = conn.cursor()

    calc_h(c)

    conn.close()

if __name__ == '__main__':
    main(sys.argv[1:])
