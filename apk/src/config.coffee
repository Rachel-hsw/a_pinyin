# config.coffee, a_pinyin/apk/src/

P_VERSION = 'a_pinyin version 1.0.0 test20180525 0150'

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


module.exports = {
  P_VERSION

  DELETE_KEY_DELAY_FIRST
  DELETE_KEY_DELAY_MS

  SYMBOL_DEFAULT
  SYMBOL_PER_LINE
  SYMBOL_N
  SYMBOL2_N

  TOP_PINYIN_LIST_NUM
  PINYIN_MORE_PER_LINE

  # the redux global store
  store: null

  # only run one instance of headless_bg_task
  is_running_headless_bg_task: false
}
