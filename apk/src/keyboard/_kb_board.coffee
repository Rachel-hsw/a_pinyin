# _kb_board.coffee, a_pinyin/apk/src/keyboard/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
} = require 'react-native'

config = require '../config'
s = require './_kb_style'
{
  LB_TYPE_TEXT
  LB_TYPE_SHIFT
  LB_TYPE_DELETE
  LB_TYPE_SPACE
  LB_TYPE_ENTER

  calc_layouts_1097
  calc_layouts_7109
} = require './_kb_util'
{
  TEXT_KEY_ENTER

  SimpleTouch
  KbShiftButton
  KbSecButton
  KbDeleteKey
} = require './_kb_key'


_render_one = (self, i, one) ->
  # merge styles
  style = [
    s.lb_in
    # view layout style
    {
      width: one.w
      height: one.h
      left: one.x
      top: one.y
    }
  ]

  switch one.type
    when LB_TYPE_TEXT
      (cE SimpleTouch, {
        key: i
        co: self.props.co
        vibration_ms: self.props.vibration_ms
        style_view: style
        text: one.text
        on_click: self.props.on_text
        })
    when LB_TYPE_SHIFT
      (cE KbShiftButton, {
        key: i
        co: self.props.co
        vibration_ms: self.props.vibration_ms
        style
        shift: one.shift
        on_click: self.props.on_shift
        })
    when LB_TYPE_DELETE
      (cE KbDeleteKey, {
        key: i
        co: self.props.co
        vibration_ms: self.props.vibration_ms
        style
        on_delete: self.props.on_key_delete
        })
    when LB_TYPE_ENTER
      (cE KbSecButton, {
        key: i
        co: self.props.co
        vibration_ms: self.props.vibration_ms
        style
        text: TEXT_KEY_ENTER
        on_click: self.props.on_key_enter
        })
    else  # default LB_TYPE_SPACE
      (cE KbSecButton, {
        key: i
        co: self.props.co
        vibration_ms: self.props.vibration_ms
        style
        text: ''  # space button, without text
        on_click: self._on_click_space
        })


KbLayoutsBoard = cC {
  displayName: 'KbLayoutsBoard'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired

    layouts_data: PropTypes.arrayOf(PropTypes.shape({
      # one item (button / key) to render
      type: PropTypes.string.isRequired
      # type can be one of:
      #   'text': normal text button, eg. 'a'
      #   'shift': shift button
      #   'delete': delete button
      #   '': space button (else type, default)
      #   'enter': enter button

      # size and position
      x: PropTypes.number.isRequired  # x offset of parent top-left
      y: PropTypes.number.isRequired  # y offset of parent top-left
      w: PropTypes.number.isRequired  # width
      h: PropTypes.number.isRequired  # height

      # only for type: text
      text: PropTypes.string
      # only for type: shift
      shift: PropTypes.bool
    })).isRequired

    on_text: PropTypes.func.isRequired
    # optional for KbSymbol
    on_shift: PropTypes.func
    on_key_delete: PropTypes.func
    on_key_enter: PropTypes.func
  }

  _on_click_space: ->
    @props.on_text ' '

  render: ->
    o = []
    for i in [0... @props.layouts_data.length]
      o.push _render_one(this, i, @props.layouts_data[i])

    (cE View, {
      style: s.lb
      },
      o
    )
}


KbLayouts1097 = cC {
  displayName: 'KbLayouts1097'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired

    shift: PropTypes.bool
    layouts: PropTypes.arrayOf(PropTypes.string).isRequired
    size_x: PropTypes.number.isRequired
    size_y: PropTypes.number.isRequired

    on_text: PropTypes.func.isRequired
    on_shift: PropTypes.func.isRequired
    on_key_delete: PropTypes.func.isRequired
    on_key_enter: PropTypes.func.isRequired
  }

  _gen_layouts_data: ->
    calc_layouts_1097 @props.size_x, @props.size_y, @props.layouts, @props.shift

  render: ->
    layouts_data = @_gen_layouts_data()

    (cE KbLayoutsBoard, {
      co: @props.co
      vibration_ms: @props.vibration_ms
      layouts_data
      on_text: @props.on_text
      on_shift: @props.on_shift
      on_key_delete: @props.on_key_delete
      on_key_enter: @props.on_key_enter
      })
}

KbLayouts7109 = cC {
  displayName: 'KbLayouts7109'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired

    shift: PropTypes.bool
    layouts: PropTypes.arrayOf(PropTypes.string).isRequired
    size_x: PropTypes.number.isRequired
    size_y: PropTypes.number.isRequired

    on_text: PropTypes.func.isRequired
    on_shift: PropTypes.func.isRequired
    on_key_delete: PropTypes.func.isRequired
    on_key_enter: PropTypes.func.isRequired
  }

  _gen_layouts_data: ->
    calc_layouts_7109 @props.size_x, @props.size_y, @props.layouts, @props.shift

  render: ->
    layouts_data = @_gen_layouts_data()

    (cE KbLayoutsBoard, {
      co: @props.co
      vibration_ms: @props.vibration_ms
      layouts_data
      on_text: @props.on_text
      on_shift: @props.on_shift
      on_key_delete: @props.on_key_delete
      on_key_enter: @props.on_key_enter
      })
}

module.exports = {
  KbLayoutsBoard

  KbLayouts1097
  KbLayouts7109
}
