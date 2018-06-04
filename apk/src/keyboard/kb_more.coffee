# kb_more.coffee, a_pinyin/apk/src/keyboard/

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
} = require './_kb_sub'

{
  ss
} = style
# local styles
s = StyleSheet.create {
  button_view: {
    borderWidth: style.BORDER_WIDTH / 2
  }
  button_text: {
    fontSize: style.TEXT_SIZE
  }

  nolog_text: {
    fontSize: style.TEXT_SIZE
  }

  title_text: {
    fontSize: style.TEXT_SIZE
  }

  option_view: {
    flexDirection: 'row'
    marginTop: style.KB_PAD_V
    height: 50  # TODO
  }
}


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

    view_style = [
      s.button_view
      @props.co.kb_more_button_view
    ]
    text_style = [
      s.button_text
      @props.co.kb_more_button_text
    ]
    if (current is value) or (current is true)
      view_style.push @props.co.kb_more_button_view_active
      text_style.push @props.co.kb_more_button_text_active

    (cE KbFlex, null,
      (cE Touch, {
        co: @props.co
        text: value
        view_style
        text_style
        on_click
        })
    )

  _render_nolog_notice: ->
    if @props.is_nolog
      (cE Text, {
        style: [
          s.nolog_text
          @props.co.kb_more_nolog_text
        ] },
        '无痕模式: 输入法不会记录任何用户输入.'
      )

  render: ->
    (cE View, {
      style: {
        # TODO
      } },
      # TODO TODO support scroll ?

      @_render_nolog_notice()
      # set nolog
      (cE View, {
        style: {
          # TODO
        } },
        (cE Text, {
          style: [
            s.title_text
            @props.co.kb_more_title
          ] },
          '工作模式'
        )
        (cE View, {
          style: s.option_view
          },
          @_render_one_button '普通模式', ! @props.is_nolog, @_on_set_mode_normal
          @_render_one_button '无痕模式', @props.is_nolog, @_on_set_mode_nolog
        )
      )
      # set layout
      (cE View, {
        style: {
          # TODO
        } },
        (cE Text, {
          style: [
            s.title_text
            @props.co.kb_more_title
          ] },
          '键盘布局'
        )
        (cE View, {
          style: s.option_view
          },
          @_render_one_button 'qwerty', @props.layout, @props.on_set_layout
          @_render_one_button 'dvorak', @props.layout, @props.on_set_layout
          @_render_one_button 'abcd1097', @props.layout, @props.on_set_layout
          @_render_one_button 'abcd7109', @props.layout, @props.on_set_layout
        )
      )
      # TODO
    )
}

module.exports = KbMore
