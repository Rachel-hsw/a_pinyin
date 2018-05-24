#!/usr/bin/env python3.6
# gen_core_dict.py, a_pinyin/core_tools/py/core_dict/
import os, sys
import json
import sqlite3


def load_json(filename):
    with open(filename, 'rb') as f:
        text = f.read().decode('utf-8')
    return json.loads(text)


def add_pin_yin(conn, char_to_pinyin):
    c1 = conn.cursor()
    c1.execute('SELECT DISTINCT prefix2 FROM a_pinyin_core_dict')
    c2 = conn.cursor()  # use cursor 2 to do INSERT
    for p in c1:
        prefix2 = str(p[0])
        # len(prefix2) == 2
        if len(prefix2) != 2:
            raise Exception('len(prefix2) == ' + str(len(prefix2)) + ' != 2, prefix2 = ' + prefix2)

        p0 = char_to_pinyin[prefix2[0]]
        if not isinstance(p0, list):
            p0 = [p0]
        p1 = char_to_pinyin[prefix2[1]]
        if not isinstance(p1, list):
            p1 = [p1]

        for i in p0:
            for j in p1:
                pin_yin = i + '_' + j
                c2.execute('INSERT INTO a_pinyin_core_dict_pinyin(pin_yin, prefix2) VALUES (?, ?)', (pin_yin, prefix2))

def gen_core_dict(c):
    sql = 'INSERT INTO a_pinyin_core_dict(word, count, prefix2) SELECT word, count, substr(word, 1, 2) AS prefix2 FROM word_count.a_pinyin_data_word_count WHERE length(word) > 1'
    c.execute(sql)

    c.execute('SELECT sum(count), count(*) FROM a_pinyin_core_dict')
    count, all_word = c.fetchone()
    print('DEBUG: ' + str(count) + ' words, ' + str(all_word) + ' unique words')


def main(args):
    f_char_to_pinyin, f_word_count_db, f_core_dict_db = args[0], args[1], args[2]

    print('DEBUG: load json ' + f_char_to_pinyin)
    char_to_pinyin = load_json(f_char_to_pinyin)

    print('DEBUG: open database ' + f_core_dict_db)
    # connect to core_dict.db
    conn = sqlite3.connect(f_core_dict_db)
    c = conn.cursor()
    # attach word_count.db
    print('DEBUG: ATTACH ' + f_word_count_db + ' AS word_count')
    c.execute('ATTACH ? AS word_count', (f_word_count_db,))

    # TODO check Exception and rollback ?
    gen_core_dict(c)

    print('DEBUG: add pin_yin')
    add_pin_yin(conn, char_to_pinyin)

    print('DEBUG: COMMIT')
    conn.commit()

    # detach word_count.db
    print('DEBUG: DETACH word_count')
    c.execute('DETACH word_count')

    # analyze and vacuum
    print('DEBUG: ANALYZE')
    c.execute('ANALYZE')

    print('DEBUG: VACUUM')
    c.execute('VACUUM')

    conn.close()

if __name__ == '__main__':
    main(sys.argv[1:])
