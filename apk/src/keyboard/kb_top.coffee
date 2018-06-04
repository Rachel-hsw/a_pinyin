# kb_top.coffee, a_pinyin/apk/src/keyboard/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  StyleSheet

  View
  Text
} = require 'react-native'

style = require '../style'

{ Touch } = require './_kb_sub'

{
  ss
} = style
# local styles
s = StyleSheet.create {
  button_view: {
    height: '100%'
    width: style.KB_TOP_WIDTH
  }

  top_text_style: {
    fontSize: style.TITLE_SIZE
  }
  top_text_style_nolog: {
    fontWeight: 'bold'
  }

  space_view: {
    flex: 1
  }
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

  _render_button: (text, on_click, view_style, text_style) ->
    (cE View, {
      style: s.button_view
      },
      (cE Touch, {
        co: @props.co
        vibration_ms: @props.vibration_ms
        text
        view_style
        text_style
        on_click
        })
    )

  # render the left most button
  _render_left: (name, text, kb) ->
    on_click = =>
      @props.on_set_kb name
    view_style = [
      @props.co.kb_top_view
    ]
    text_style = [
      s.top_text_style
      @props.co.kb_top_text
    ]
    if name is kb
      view_style.push @props.co.kb_top_view_active
      text_style.push @props.co.kb_top_text_active
    if @props.is_nolog
      text = '无'
      text_style.push s.top_text_style_nolog
      text_style.push @props.co.kb_top_text_nolog

    @_render_button text, on_click, view_style, text_style

  _render_one: (name, text, kb) ->
    on_click = =>
      @props.on_set_kb name
    view_style = [
      @props.co.kb_top_view
    ]
    text_style = [
      s.top_text_style
      @props.co.kb_top_text
    ]
    if name is kb
      view_style.push @props.co.kb_top_view_active
      text_style.push @props.co.kb_top_text_active
    @_render_button text, on_click, view_style, text_style

  render: ->
    view_style = [
      @props.co.kb_top_view
    ]
    text_style = [
    ]

    (cE View, {
      style: [
        ss.kb_top_view
        @props.co.border
      ] },
      # buttons
      @_render_left 'more', '+', @props.kb
      @_render_one 'english', 'A', @props.kb
      @_render_one 'pinyin', '拼', @props.kb
      @_render_one 'number', '2', @props.kb
      @_render_one 'symbol', '@', @props.kb
      @_render_one 'symbol2', '。', @props.kb
      # space
      (cE View, {
        style: s.space_view
        })
      # close button
      @_render_button '-', @props.on_close, view_style, text_style
    )
}

module.exports = KbTop
