# kb_english.coffee, a_pinyin/apk/src/keyboard/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  StyleSheet

  View
  Text
} = require 'react-native'

{ ss } = require '../style'

{
  KbLayouts1097
  KbLayouts7109
  KbLineBottom
} = require './_kb_sub'

KB_LAYOUTS_QWERTY = [  # layouts 1097
  'qQwWeErRtTyYuUiIoOpP'
  'aAsSdDfFgGhHjJkKlL'
  'zZxXcCvVbBnNmM'
]
KB_LAYOUTS_DVORAK = [  # layouts 7109
  'pPyYfFgGcCrRlL'
  'aAoOeEuUiIdDhHtTnNsS'
  'qQjJkKxXbBmMwWvVzZ'
]
KB_LAYOUTS_ABCD1097 = [  # layouts 1097
  'aAbBcCdDeEfFgGhHiIjJ'
  'kKlLmMnNoOpPqQrRsS'
  'tTuUvVwWxXyYzZ'
]
KB_LAYOUTS_ABCD7109 = [  # layouts 7109
  'aAbBcCdDeEfFgG'
  'hHiIjJkKlLmMnNoOpPqQ'
  'rRsStTuUvVwWxXyYzZ'
]


KbEnglish = cC {
  displayName: 'KbEnglish'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired

    layout: PropTypes.string.isRequired
    no_shift: PropTypes.bool

    on_text: PropTypes.func.isRequired
    on_key_delete: PropTypes.func.isRequired
    on_key_enter: PropTypes.func.isRequired

    on_shift: PropTypes.func
  }

  getInitialState: ->
    {
      shift: false
    }

  _on_shift: ->
    if @props.no_shift
      @props.on_shift?()
    else
      @setState {
        shift: ! @state.shift
      }

  _get_layout: ->
    switch @props.layout
      when 'qwerty'
        [KB_LAYOUTS_QWERTY, KbLayouts1097]
      when 'dvorak'
        [KB_LAYOUTS_DVORAK, KbLayouts7109]
      when 'abcd1097'
        [KB_LAYOUTS_ABCD1097, KbLayouts1097]
      when 'abcd7109'
        [KB_LAYOUTS_ABCD7109, KbLayouts7109]

  render: ->
    [layouts, Layout] = @_get_layout()
    shift = @state.shift
    if @props.no_shift
      shift = null

    (cE View, {
      style: ss.kb_view
      },
      # main keyboard buttons
      (cE Layout, {
        co: @props.co
        vibration_ms: @props.vibration_ms
        shift
        layouts

        on_text: @props.on_text
        on_shift: @_on_shift
        on_key_delete: @props.on_key_delete
        })
      # button line
      (cE KbLineBottom, {
        co: @props.co
        vibration_ms: @props.vibration_ms
        shift
        on_text: @props.on_text
        on_key_enter: @props.on_key_enter
        })
    )
}

module.exports = KbEnglish
