# kb_number.coffee, a_pinyin/apk/src/keyboard/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
} = require 'react-native'

s = require './_kb_style'
{
  TEXT_KEY_ENTER

  SimpleTouch
  KbSecButton
  KbDeleteKey
} = require './_kb_key'


KbNumber = cC {
  displayName: 'KbNumber'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired

    on_text: PropTypes.func.isRequired
    on_key_delete: PropTypes.func.isRequired
    on_key_enter: PropTypes.func.isRequired
  }

  _on_click_space: ->
    @props.on_text ' '

  _render_button_main: (text) ->
    (cE SimpleTouch, {
      co: @props.co
      vibration_ms: @props.vibration_ms
      style_view: s.n_button
      text
      on_click: @props.on_text
      })

  _render_button_sec: (text) ->
    style = [
      @props.co.kb_sec_text
    ]
    (cE SimpleTouch, {
      co: @props.co
      vibration_ms: @props.vibration_ms
      style
      style_view: s.n_button
      text
      on_click: @props.on_text
      })

  _render_space: ->
    (cE KbSecButton, {
      co: @props.co
      vibration_ms: @props.vibration_ms
      style: s.n_button
      text: ''  # space button, without text
      on_click: @_on_click_space
      })

  _render_enter: ->
    (cE KbSecButton, {
      co: @props.co
      vibration_ms: @props.vibration_ms
      style: s.n_button
      text: TEXT_KEY_ENTER
      on_click: @props.on_key_enter
      })

  _render_left: ->
    (cE View, {
      style: s.n_left
      },
      @_render_button_sec '+'
      @_render_button_sec '-'
      @_render_button_sec '*'
      @_render_button_sec '/'
    )

  _render_main: ->
    (cE View, {
      style: s.n_main
      },
      # line 1
      (cE View, {
        style: s.n_main_line
        },
        @_render_button_main '7'
        @_render_button_main '8'
        @_render_button_main '9'
      )
      # line 2
      (cE View, {
        style: s.n_main_line
        },
        @_render_button_main '4'
        @_render_button_main '5'
        @_render_button_main '6'
      )
      # line 3
      (cE View, {
        style: s.n_main_line
        },
        @_render_button_main '1'
        @_render_button_main '2'
        @_render_button_main '3'
      )
      # line 4
      (cE View, {
        style: s.n_main_line
        },
        @_render_button_main '0'
        @_render_space()
        @_render_button_main '.'
      )
    )

  _render_right: ->
    (cE View, {
      style: s.n_right
      },
      # delete key
      (cE KbDeleteKey, {
        co: @props.co
        vibration_ms: @props.vibration_ms
        style: s.n_button
        on_delete: @props.on_key_delete
        })
      @_render_button_sec '%'
      @_render_button_sec ','
      @_render_enter()
    )

  render: ->
    (cE View, {
      style: [
        s.kb_view
        s.n_view
      ] },
      @_render_left()
      (cE View, {
        style: s.n_right_part
        },
        @_render_main()
        @_render_right()
      )
    )
}

module.exports = KbNumber
