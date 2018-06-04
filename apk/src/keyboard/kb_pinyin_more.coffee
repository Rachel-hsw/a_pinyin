# kb_pinyin_more.coffee, a_pinyin/apk/src/keyboard/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  StyleSheet

  View
  Text
  ScrollView
} = require 'react-native'

style = require '../style'
{
  Touch
  KbFlex
} = require './_kb_sub'
config = require '../config'

{
  ss
} = style
# local styles
s = StyleSheet.create {
  left_line_view: {
    borderTopWidth: style.KB_BUTTON_BORDER_WIDTH
    marginLeft: style.KB_PINYIN_MORE_LINE_MARGIN
    marginRight: style.KB_PINYIN_MORE_LINE_MARGIN
  }

  kb_view: {
    flex: 1
    flexDirection: 'row'
  }
  right_view: {
    width: style.KB_PINYIN_MORE_RIGHT_WIDTH
    marginTop: style.KB_PAD_V
  }

  right_button: {
    height: style.KB_SYM_LINE_HEIGHT
  }
  sec_view: {
    borderWidth: style.BORDER_WIDTH / 2
  }
  reset_button: {
    fontSize: style.TEXT_SIZE
  }
}


_calc_lines_to_render = (raw) ->
  line_width = config.PINYIN_MORE_PER_LINE

  one_width = (x) ->
    # assert: x > 0
    # fix for 2
    if x is 2
      1.5
    else if x > 9  # TODO 9 ?
      line_width
    else
      Math.floor(x / 2) + 1

  o = []
  one_width_rest = line_width
  one = []
  # check and commit line
  commit_line = ->
    if one.length < 1
      return
    # check add null placeholder
    if one_width_rest > 0
      one.push [one_width_rest]
    o.push one
    one = []
    one_width_rest = line_width

  for t in raw  # process each text
    w = one_width t.length
    # check for too big w
    if w >= line_width
      commit_line()
      # add one new line
      o.push [[w, t]]
      continue
    # check line rest length
    if one_width_rest >= w
      one.push [w, t]
      one_width_rest -= w

      if one_width_rest < 1
        commit_line()
      continue
    # overflow, commit exist line
    commit_line()

    one.push [w, t]
    one_width_rest -= w
  # check commit last line
  commit_line()
  o


KbPinyinMore = cC {
  displayName: 'KbPinyinMore'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired
    list: PropTypes.array.isRequired

    on_text: PropTypes.func.isRequired
    on_reset: PropTypes.func.isRequired
    on_back: PropTypes.func.isRequired
  }

  _render_one: (one, key) ->
    # check for placeholder
    if ! one[1]?
      return (cE KbFlex, {
        key
        style: {
          flex: one[0]  # TODO
        }
      })

    on_click = =>
      @props.on_text one[1]

    (cE KbFlex, {
      key
      style: {
        flex: one[0]
      } },
      (cE Touch, {
        co: @props.co
        vibration_ms: @props.vibration_ms
        text: one[1]
        on_click
        })
    )

  _render_lines: (lines, key_item, key_line) ->
    o = []
    # render each line
    for l in lines
      one = []
      # render each item
      for i in l
        one.push @_render_one(i, key_item)
        key_item += 1

      o.push (cE View, {
        key: key_line
        style: ss.kb_sym_line_view
        },
        one
      )
      key_line += 1
    o

  _render_left: ->
    o = []

    key_item = 0
    key_line = 0
    # render each part
    for i in @props.list
      lines = _calc_lines_to_render i
      one = @_render_lines lines, key_item, key_line
      o = o.concat one
      key_item += i.length
      key_line += lines.length
      # line border
      o.push (cE View, {
        key: key_line
        style: [
          s.left_line_view
          @props.co.border
        ]
      })
      key_line += 1

    (cE ScrollView, {
      style: ss.kb_scrollview
      },
      (cE View, {
        style: ss.kb_view
        },
        o
      )
    )

  render: ->
    view_style = [
      s.sec_view
    ]
    text_style = [
      @props.co.kb_sec_text
    ]
    (cE View, {
      style: s.kb_view
      },
      @_render_left()
      # right part
      (cE View, {
        style: s.right_view
        },
        # more_back button
        (cE View, {
          style: s.right_button
          },
          (cE Touch, {
            co: @props.co
            vibration_ms: @props.vibration_ms
            text: '⇑'
            view_style
            text_style
            on_click: @props.on_back
            })
        )
        # reset button
        (cE View, {
          style: s.right_button
          },
          (cE Touch, {
            co: @props.co
            vibration_ms: @props.vibration_ms
            text: '重输'
            view_style
            text_style: [
              text_style
              s.reset_button
            ]
            on_click: @props.on_reset
            })
        )
      )
    )
}

module.exports = KbPinyinMore
