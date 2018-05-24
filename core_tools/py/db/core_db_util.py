#!/usr/bin/env python3.6
# core_db_util.py, a_pinyin/core_tools/py/db/
import datetime


A_PINYIN_VERSION = '1.0.0 test20180525 0150'
A_PINYIN_URL = 'https://coding.net/u/sceext2133/p/a_pinyin'


def update_or_insert(conn, name, value):
    c = conn.cursor()
    c.execute('UPDATE a_pinyin SET value = ? WHERE name = ?', (value, name))
    if c.rowcount > 0:
        print('DEBUG: UPDATE ' + name + ' = ' + value)
    else:  # TODO desc ?
        c.execute('INSERT INTO a_pinyin(name, value) VALUES (?, ?)', (name, value))
        print('DEBUG: INSERT ' + name + ' = ' + value)
    conn.commit()

def set_now(conn, name):
    now = datetime.datetime.utcnow().isoformat() + 'Z'
    update_or_insert(conn, name, now)


def set_a_pinyin_version(conn):
    update_or_insert(conn, 'a_pinyin version', A_PINYIN_VERSION)

def set_url(conn):
    update_or_insert(conn, 'url', A_PINYIN_URL)

def set_data_version(conn, value):
    update_or_insert(conn, 'data_version', value)

def set_last_update(conn):
    set_now(conn, 'last_update')
