# kb_symbol2.coffee, a_pinyin/apk/src/keyboard/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  ScrollView
} = require 'react-native'

{ ss } = require '../style'
{
  Touch
  KbFlex
} = require './_kb_sub'
config = require '../config'


KbSymbol2 = cC {
  displayName: 'KbSymbol2'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired
    list: PropTypes.array.isRequired

    on_text: PropTypes.func.isRequired
    reload: PropTypes.func.isRequired
  }

  componentWillUnmount: ->
    @props.reload()

  _render_one: (text, key) ->
    on_click = =>
      @props.on_text text

    (cE KbFlex, {
      key
      },
      (cE Touch, {
        co: @props.co
        vibration_ms: @props.vibration_ms
        text
        on_click
        })
    )

  _render_one_line: (raw, i) ->
    b = []
    for j in [0... config.SYMBOL_PER_LINE]
      if (i + j) >= raw.length
        b.push (cE KbFlex, { key: i + j })  # placeholder
      else
        b.push @_render_one(raw[i + j], i + j)

    (cE View, {
      key: i
      style: ss.kb_sym_line_view
      },
      b
    )

  render: ->
    raw = @props.list  # support dynamic order
    lines = []
    i = 0
    while i < raw.length
      lines.push @_render_one_line(raw, i)
      i += config.SYMBOL_PER_LINE

    # support scroll here
    (cE ScrollView, {
      style: ss.kb_scrollview
      },
      (cE View, {
        style: ss.kb_view
        },
        lines
      )
    )
}

module.exports = KbSymbol2
