# config.coffee, a_pinyin/apk/src/

P_VERSION = 'a_pinyin version 1.3.1 test20180621 2344'

CORE_DB_VERSION = '1.0.0'

# for delete key, multi-delete function
DELETE_KEY_DELAY_FIRST = 300  # 300ms before first delete
DELETE_KEY_DELAY_MS = 50  # 50ms per delete

# symbol input default order (ASCII)
SYMBOL_DEFAULT = '.-~*,=:"!_/()[]?+\\|#^`@%>\'&<;{}$'  # 32 chars
SYMBOL_PER_LINE = 8
SYMBOL_N = 8  # 8 symbol first in last_used
SYMBOL2_N = 16  # 16 symbol2 in last_used

TOP_PINYIN_LIST_NUM = 7  # 7 items at most
PINYIN_MORE_PER_LINE = 6

DB_CORE_DATA = '/sdcard/a_pinyin/core/core_data.db'
DB_USER_DATA = '/sdcard/a_pinyin/user/user_data.db'

# URLs to download databases, with mirrors
DB_REMOTE_URL = {
  'bitbucket.org': {
    'core_data.db': 'https://bitbucket.org/sceext2018/a_pinyin/raw/db/1.0.0/core_data.db'
    'user_data.db': 'https://bitbucket.org/sceext2018/a_pinyin/raw/db/1.0.0/user_data.db'
  }
  'github.com': {
    'core_data.db': 'https://github.com/sceext-mirror-201806/a_pinyin/raw/db/1.0.0/core_data.db'
    'user_data.db': 'https://github.com/sceext-mirror-201806/a_pinyin/raw/db/1.0.0/user_data.db'
  }
  'gitee.com': {
    'core_data.db': 'https://gitee.com/sceext2133/a_pinyin/raw/db/1.0.0/core_data.db'
    'user_data.db': 'https://gitee.com/sceext2133/a_pinyin/raw/db/1.0.0/user_data.db'
  }
  'coding.net': {
    'core_data.db': 'https://coding.net/u/sceext2133/p/a_pinyin/git/raw/db/1.0.0/core_data.db'
    'user_data.db': 'https://coding.net/u/sceext2133/p/a_pinyin/git/raw/db/1.0.0/user_data.db'
  }
}
DB_TMP_DIR = '/sdcard/a_pinyin/tmp'
DB_TMP_SUFFIX = '.tmp'

module.exports = {
  P_VERSION
  CORE_DB_VERSION

  DELETE_KEY_DELAY_FIRST
  DELETE_KEY_DELAY_MS

  SYMBOL_DEFAULT
  SYMBOL_PER_LINE
  SYMBOL_N
  SYMBOL2_N

  TOP_PINYIN_LIST_NUM
  PINYIN_MORE_PER_LINE

  DB_CORE_DATA
  DB_USER_DATA

  DB_REMOTE_URL
  DB_TMP_DIR
  DB_TMP_SUFFIX

  # the redux global store
  store: null

  # only run one instance of headless_bg_task
  is_running_headless_bg_task: false
}
