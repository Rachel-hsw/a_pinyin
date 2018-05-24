# kb_symbol.coffee, a_pinyin/apk/src/keyboard/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
} = require 'react-native'

ss = require '../style'
{
  Touch
  KbFlex
} = require './_kb_sub'
config = require '../config'


KbSymbol = cC {
  displayName: 'KbSymbol'
  propTypes: {
    co: PropTypes.object.isRequired
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
      style: {
        flexDirection: 'row'
        height: ss.KB_SYM_LINE_HEIGHT
      } },
      b
    )

  render: ->
    raw = @props.list  # support dynamic order
    lines = []
    i = 0
    while i < raw.length
      lines.push @_render_one_line(raw, i)
      i += config.SYMBOL_PER_LINE

    # 32 in 4 lines, no need to scroll
    (cE View, {
      style: {
        flex: 1
        marginTop: ss.KB_PAD_V
      } },
      lines
    )
}

module.exports = KbSymbol
