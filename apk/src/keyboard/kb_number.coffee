# kb_number.coffee, a_pinyin/apk/src/keyboard/

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
  KbFlex
  KbLine
  KbSpaceButton
  KbDeleteKey
  KbEnterKey
} = require './_kb_sub'


TextButton = cC {
  displayName: 'TextButton'
  propTypes: {
    co: PropTypes.object.isRequired
    text: PropTypes.string.isRequired
    char: PropTypes.string.isRequired
    is_second: PropTypes.bool
    no_flex: PropTypes.bool

    on_text: PropTypes.func.isRequired
  }

  _on_click: ->
    @props.on_text @props.char

  render: ->
    color = @props.co.TEXT
    if @props.is_second
      color = @props.co.TEXT_SEC

    touch = (cE Touch, {
      co: @props.co
      text: @props.text
      color
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

    on_text: PropTypes.func.isRequired
    on_key_delete: PropTypes.func.isRequired
    on_key_enter: PropTypes.func.isRequired
  }

  _render_button: (text, char, is_second, no_flex) ->
    (cE TextButton, {
      co: @props.co
      text
      char
      is_second
      no_flex

      on_text: @props.on_text
      })

  render: ->
    (cE View, {
      style: {
        flex: 1
        flexDirection: 'row'
        marginTop: ss.KB_PAD_V
      } },
      # left part
      (cE View, {
        style: {
          flex: 1
        } },
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
        style: {
          width: ss.KB_NUMBER_WIDTH
          flexShrink: 0
        } },
        (cE KbLine, null,
          @_render_button '7', '7'
          @_render_button '8', '8'
          @_render_button '9', '9'
          # delete key
          (cE KbFlex, {
            flex: ss.KB_NUMBER_RIGHT_BUTTON_FLEX
            },
            (cE KbDeleteKey, {
              co: @props.co
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
            flex: ss.KB_NUMBER_RIGHT_BUTTON_FLEX
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
            flex: ss.KB_NUMBER_RIGHT_BUTTON_FLEX
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
              on_text: @props.on_text
              })
          )
          @_render_button '.', '.'
          # enter key
          (cE KbFlex, {
            flex: ss.KB_NUMBER_RIGHT_BUTTON_FLEX
            },
            (cE KbEnterKey, {
              co: @props.co
              on_click: @props.on_key_enter
              })
          )
        )
      )
    )
}

module.exports = KbNumber
