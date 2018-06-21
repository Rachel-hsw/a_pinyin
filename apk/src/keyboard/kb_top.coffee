# kb_top.coffee, a_pinyin/apk/src/keyboard/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
} = require 'react-native'

s = require './_kb_style'
{
  SimpleTouch
} = require './_kb_key'


KbTopButton = cC {
  displayName: 'KbTopButton'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired
    kb: PropTypes.string.isRequired  # current kb name
    style: PropTypes.any  # style for Text

    name: PropTypes.string.isRequired
    text: PropTypes.string.isRequired

    on_set_kb: PropTypes.func.isRequired
  }

  _on_click: ->
    @props.on_set_kb @props.name

  render: ->
    # merge styles
    style = [  # Text
      s.top_text
      @props.co.kb_top_text
    ]
    style_view = [  # View
      s.top_button
      @props.co.kb_top_view
    ]
    if @props.name is @props.kb
      style.push @props.co.kb_top_text_active
      style_view.push @props.co.kb_top_view_active
    # override style
    style.push @props.style

    (cE SimpleTouch, {
      co: @props.co
      vibration_ms: @props.vibration_ms
      style
      style_view
      text: @props.text
      on_click: @_on_click
      })
}

KbTopButtonLeft = cC {
  displayName: 'KbTopButtonLeft'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired
    kb: PropTypes.string.isRequired  # current kb name

    name: PropTypes.string.isRequired
    text: PropTypes.string.isRequired
    is_nolog: PropTypes.bool.isRequired

    on_set_kb: PropTypes.func.isRequired
  }

  render: ->
    # merge styles
    style = [  # Text
    ]
    text = @props.text
    if @props.is_nolog
      text = '无'
      style.push s.top_text_nolog
      # if active, not set text color
      if @props.name != @props.kb
        style.push @props.co.kb_top_text_nolog

    (cE KbTopButton, {
      co: @props.co
      vibration_ms: @props.vibration_ms
      kb: @props.kb
      style
      name: @props.name
      text
      on_set_kb: @props.on_set_kb
      })
}

KbTop = cC {
  displayName: 'KbTop'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired

    kb: PropTypes.string.isRequired
    is_nolog: PropTypes.bool.isRequired

    on_set_kb: PropTypes.func.isRequired
    on_close: PropTypes.func.isRequired
  }

  _render_left: ->
    (cE KbTopButtonLeft, {
      co: @props.co
      vibration_ms: @props.vibration_ms
      kb: @props.kb
      name: 'more'
      text: '+'
      is_nolog: @props.is_nolog
      on_set_kb: @props.on_set_kb
      })

  _render_button: (name, text) ->
    (cE KbTopButton, {
      co: @props.co
      vibration_ms: @props.vibration_ms
      kb: @props.kb
      name
      text
      on_set_kb: @props.on_set_kb
      })

  _render_close: ->
    (cE SimpleTouch, {
      co: @props.co
      vibration_ms: @props.vibration_ms
      style: s.top_text
      style_view: s.top_button
      text: '-'
      on_click: @props.on_close
      })

  render: ->
    (cE View, {
      style: [
        s.kb_top
        @props.co.border
      ] },
      @_render_left()
      @_render_button 'english', 'A'
      @_render_button 'pinyin', '拼'
      @_render_button 'number', '2'
      @_render_button 'symbol', '@'
      @_render_button 'symbol2', '。'
      # placeholder
      (cE View, {
        style: s.top_space
        })
      @_render_close()
    )
}

module.exports = KbTop
