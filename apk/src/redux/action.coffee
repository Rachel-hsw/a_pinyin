# action.coffee, a_pinyin/apk/src/redux/

A_SET_CO = 'a_set_co'
A_RESET_UI = 'a_reset_ui'

A_SET_LAYOUT = 'a_set_layout'

A_SET_DL_MIRROR = 'a_set_dl_mirror'

PINYIN_RESET = 'pinyin_reset'
PINYIN_SET = 'pinyin_set'

# for headless bg js task
HEADLESS_COUNT = 'headless_count'

# core status
CORE_IS_INPUT = 'core_is_input'
CORE_NOLOG_CHANGE = 'core_nolog_change'

USER_SET_SYMBOL = 'user_set_symbol'
USER_SET_SYMBOL2 = 'user_set_symbol2'
USER_SET_MEASURED_WIDTH = 'user_set_measured_width'

DB_SET_INFO = 'db_set_info'

UPDATE_CONFIG = 'update_config'

DUS2_LOAD_START = 'dus2_load_start'
DUS2_LOAD_END = 'dus2_load_end'


set_co = (co) ->
  {
    type: A_SET_CO
    payload: co
  }

reset_ui = ->
  {
    type: A_RESET_UI
  }

set_layout = (name) ->
  {
    type: A_SET_LAYOUT
    payload: name
  }

set_dl_mirror = (payload) ->
  {
    type: A_SET_DL_MIRROR
    payload
  }

pinyin_reset = ->
  {
    type: PINYIN_RESET
  }

pinyin_set = (data) ->
  {
    type: PINYIN_SET
    payload: data
  }

headless_count = ->
  {
    type: HEADLESS_COUNT
  }

core_is_input = (is_input, input_mode) ->
  {
    type: CORE_IS_INPUT
    payload: {
      is_input
      input_mode
    }
  }

core_nolog_change = (nolog) ->
  {
    type: CORE_NOLOG_CHANGE
    payload: {
      nolog
    }
  }

user_set_symbol = (data) ->
  {
    type: USER_SET_SYMBOL
    payload: data
  }

user_set_symbol2 = (data) ->
  {
    type: USER_SET_SYMBOL2
    payload: data
  }

user_set_measured_width = (payload) ->
  {
    type: USER_SET_MEASURED_WIDTH
    payload
  }

db_set_info = (payload) ->
  {
    type: DB_SET_INFO
    payload
  }

update_config = (payload) ->
  {
    type: UPDATE_CONFIG
    payload
  }

dus2_load_start = ->
  {
    type: DUS2_LOAD_START
  }

dus2_load_end = (payload) ->
  {
    type: DUS2_LOAD_END
    payload
  }

module.exports = {
  A_SET_CO
  A_RESET_UI
  A_SET_LAYOUT
  A_SET_DL_MIRROR

  PINYIN_RESET
  PINYIN_SET

  HEADLESS_COUNT
  CORE_IS_INPUT
  CORE_NOLOG_CHANGE

  USER_SET_SYMBOL
  USER_SET_SYMBOL2
  USER_SET_MEASURED_WIDTH

  DB_SET_INFO

  UPDATE_CONFIG

  DUS2_LOAD_START
  DUS2_LOAD_END

  set_co
  reset_ui
  set_layout
  set_dl_mirror

  pinyin_reset
  pinyin_set

  headless_count
  core_is_input
  core_nolog_change

  user_set_symbol
  user_set_symbol2
  user_set_measured_width

  db_set_info

  update_config

  dus2_load_start
  dus2_load_end
}
