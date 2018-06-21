# kb_symbol2.coffee, a_pinyin/apk/src/keyboard/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  FlatList
  Text
} = require 'react-native'
{ default: IconM } = require 'react-native-vector-icons/MaterialCommunityIcons'

{
  KB_PAD_V
} = require '../style'
s = require './_kb_style'
{
  SimpleTouch
  KbSecIconButton
} = require './_kb_key'
{
  S2_TYPE_TEXT
  S2_TYPE_PASTE
  S2_TYPE_PLACEHOLDER

  calc_symbol2
} = require './_kb_util'


KbSymbol2 = cC {
  displayName: 'KbSymbol2'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired
    size_x: PropTypes.number.isRequired
    size_y: PropTypes.number.isRequired
    # TODO more meta-data on list ?
    list: PropTypes.arrayOf(PropTypes.string).isRequired
    measured_width: PropTypes.arrayOf(PropTypes.number).isRequired

    on_text: PropTypes.func.isRequired
    on_clip_paste: PropTypes.func.isRequired
    reload: PropTypes.func.isRequired
  }

  componentWillUnmount: ->
    @props.reload()

  _gen_layouts_data: ->
    size_x = @props.size_x
    size_y = @props.size_y - KB_PAD_V
    # for top gap
    calc_symbol2 size_x, size_y, @props.list, @props.measured_width

  # i: index (key)
  # one: PropTypes.shape {
  #   # one item (button) to render
  #
  #   type: PropTypes.string.isRequired
  #   # type can be one of
  #   #   'text': normal text symbol
  #   #   'paste': the clip-paste button
  #   #   '': placeholder (else type, default)
  #
  #   # size (width)
  #   flex: PropTypes.number.isRequired
  #   height: PropTypes.number.isRequired  # FIXME height to render
  #
  #   # only for type: 'text'
  #   text: PropTypes.string  # text to display
  #   text_cb: PropTypes.string  # optional override on_text() callback value
  #
  #   color: PropTypes.string
  #   # set text color, can be one of
  #   #   null: default color (text)
  #   #   'sec': text_sec color
  #   #   'nolog': use nolog text color
  #
  #   bold: PropTypes.bool  # set bold text
  # }
  _render_one: (i, one) ->
    # merge styles
    style = [
      # TODO
      # view layout style
      {
        flex: one.flex
        height: one.height
      }
    ]
    style_text = {
      # TODO support color and bold
    }

    switch one.type
      when S2_TYPE_TEXT
        (cE SimpleTouch, {
          key: i
          co: @props.co
          vibration_ms: @props.vibration_ms
          style_view: style
          style: style_text
          text: one.text
          text_cb: one.text_cb
          on_click: @props.on_text
          })
      when S2_TYPE_PASTE
        (cE KbSecIconButton, {
          key: i
          co: @props.co
          vibration_ms: @props.vibration_ms
          style
          on_click: @props.on_clip_paste
          },
          (cE IconM, {  # MaterialCommunityIcons
            style: s.st
            name: 'content-paste'
            })
        )
      else  # default S2_TYPE_PLACEHOLDER
        (cE View, {
          key: i
          style
          })

  # render one line in FlatList
  _render_one_line: (it) ->
    {
      item
      index
    } = it
    # special render first line (top pad)
    if index is 0
      (cE View, {
        style: s.m_pad
        })
    else
      o = []
      for i in [0... item.length]
        o.push @_render_one(i, item[i])

      (cE View, {
        style: s.sy_line
        },
        o
      )

  render: ->
    data = @_gen_layouts_data()

    (cE View, {
      style: s.m_flex
      },
      # render lines as list
      (cE FlatList, {
        data
        renderItem: @_render_one_line
        extraData: {
          co: @props.co
          vibration_ms: @props.vibration_ms
        }
        keyExtractor: (item, index) ->
          "#{index}"
        style: s.flatlist
      })
    )
}

module.exports = KbSymbol2
