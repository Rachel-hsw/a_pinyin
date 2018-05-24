# kb_top_pinyin.coffee, a_pinyin/apk/src/keyboard/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  Text
} = require 'react-native'

ss = require '../style'
{
  Touch
} = require './_kb_sub'
config = require '../config'


KbTopPinyin = cC {
  displayName: 'KbTopPinyin'
  propTypes: {
    co: PropTypes.object.isRequired

    list: PropTypes.array.isRequired

    on_text: PropTypes.func.isRequired
    on_more: PropTypes.func.isRequired
  }

  _render_one: (text, i) ->
    on_click = =>
      @props.on_text text
    # calc cell width
    top_width = ss.KB_TOP_WIDTH
    font_size = ss.TITLE_SIZE  # FIXME font_size may not be correct ?
    width = (top_width - font_size) + font_size * text.length

    (cE View, {
      key: i
      style: {
        height: '100%'
        width
      } },
      (cE Touch, {
        co: @props.co
        text
        font_size
        color: @props.co.TEXT
        on_click
        })
    )

  _render_list: ->
    o = []
    for i in [0... Math.min(@props.list.length, config.TOP_PINYIN_LIST_NUM)]
      o.push @_render_one(@props.list[i], i)
    o

  _render_more: ->
    # not show more button if list is empty
    if @props.list.length < 1
      (cE View, {
        style: {
          height: '100%'
          width: ss.KB_TOP_WIDTH
        } })
    else
      (cE View, {
        style: {
          height: '100%'
          width: ss.KB_TOP_WIDTH
        } },
        (cE Touch, {
          co: @props.co
          text: '>'
          font_size: ss.TITLE_SIZE
          color: @props.co.TEXT_SEC
          bg: @props.co.BG
          on_click: @props.on_more
          })
      )

  render: ->
    (cE View, {
      style: {
        flexShrink: 0
        height: ss.KB_TOP_HEIGHT
        # top border
        borderTopWidth: ss.BORDER_WIDTH
        borderTopColor: @props.co.BORDER

        flexDirection: 'row'
      } },
      # input list to select
      (cE View, {
        style: {
          flex: 1
          flexDirection: 'row'
        } },
        @_render_list()
      )
      # more button
      @_render_more()
    )
}

module.exports = KbTopPinyin
