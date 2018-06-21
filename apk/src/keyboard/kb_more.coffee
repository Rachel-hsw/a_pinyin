# kb_more.coffee, a_pinyin/apk/src/keyboard/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  Text
} = require 'react-native'

s = require './_kb_style'
{
  SimpleTouch
} = require './_kb_key'


KbMore = cC {
  displayName: 'KbMore'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired
    layout: PropTypes.string.isRequired
    is_nolog: PropTypes.bool.isRequired

    on_set_layout: PropTypes.func.isRequired
    on_set_nolog: PropTypes.func.isRequired
  }

  _on_set_mode_normal: ->
    @props.on_set_nolog false

  _on_set_mode_nolog: ->
    @props.on_set_nolog true

  _render_one_button: (value, current, callback) ->
    on_click = =>
      callback value

    style = [  # Text
      s.m_button_text
      @props.co.kb_more_button_text
    ]
    style_view = [
      s.m_button
      @props.co.kb_more_button_view
    ]
    if (current is value) or (current is true)
      style.push @props.co.kb_more_button_text_active
      style_view.push @props.co.kb_more_button_view_active

    (cE View, {
      style: s.m_flex
      },
      (cE SimpleTouch, {
        co: @props.co
        style
        style_view
        text: value
        on_click
        })
    )

  _render_nolog_notice: ->
    if @props.is_nolog
      (cE Text, {
        style: [
          s.m_text_nolog
          @props.co.kb_more_nolog_text
        ] },
        '无痕模式: 输入法不会记录任何用户输入.'
      )

  _render_title: (text) ->
    (cE Text, {
      style: [
        s.m_text_title
        @props.co.kb_more_title
      ] },
      text
    )

  render: ->
    (cE View, {
      style: s.kb_view
      },  # no scroll here

      @_render_nolog_notice()
      # set nolog
      (cE View, {
        style: s.m_pad
        },
        @_render_title '工作模式'
        (cE View, {
          style: s.m_option
          },
          @_render_one_button '普通模式', ! @props.is_nolog, @_on_set_mode_normal
          @_render_one_button '无痕模式', @props.is_nolog, @_on_set_mode_nolog
        )
      )
      # set layout
      (cE View, {
        style: s.m_pad
        },
        @_render_title '键盘布局'
        (cE View, {
          style: s.m_option
          },
          @_render_one_button 'qwerty', @props.layout, @props.on_set_layout
          @_render_one_button 'dvorak', @props.layout, @props.on_set_layout
          @_render_one_button 'abcd1097', @props.layout, @props.on_set_layout
          @_render_one_button 'abcd7109', @props.layout, @props.on_set_layout
        )
      )
    )
}

module.exports = KbMore
