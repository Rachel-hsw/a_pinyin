# reducer.coffee, a_pinyin/apk/src/redux/

Immutable = require 'immutable'

state = require './state'
ac = require './action'

_check_init = ($$o) ->
  if ! $$o?
    $$o = Immutable.fromJS state
  $$o

reducer = ($$state, action) ->
  $$o = _check_init $$state
  switch action.type
    when ac.A_SET_CO
      $$o = $$o.set 'co', action.payload
    #when ac.A_RESET_UI  # TODO
    when ac.A_SET_LAYOUT
      $$o = $$o.set 'layout', action.payload

    when ac.PINYIN_RESET
      $$o = $$o.set 'pinyin', Immutable.fromJS(state.pinyin)
    when ac.PINYIN_SET
      $$o = $$o.update 'pinyin', ($$p) ->
        $$p.merge Immutable.fromJS(action.payload)

    when ac.HEADLESS_COUNT
      $$o = $$o.updateIn ['headless', 'count'], (c) ->
        c + 1
    when ac.CORE_IS_INPUT
      $$o = $$o.setIn ['core', 'is_input'], action.payload.is_input
      $$o = $$o.setIn ['core', 'input_mode'], action.payload.input_mode
    when ac.CORE_NOLOG_CHANGE
      $$o = $$o.setIn ['core', 'nolog'], action.payload.nolog

    when ac.USER_SET_SYMBOL
      $$o = $$o.setIn ['user', 'symbol'], Immutable.fromJS(action.payload)
    when ac.USER_SET_SYMBOL2
      $$o = $$o.setIn ['user', 'symbol2'], Immutable.fromJS(action.payload)
    when ac.USER_SET_MEASURED_WIDTH
      $$o = $$o.setIn ['user', 'measured_width'], Immutable.fromJS(action.payload)

    when ac.DB_SET_INFO
      $$o = $$o.update 'db', ($$d) ->
        $$d.mergeDeep Immutable.fromJS(action.payload)

    when ac.UPDATE_CONFIG
      $$o = $$o.update 'config', ($$c) ->
        $$c.merge Immutable.fromJS(action.payload)

    when ac.DUS2_LOAD_START
      $$o = $$o.setIn ['dus2', 'is_loading'], true
    when ac.DUS2_LOAD_END
      $$o = $$o.setIn ['dus2', 'list'], Immutable.fromJS(action.payload)
      $$o = $$o.setIn ['dus2', 'is_loading'], false
  $$o

module.exports = reducer
