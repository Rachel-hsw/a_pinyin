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

module.exports = {
  A_PINYIN_NATIVE_EVENT

  INPUT_MODE_OTHER
  INPUT_MODE_SYMBOL
  INPUT_MODE_SYMBOL2
  INPUT_MODE_PINYIN

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
}
