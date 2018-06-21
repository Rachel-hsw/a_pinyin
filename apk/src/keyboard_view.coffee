# keyboard_view.coffee, a_pinyin/apk/src/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View

  DeviceEventEmitter
} = require 'react-native'
Subscribable = require 'Subscribable'

{
  KB_TOP_HEIGHT
  KB_PAD_V

  ss
} = require './style'
{ get_co } = require './color'

im_native = require './im_native'

KbTop = require './keyboard/kb_top'

KbMore = require './keyboard/kb_more'
KbPinyin = require './keyboard/kb_pinyin'

KbEnglish = require './keyboard/kb_english'
KbNumber = require './keyboard/kb_number'
KbSymbol = require './keyboard/kb_symbol'
KbSymbol2 = require './keyboard/kb_symbol2'


KeyboardView = cC {
  displayName: 'KeyboardView'
  mixins: [ Subscribable.Mixin ]

  propTypes: {
    co: PropTypes.object.isRequired

    layout: PropTypes.string.isRequired
    vibration_ms: PropTypes.number.isRequired

    core_nolog: PropTypes.bool.isRequired
    list_symbol: PropTypes.array.isRequired
    list_symbol2: PropTypes.array.isRequired
    symbol2_measured_width: PropTypes.array.isRequired

    on_native_event: PropTypes.func.isRequired
    on_init: PropTypes.func.isRequired

    on_close: PropTypes.func.isRequired
    on_set_layout: PropTypes.func.isRequired
    on_set_nolog: PropTypes.func.isRequired

    on_text: PropTypes.func.isRequired
    on_key_delete: PropTypes.func.isRequired
    on_key_enter: PropTypes.func.isRequired
    on_clip_paste: PropTypes.func.isRequired

    on_text_symbol: PropTypes.func.isRequired
    on_text_symbol2: PropTypes.func.isRequired
    reload_symbol: PropTypes.func.isRequired
    reload_symbol2: PropTypes.func.isRequired
  }

  getInitialState: ->
    {
      kb: 'pinyin'  # current keyboard tab
        # ['more', 'english', 'pinyin', 'number', 'symbol', 'symbol2']
      layout: null  # layout data for size_x, size_y
    }

  _onLayout: (evt) ->
    @setState {
      layout: evt.nativeEvent.layout
    }

  _get_body_size: ->
    # assert: @state.layout != null
    {
      size_x: @state.layout.width
      size_y: @state.layout.height - KB_TOP_HEIGHT
    }

  _on_native_event: (raw) ->
    event = JSON.parse raw
    @props.on_native_event event

  componentDidMount: ->
    # listen to native event
    @addListenerOn DeviceEventEmitter, im_native.A_PINYIN_NATIVE_EVENT, @_on_native_event

    @props.on_init()

  _on_set_kb: (kb) ->
    @setState {
      kb
    }

  _render_pinyin: ->
    size_x = @state.layout.width
    size_y = @state.layout.height

    (cE KbPinyin, {
      co: @props.co
      vibration_ms: @props.vibration_ms
      size_x
      size_y
      layout: @props.layout
      core_nolog: @props.core_nolog

      on_set_kb: @_on_set_kb

      on_close: @props.on_close
      on_key_delete: @props.on_key_delete
      on_key_enter: @props.on_key_enter
    })

  _render_kb: ->
    # no render without layout
    if ! @state.layout?
      null
    else if @state.kb is 'pinyin'
      @_render_pinyin()
    else
      [
        (cE KbTop, {
          co: @props.co
          vibration_ms: @props.vibration_ms
          kb: @state.kb
          is_nolog: @props.core_nolog
          on_set_kb: @_on_set_kb
          on_close: @props.on_close

          key: 1
          })
        @_render_body()
      ]

  _render_body: ->
    {
      size_x
      size_y
    } = @_get_body_size()

    switch @state.kb
      when 'more'
        (cE KbMore, {
          co: @props.co
          vibration_ms: @props.vibration_ms
          layout: @props.layout
          is_nolog: @props.core_nolog
          on_set_layout: @props.on_set_layout
          on_set_nolog: @props.on_set_nolog

          key: 2
          })
      when 'english'
        (cE KbEnglish, {
          co: @props.co
          vibration_ms: @props.vibration_ms
          size_x
          size_y
          layout: @props.layout
          on_text: @props.on_text
          on_key_delete: @props.on_key_delete
          on_key_enter: @props.on_key_enter

          key: 2
          })
      when 'number'
        (cE KbNumber, {
          co: @props.co
          vibration_ms: @props.vibration_ms
          on_text: @props.on_text
          on_key_delete: @props.on_key_delete
          on_key_enter: @props.on_key_enter

          key: 2
          })
      when 'symbol'
        (cE KbSymbol, {
          co: @props.co
          vibration_ms: @props.vibration_ms
          size_x
          size_y
          list: @props.list_symbol
          on_text: @props.on_text_symbol
          reload: @props.reload_symbol

          key: 2
          })
      when 'symbol2'
        (cE KbSymbol2, {
          co: @props.co
          vibration_ms: @props.vibration_ms
          size_x
          size_y
          list: @props.list_symbol2
          measured_width: @props.symbol2_measured_width
          on_text: @props.on_text_symbol2
          on_clip_paste: @props.on_clip_paste
          reload: @props.reload_symbol2

          key: 2
          })

  render: ->
    (cE View, {
      onLayout: @_onLayout
      style: [
        ss.keyboard_view
        @props.co.keyboard_view
      ] },
      @_render_kb()
    )
}

# connect for redux
{ connect } = require 'react-redux'

action = require './redux/action'
op = require './redux/op'

mapStateToProps = ($$state, props) ->
  $$user = $$state.get 'user'

  {
    co: get_co $$state.get('co')
    layout: $$state.get 'layout'
    vibration_ms: $$state.getIn ['config', 'vibration_ms']

    core_nolog: $$state.getIn ['core', 'nolog']
    list_symbol: $$user.get('symbol').toJS()
    list_symbol2: $$user.get('symbol2').toJS()
    symbol2_measured_width: $$user.get('measured_width').toJS()
  }

mapDispatchToProps = (dispatch, props) ->
  o = Object.assign {}, props
  o.on_native_event = (data) ->
    dispatch op.on_native_event_kb(data)
  o.on_init = ->
    # turn-off nolog mode by default
    await dispatch op.core_set_nolog(false)
    # init load symbols
    await dispatch op.load_user_symbol()
    await dispatch op.load_user_symbol2()

  o.on_set_layout = (name) ->
    dispatch action.set_layout(name)
  o.on_set_nolog = (nolog) ->
    dispatch op.core_set_nolog(nolog)

  o.on_close = ->
    dispatch op.close_window()
  o.on_text = (text) ->
    dispatch op.add_text(text)
  o.on_key_delete = ->
    dispatch op.key_delete()
  o.on_key_enter = ->
    dispatch op.key_enter()
  o.on_clip_paste = ->
    dispatch op.clip_paste()

  o.on_text_symbol = (text) ->
    dispatch op.add_text(text, im_native.INPUT_MODE_SYMBOL)
  o.on_text_symbol2 = (text) ->
    dispatch op.add_text(text, im_native.INPUT_MODE_SYMBOL2)
  o.reload_symbol = ->
    dispatch op.load_user_symbol()
  o.reload_symbol2 = ->
    dispatch op.load_user_symbol2()
  o

module.exports = connect(mapStateToProps, mapDispatchToProps)(KeyboardView)
