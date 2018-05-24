#!/usr/bin/env python3.6
# set_user_data_db_a_pinyin.py, a_pinyin/core_tools/py/db/
import os, sys
import sqlite3

import core_db_util as du


def main(args):
    f_db = args[0]

    conn = sqlite3.connect(f_db)

    du.set_a_pinyin_version(conn)
    #du.set_url(conn)
    du.set_last_update(conn)

    # TODO ANALYZE ? VACUUM ?
    conn.close()

if __name__ == '__main__':
    main(sys.argv[1:])
