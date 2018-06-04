# im_native.coffee, a_pinyin/apk/src/

{ NativeModules } = require 'react-native'

_n = NativeModules.im_native


close_window = ->
  await _n.close_window()

# input modes
INPUT_MODE_OTHER = _n.INPUT_MODE_OTHER
INPUT_MODE_SYMBOL = _n.INPUT_MODE_SYMBOL
INPUT_MODE_SYMBOL2 = _n.INPUT_MODE_SYMBOL2
INPUT_MODE_PINYIN = _n.INPUT_MODE_PINYIN

add_text = (text, mode = 0, pinyin = null) ->
  pin_yin = null
  if pinyin?
    pin_yin = pinyin.join '_'
  await _n.add_text(text, mode, pin_yin)

key_delete = ->
  await _n.key_delete()

key_enter = ->
  await _n.key_enter()

set_pinyin = (pinyin) ->
  await _n.set_pinyin(pinyin)


# export pinyin core functions

# > 'raw_pinyin_str'
# < [
#     {
#       pinyin: ['pin', 'yin']
#       rest: 'xxx'  # or null
#       sort_value:  # (number)
#     }
#   ]
core_pinyin_cut = (pinyin) ->
  result = await _n.core_pinyin_cut(pinyin)
  JSON.parse result

# > ['pin', 'yin']
# < [
#     ['xxx', 'yyy']
#     ['zzz']
#   ]
core_get_text = (pinyin) ->
  p = JSON.stringify pinyin
  result = await _n.core_get_text(p)
  JSON.parse result


# send native event
A_PINYIN_NATIVE_EVENT = _n.A_PINYIN_NATIVE_EVENT

# events native code may emit:
#
# {
#   type: 'core_start_input'
#   payload: {
#     mode: 0  # TODO input mode ?
#   }
# }
#
# {
#   type: 'core_end_input'
# }
#
# {
#   type: 'core_nolog_mode_change'
# }

# nolog mode
core_get_nolog = ->
  await _n.core_get_nolog()

core_set_nolog = (nolog) ->
  await _n.core_set_nolog(nolog)


# user model
core_get_symbol = ->
  raw = await _n.core_get_symbol()
  if raw?
    o = JSON.parse raw
  else
    o = [ [], [] ]  # default value: all empty
  o

core_get_symbol2 = ->
  raw = await _n.core_get_symbol2()
  if raw?
    o = JSON.parse raw
  else
    o = [ [], [], [] ]
  o


# core config

core_config_get_level = ->
  await _n.core_config_get_level()

core_config_set_level = (level) ->
  await _n.core_config_set_level level

# core levels
CORE_LEVEL_A = 0  # 3,000 Chinese chars
CORE_LEVEL_B = 1  # 5,000
CORE_LEVEL_C = 2  # 7,000
CORE_LEVEL_D = 3  # > zero freq
CORE_LEVEL_E = 4  # all (~ 41,217)
CORE_LEVEL_MAX = CORE_LEVEL_E
CORE_LEVEL_DEFAULT = CORE_LEVEL_C


core_clean_user_db = ->
  r = await _n.core_clean_user_db()
  if r != true
    throw new Error "no core"  # FIXME TODO

_gen_db_info = (raw) ->
  if ! raw?
    return null

  o = {}
  for i in raw
    o[i.name] = i.value
  o

CORE_DATA_DB_NAME = 'core_data.db'
USER_DATA_DB_NAME = 'user_data.db'

core_get_db_info = ->
  r = await _n.core_get_db_info()
  raw = JSON.parse r
  # rebuild data
  o = {}
  o[CORE_DATA_DB_NAME] = _gen_db_info raw[CORE_DATA_DB_NAME]
  o[USER_DATA_DB_NAME] = _gen_db_info raw[USER_DATA_DB_NAME]
  o

exit_app = ->
  await _n.exit_app()
  # never got here !
  throw new Error "exit failed"

module.exports = {
  A_PINYIN_NATIVE_EVENT

  INPUT_MODE_OTHER
  INPUT_MODE_SYMBOL
  INPUT_MODE_SYMBOL2
  INPUT_MODE_PINYIN

  CORE_LEVEL_A
  CORE_LEVEL_B
  CORE_LEVEL_C
  CORE_LEVEL_D
  CORE_LEVEL_E
  CORE_LEVEL_MAX
  CORE_LEVEL_DEFAULT

  CORE_DATA_DB_NAME
  USER_DATA_DB_NAME

  close_window  # async
  add_text  # async
  key_delete  # async
  key_enter  # async
  set_pinyin  # async

  core_pinyin_cut  # async
  core_get_text  # async

  core_get_nolog  # async
  core_set_nolog  # async

  core_get_symbol  # async
  core_get_symbol2  # async

  core_config_get_level  # async
  core_config_set_level  # async

  core_clean_user_db  # async
  core_get_db_info  # async
  exit_app  # async
}
