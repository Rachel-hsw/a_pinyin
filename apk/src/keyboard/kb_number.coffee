# kb_number.coffee, a_pinyin/apk/src/keyboard/

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
  KbFlex
  KbLine
  KbSpaceButton
  KbDeleteKey
  KbEnterKey
} = require './_kb_sub'

{
  ss
} = style
# local styles
s = StyleSheet.create {
  kb_view: {
    flexDirection: 'row'
  }

  view_left: {
    flex: 1
  }
  view_main: {
    width: style.KB_NUMBER_WIDTH
    flexShrink: 0
  }
  flex_right: {
    flex: style.KB_NUMBER_RIGHT_BUTTON_FLEX
  }
}


TextButton = cC {
  displayName: 'TextButton'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired
    text: PropTypes.string.isRequired
    char: PropTypes.string.isRequired
    is_second: PropTypes.bool
    no_flex: PropTypes.bool

    on_text: PropTypes.func.isRequired
  }

  _on_click: ->
    @props.on_text @props.char

  render: ->
    text_style = []
    if @props.is_second
      text_style.push @props.co.kb_sec_text

    touch = (cE Touch, {
      co: @props.co
      vibration_ms: @props.vibration_ms
      text: @props.text
      text_style
      on_click: @_on_click
      })

    if @props.no_flex
      touch
    else
      (cE KbFlex, null,
        touch
      )
}

KbNumber = cC {
  displayName: 'KbNumber'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired

    on_text: PropTypes.func.isRequired
    on_key_delete: PropTypes.func.isRequired
    on_key_enter: PropTypes.func.isRequired
  }

  _render_button: (text, char, is_second, no_flex) ->
    (cE TextButton, {
      co: @props.co
      vibration_ms: @props.vibration_ms
      text
      char
      is_second
      no_flex

      on_text: @props.on_text
      })

  render: ->
    (cE View, {
      style: [
        ss.kb_view
        s.kb_view
      ] },
      # left part
      (cE View, {
        style: s.view_left
        },
        # add '+', '-', '*', '/' buttons here
        (cE KbLine, null,
          @_render_button '+', '+', true
        )
        (cE KbLine, null,
          @_render_button '-', '-', true
        )
        (cE KbLine, null,
          @_render_button '*', '*', true
        )
        (cE KbLine, null,
          @_render_button '/', '/', true
        )
      )
      # main part
      (cE View, {
        style: s.view_main
        },
        (cE KbLine, null,
          @_render_button '7', '7'
          @_render_button '8', '8'
          @_render_button '9', '9'
          # delete key
          (cE KbFlex, {
            style: s.flex_right
            },
            (cE KbDeleteKey, {
              co: @props.co
              vibration_ms: @props.vibration_ms
              on_delete: @props.on_key_delete
              })
          )
        )
        (cE KbLine, null,
          @_render_button '4', '4'
          @_render_button '5', '5'
          @_render_button '6', '6'
          # '%' button here
          (cE KbFlex, {
            style: s.flex_right
            },
            @_render_button '%', '%', true, true
          )
        )
        (cE KbLine, null,
          @_render_button '1', '1'
          @_render_button '2', '2'
          @_render_button '3', '3'
          # ',' button here
          (cE KbFlex, {
            style: s.flex_right
            },
            @_render_button ',', ',', true, true
          )
        )
        (cE KbLine, null,
          @_render_button '0', '0'
          # space button
          (cE KbFlex, null,
            (cE KbSpaceButton, {
              co: @props.co
              vibration_ms: @props.vibration_ms
              on_text: @props.on_text
              })
          )
          @_render_button '.', '.'
          # enter key
          (cE KbFlex, {
            style: s.flex_right
            },
            (cE KbEnterKey, {
              co: @props.co
              vibration_ms: @props.vibration_ms
              on_click: @props.on_key_enter
              })
          )
        )
      )
    )
}

module.exports = KbNumber
