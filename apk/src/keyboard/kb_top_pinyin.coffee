# kb_top_pinyin.coffee, a_pinyin/apk/src/keyboard/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
} = require 'react-native'

config = require '../config'
{
  KB_TOP_WIDTH
  TITLE_SIZE
} = require '../style'
s = require './_kb_style'
{
  SimpleTouch
} = require './_kb_key'


KbTopPinyin = cC {
  displayName: 'KbTopPinyin'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired

    list: PropTypes.arrayOf(PropTypes.string).isRequired
    no_more: PropTypes.bool.isRequired  # not show more button

    on_text: PropTypes.func.isRequired
    on_more: PropTypes.func.isRequired
  }

  _render_one: (text, i) ->
    # calc cell width
    top_width = KB_TOP_WIDTH
    font_size = TITLE_SIZE
    width = (top_width - font_size) + font_size * text.length

    style_view = {
      width
    }

    (cE SimpleTouch, {
      key: i
      co: @props.co
      vibration_ms: @props.vibration_ms
      style: s.tp_text
      style_view
      text: text
      on_click: @props.on_text
      })

  _render_list: ->
    o = []
    for i in [0... Math.min(@props.list.length, config.TOP_PINYIN_LIST_NUM)]
      o.push @_render_one(@props.list[i], i)
    o

  _render_more: ->
    style = [  # Text
      s.tp_text
      @props.co.kb_sec_text
    ]
    # not show more button if no_more or list is empty
    if @props.no_more or (@props.list.length < 1)
      (cE View, {
        style: s.tp_right
        })
    else
      (cE SimpleTouch, {
        co: @props.co
        vibration_ms: @props.vibration_ms
        style
        style_view: [
          s.tp_right
          @props.co.kb_top_pinyin_right
        ]
        text: '>'
        on_click: @props.on_more
        })

  render: ->
    (cE View, {
      style: [
        s.kb_top
        @props.co.border
      ] },
      # TODO use scroll view here ?
      # input list to select
      (cE View, {
        style: s.tp_view
        },
        @_render_list()
      )
      # more button
      @_render_more()
    )
}

module.exports = KbTopPinyin
