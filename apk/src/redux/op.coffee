# op.coffee, a_pinyin/apk/src/redux/

path = require 'path'

{ default: RNFetchBlob } = require 'react-native-fetch-blob'

action = require './action'
util = require '../util'

config = require '../config'
im_native = require '../im_native'


close_window = ->
  (dispatch, getState) ->
    await im_native.close_window()

add_text = (text, mode = 0) ->
  (dispatch, getState) ->
    await im_native.add_text(text, mode)

add_text_pinyin = (text, pinyin) ->
  (dispatch, getState) ->
    await im_native.add_text(text, im_native.INPUT_MODE_PINYIN, pinyin)

key_delete = ->
  (dispatch, getState) ->
    await im_native.key_delete()

key_enter = ->
  (dispatch, getState) ->
    await im_native.key_enter()


# for pinyin input

reset_pinyin = ->
  (dispatch, getState) ->
    dispatch action.pinyin_reset()
    await im_native.set_pinyin(null)

_pinyin_commit = ->
  (dispatch, getState) ->
    $$p = getState().get 'pinyin'
    text = $$p.get('wait').toJS().join('')
    # FIXME use first cut result
    pinyin = $$p.getIn(['cut', 0]).toJS().pinyin
    await dispatch add_text_pinyin(text, pinyin)
    await dispatch reset_pinyin()

# use core_get_text()
_update_can = ->
  (dispatch, getState) ->
    $$p = getState().get 'pinyin'
    wait = $$p.get('wait').toJS().join('')  # wait chars
    cut = $$p.get('cut').toJS()
    # check empty cut
    if cut.length < 1
      dispatch action.pinyin_set({
        can: []  # use empty can here
      })
      return
    # FIXME use first cut result
    cr = cut[0]
    # get rest pinyin
    pinyin = cr.pinyin[wait.length ..]
    if pinyin.length > 0
      can = await im_native.core_get_text(pinyin)
      dispatch action.pinyin_set({
        can
      })
    # else: FIXME what to do ?

# render top pinyin str
_update_top_pinyin = ->
  (dispatch, getState) ->
    $$p = getState().get 'pinyin'
    wait = $$p.get('wait').toJS().join('')
    cut = $$p.get('cut').toJS()
    # check empty cut
    if cut.length < 1
      # just use raw user input
      raw = $$p.get 'raw'
      await im_native.set_pinyin(raw)
      return
    # FIXME use first cut result
    cr = cut[0]
    # get rest pinyin
    pinyin = cr.pinyin[wait.length ..]

    # merge result
    o = wait + pinyin.join('\'')
    # check rest
    if cr.rest?
      o += '\'' + cr.rest
    # check add last `'` char in raw input
    raw = $$p.get 'raw'
    if raw[raw.length - 1] is '\''
      o += '\''

    await im_native.set_pinyin(o)

_update_pinyin = (new_pinyin) ->
  (dispatch, getState) ->
    # check empty pinyin
    if new_pinyin.length < 1
      await dispatch reset_pinyin()
      return

    # cut pinyin
    cut = await im_native.core_pinyin_cut(new_pinyin)
    dispatch action.pinyin_set({
      raw: new_pinyin
      cut
    })

    await dispatch _update_can()
    await dispatch _update_top_pinyin()

# low level user raw input: add_char, delete, select_item
pinyin_add_char = (c) ->
  (dispatch, getState) ->
    old_pinyin = getState().getIn ['pinyin', 'raw']
    new_pinyin = old_pinyin + c

    # TODO add pinyin char if wait is not empty ?

    await dispatch _update_pinyin(new_pinyin)

pinyin_delete = ->
  (dispatch, getState) ->
    # check no pinyin, then just pass-through delete key
    old_pinyin = getState().getIn ['pinyin', 'raw']
    if old_pinyin.length < 1
      await dispatch key_delete()
      return

    # check wait chars, delete wait first
    wait = getState().getIn(['pinyin', 'wait']).toJS()
    if wait.length > 0
      wait.pop()  # delete last part of wait chars
      dispatch action.pinyin_set({
        wait
      })
      await dispatch _update_can()
      await dispatch _update_top_pinyin()
      return

    # no wait chars, now delete pinyin (remove last char)
    new_pinyin = old_pinyin[... old_pinyin.length - 1]
    await dispatch _update_pinyin(new_pinyin)

pinyin_select_item = (text) ->
  (dispatch, getState) ->
    wait = getState().getIn(['pinyin', 'wait']).toJS()
    wait.push text
    dispatch action.pinyin_set({
      wait
    })
    # check commit text
    # assert: cut can not be empty
    # FIXME use first cut result
    cr = getState().getIn(['pinyin', 'cut', 0]).toJS()
    wait_text = wait.join('')
    if (! cr.rest?) and (wait_text.length >= cr.pinyin.length)
      # no rest pinyin, should commit
      await dispatch _pinyin_commit()
    else
      await dispatch _update_can()
      await dispatch _update_top_pinyin()

# process press space key in pinyin keyboard
pinyin_space = ->
  (dispatch, getState) ->
    $$p = getState().get 'pinyin'
    raw = $$p.get 'raw'

    if raw.length > 0
      can = $$p.get('can').toJS()
      # check has can items
      if (can.length > 0) and (can[0].length > 0)
        await dispatch pinyin_select_item(can[0][0])
      # else: ignore  # FIXME change this, not ignore ?
    else  # not in pinyin input state, send normal space char
      await dispatch add_text(' ')


# process native events

# native event send from both
# FIXME one event call this twice
on_native_event = (event) ->
  (dispatch, getState) ->
    # check event type
    switch event.type
      when 'core_start_input'
        await dispatch action.core_is_input(true, event.payload.mode)
      when 'core_end_input'
        await dispatch action.core_is_input(false, null)
        # reload symbols data here
        await dispatch load_user_symbol()
        await dispatch load_user_symbol2()
      when 'core_nolog_mode_change'
        # get new mode
        nolog = await im_native.core_get_nolog()
        await dispatch action.core_nolog_change(nolog)

# native event from main Activity
on_native_event_ui = (event) ->
  (dispatch, getState) ->
    await dispatch on_native_event(event)
    # TODO
    await return

# native event from keyboard view
on_native_event_kb = (event) ->
  (dispatch, getState) ->
    await dispatch on_native_event(event)
    # TODO
    await return

core_set_nolog = (nolog) ->
  (dispatch, getState) ->
    await im_native.core_set_nolog(nolog)


# user model

load_user_symbol = ->
  (dispatch, getState) ->
    raw = await im_native.core_get_symbol()
    dispatch action.user_set_symbol(_calc_user_symbol(raw))

load_user_symbol2 = ->
  (dispatch, getState) ->
    raw = await im_native.core_get_symbol2()
    dispatch action.user_set_symbol2(_calc_user_symbol2(raw))

_calc_user_symbol = (raw) ->
  # default list
  d = []
  for c in config.SYMBOL_DEFAULT
    d.push c
  # first list: order by last_used
  first = raw[0][0... config.SYMBOL_N]
  # second list: order by count
  _merge_list [first, raw[1], d]

_calc_user_symbol2 = (raw) ->
  first = raw[1][0... config.SYMBOL2_N]
  _merge_list [first, raw[2], raw[0]]

_merge_list = (raw) ->
  d = {}  # used items
  o = []
  for i in raw
    for j in i
      if ! d[j]
        o.push j
        d[j] = true
  o

# database

check_db = ->
  (dispatch, getState) ->
    ok = true
    # check core_data.db
    if await RNFetchBlob.fs.exists(config.DB_CORE_DATA)
      DB_NAME = 'core_data.db'
      stat = await RNFetchBlob.fs.stat(config.DB_CORE_DATA)
      o = {
        db_path: {}
        db_size: {}
      }
      o.db_path[DB_NAME] = config.DB_CORE_DATA
      o.db_size[DB_NAME] = stat.size
      dispatch action.db_set_info(o)
    else
      ok = false
    # check user_data.db
    if await RNFetchBlob.fs.exists(config.DB_USER_DATA)
      DB_NAME = 'user_data.db'
      stat = await RNFetchBlob.fs.stat(config.DB_USER_DATA)
      o = {
        db_path: {}
        db_size: {}
      }
      o.db_path[DB_NAME] = config.DB_USER_DATA
      o.db_size[DB_NAME] = stat.size
      dispatch action.db_set_info(o)
    else
      ok = false
    # TODO invoke im_native to check db content (version ?)
    dispatch action.db_set_info({
      ok
    })

dl_db = ->
  (dispatch, getState) ->
    dispatch action.db_set_info({
      dling: true
    })
    try
      await dispatch _dl_db()
      await dispatch check_db()
    catch e
      # TODO error process ?
    dispatch action.db_set_info({
      dling: false
    })

_dl_db = ->
  (dispatch, getState) ->
    # core_data.db
    if ! await RNFetchBlob.fs.exists(config.DB_CORE_DATA)
      await _dl_one_db config.DB_CORE_DATA, config.DB_REMOTE_URL['core_data.db'], ' core_data.db A拼音 核心数据库'
    # user_data.db
    if ! await RNFetchBlob.fs.exists(config.DB_USER_DATA)
      await _dl_one_db config.DB_USER_DATA, config.DB_REMOTE_URL['user_data.db'], ' user_data.db A拼音 用户数据库'

_ensure_parent_dir = (p) ->
  parent = path.dirname(p)
  # ensure parent first
  if ! await RNFetchBlob.fs.isDir(parent)
    await _ensure_parent_dir parent
  # check and create this
  if ! await RNFetchBlob.fs.isDir(p)
    await RNFetchBlob.fs.mkdir(p)

_dl_one_db = (local_file, url, description) ->
  # check and create tmp dir
  await _ensure_parent_dir(config.DB_TMP_DIR)
  # use Android download manager to download the database file
  o = RNFetchBlob.config({
    addAndroidDownloads: {
      useDownloadManager: true
      notification: true
      mime: '*/*'
      title: description
      description
      path: path.join RNFetchBlob.fs.dirs.DownloadDir, path.basename(local_file)
    }
  })
  res = await o.fetch 'GET', url
  p = res.path()
  # check and create db dir
  await _ensure_parent_dir path.dirname(local_file)
  # write-replace the db file
  tmp_file = local_file + config.DB_TMP_SUFFIX
  await RNFetchBlob.fs.cp p, tmp_file  # write
  await RNFetchBlob.fs.mv tmp_file, local_file  # replace
  # try to delete download file, ignore error
  try
    await RNFetchBlob.fs.unlink p
  catch e
    # TODO ignore error

module.exports = {
  close_window  # thunk
  add_text  # thunk
  add_text_pinyin  # thunk
  key_delete  # thunk
  key_enter  # thunk

  reset_pinyin  # thunk
  pinyin_add_char  # thunk
  pinyin_delete  # thunk
  pinyin_select_item  # thunk
  pinyin_space  # thunk

  on_native_event  # thunk
  on_native_event_ui  # thunk
  on_native_event_kb  # thunk

  core_set_nolog  # thunk

  load_user_symbol  # thunk
  load_user_symbol2  # thunk

  check_db  # thunk
  dl_db  # thunk
}
