# kb_pinyin_more.coffee, a_pinyin/apk/src/keyboard/

React = require 'react'
{ createElement: cE } = React
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  FlatList
} = require 'react-native'

config = require '../config'
{
  KB_PAD_V
} = require '../style'
s = require './_kb_style'
{
  SimpleTouch
  KbSecButton
} = require './_kb_key'
{
  S2_TYPE_TEXT
  S2_TYPE_PLACEHOLDER

  calc_pinyin_more
} = require './_kb_util'


KbPinyinMore = cC {
  displayName: 'KbPinyinMore'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired
    size_x: PropTypes.number.isRequired
    size_y: PropTypes.number.isRequired
    list: PropTypes.arrayOf(PropTypes.arrayOf(
      PropTypes.string
    )).isRequired

    on_text: PropTypes.func.isRequired
    on_reset: PropTypes.func.isRequired
    on_back: PropTypes.func.isRequired
  }

  componentWillMount: ->
    @_ref_list = React.createRef()

  # export function
  scroll_to_top: ->
    @_ref_list.current?.scrollToOffset {
      offset: 0
    }

  _gen_layouts_data: ->
    size_x = @props.size_x  # FIXME size_x is BAD
    size_y = @props.size_y - KB_PAD_V
    # for top gap
    calc_pinyin_more size_x, size_y, @props.list

  # render one text item
  _render_one: (i, one) ->
    # merge styles
    style_view = [
      # TODO
      # view layout style
      {
        flex: one.flex
        height: one.height
      }
    ]
    style = {  # Text
      # TODO
    }

    switch one.type
      when S2_TYPE_TEXT
        (cE SimpleTouch, {
          key: i
          co: @props.co
          vibration_ms: @props.vibration_ms
          style
          style_view
          text: one.text
          on_click: @props.on_text
          })
      else  # default S2_TYPE_PLACEHOLDER
        (cE View, {
          key: i
          style: style_view
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
    # check sep line
    else if item.length < 1
      (cE View, {
        style: [
          s.pm_line_sep
          @props.co.border
        ] })
    else  # normal line
      o = []
      for i in [0... item.length]
        o.push @_render_one(i, item[i])

      (cE View, {
        style: s.pm_line
        },
        o
      )

  _render_left: ->
    data = @_gen_layouts_data()
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
      ref: @_ref_list
      style: s.flatlist
      })

  _render_right: ->
    (cE View, {
      style: s.pm_right
      },
      # more_back button
      (cE KbSecButton, {
        co: @props.co
        vibration_ms: @props.vibration_ms
        style: s.pm_right_button
        text: '⇑'
        on_click: @props.on_back
        })
      # reset button
      (cE KbSecButton, {
        co: @props.co
        vibration_ms: @props.vibration_ms
        style: s.pm_right_button
        style_text: s.pm_reset_button
        text: '重输'
        on_click: @props.on_reset
        })
    )

  render: ->
    (cE View, {
      style: s.pm_view
      },
      # left part
      (cE View, {
        style: s.pm_left
        },
        @_render_left()
      )
      # right part
      @_render_right()
    )
}

module.exports = KbPinyinMore
