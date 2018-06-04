# kb_top_pinyin.coffee, a_pinyin/apk/src/keyboard/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  StyleSheet

  View
  Text
} = require 'react-native'

style = require '../style'
{
  Touch
} = require './_kb_sub'
config = require '../config'

{
  ss
} = style
# local styles
s = StyleSheet.create {
  text: {
    fontSize: style.TITLE_SIZE
  }
  view: {
    height: '100%'
  }
  right_view: {
    height: '100%'
    width: style.KB_TOP_WIDTH
  }

  kb_view: {
    flex: 1
    flexDirection: 'row'
  }
  # TODO
}


KbTopPinyin = cC {
  displayName: 'KbTopPinyin'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired

    list: PropTypes.array.isRequired

    on_text: PropTypes.func.isRequired
    on_more: PropTypes.func.isRequired
  }

  _render_one: (text, i) ->
    on_click = =>
      @props.on_text text
    # calc cell width
    top_width = style.KB_TOP_WIDTH
    font_size = style.TITLE_SIZE
    width = (top_width - font_size) + font_size * text.length

    (cE View, {
      key: i
      style: [
        s.view
        {
          width
        }
      ] },
      (cE Touch, {
        co: @props.co
        vibration_ms: @props.vibration_ms
        text
        text_style: s.text
        on_click
        })
    )

  _render_list: ->
    o = []
    for i in [0... Math.min(@props.list.length, config.TOP_PINYIN_LIST_NUM)]
      o.push @_render_one(@props.list[i], i)
    o

  _render_more: ->
    text_style = [
      s.text
      @props.co.kb_sec_text
    ]
    # not show more button if list is empty
    if @props.list.length < 1
      (cE View, {
        style: s.right_view
        })
    else
      (cE View, {
        style: s.right_view
        },
        (cE Touch, {
          co: @props.co
          vibration_ms: @props.vibration_ms
          text: '>'
          text_style
          on_click: @props.on_more
          })
      )

  render: ->
    (cE View, {
      style: [
        ss.kb_top_view
        @props.co.border
      ] },
      # input list to select
      (cE View, {
        style: s.kb_view
        },
        @_render_list()
      )
      # more button
      @_render_more()
    )
}

module.exports = KbTopPinyin
