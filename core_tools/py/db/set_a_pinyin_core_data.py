#!/usr/bin/env python3.6
# set_core_data_db.py, a_pinyin/core_tools/py/db/
import os, sys
import sqlite3


def set_core_data(conn, name, kryo):
    c = conn.cursor()
    c.execute('UPDATE a_pinyin_core_data SET kryo = ? WHERE name = ?', (kryo, name))
    # check to INSERT
    if c.rowcount > 0:
        print('DEBUG: UPDATE ' + name + ' to ' + str(len(kryo)) + ' Bytes')
    else:
        c.execute('INSERT INTO a_pinyin_core_data(name, kryo) VALUES (?, ?)', (name, kryo))
        print('DEBUG: INSERT ' + name + '  ' + str(len(kryo)) + ' Bytes')

    conn.commit()
    # TODO ANALYZE ? VACUUM ?


def main(args):
    f_db, name, f_kryo = args[0], args[1], args[2]

    with open(f_kryo, 'rb') as f:
        kryo = f.read()

    conn = sqlite3.connect(f_db)

    set_core_data(conn, name, kryo)

    conn.close()

if __name__ == '__main__':
    main(sys.argv[1:])
