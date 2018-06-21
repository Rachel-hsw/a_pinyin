# kb_symbol.coffee, a_pinyin/apk/src/keyboard/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
} = require 'react-native'

{
  KB_PAD_V
} = require '../style'
s = require './_kb_style'
{
  KbLayoutsBoard
} = require './_kb_board'
{
  calc_symbol
} = require './_kb_util'


KbSymbol = cC {
  displayName: 'KbSymbol'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired
    size_x: PropTypes.number.isRequired
    size_y: PropTypes.number.isRequired
    list: PropTypes.arrayOf(PropTypes.string).isRequired

    on_text: PropTypes.func.isRequired
    reload: PropTypes.func.isRequired
  }

  componentWillUnmount: ->
    @props.reload()

  _gen_layouts_data: ->
    size_x = @props.size_x
    size_y = @props.size_y - KB_PAD_V
    calc_symbol size_x, size_y, @props.list

  render: ->
    layouts_data = @_gen_layouts_data()

    (cE View, {
      style: s.kb_view  # KB_PAD_V here
      },
      (cE KbLayoutsBoard, {
        co: @props.co
        vibration_ms: @props.vibration_ms
        layouts_data
        on_text: @props.on_text
        })
    )
}

module.exports = KbSymbol
