#!/usr/bin/env python3.6
# set_symbol2.py, a_pinyin/core_tools/py/db/
import os, sys
import json
import sqlite3


def load_json(filename):
    with open(filename, 'rb') as f:
        text = f.read().decode('utf-8')
    return json.loads(text)


def set_symbol2(conn, data):
    c = conn.cursor()
    for i in data:
        c.execute('INSERT INTO a_pinyin_symbol2(text, count) VALUES (?, ?)', (i, data[i]))
    conn.commit()

def main(args):
    f_db, f_data = args[0], args[1]

    data = load_json(f_data)

    conn = sqlite3.connect(f_db)

    set_symbol2(conn, data)

    conn.close()

if __name__ == '__main__':
    main(sys.argv[1:])
