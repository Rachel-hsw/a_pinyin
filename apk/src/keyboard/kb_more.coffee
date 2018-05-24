# kb_more.coffee, a_pinyin/apk/src/keyboard/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  Text
} = require 'react-native'

co = require '../color'
ss = require '../style'

{
  Touch
  KbFlex
} = require './_kb_sub'


KbMore = cC {
  displayName: 'KbMore'
  propTypes: {
    co: PropTypes.object.isRequired
    co_name: PropTypes.string.isRequired
    layout: PropTypes.string.isRequired
    is_nolog: PropTypes.bool.isRequired

    on_set_layout: PropTypes.func.isRequired
    on_set_co: PropTypes.func.isRequired
    on_set_nolog: PropTypes.func.isRequired
  }

  _on_set_mode_normal: ->
    @props.on_set_nolog false

  _on_set_mode_nolog: ->
    @props.on_set_nolog true

  _render_one_button: (value, current, callback) ->
    on_click = =>
      callback value

    color = @props.co.TEXT_SEC
    bg = @props.co.BG
    if (current is value) or (current is true)
      color = @props.co.BG
      bg = @props.co.TEXT_SEC

    (cE KbFlex, null,
      (cE Touch, {
        co: @props.co
        text: value
        border: true
        color
        bg
        on_click
        font_size: ss.TEXT_SIZE
        })
    )

  _render_nolog_notice: ->
    if @props.is_nolog
      (cE Text, {
        style: {
          fontSize: ss.TEXT_SIZE
          color: @props.co.NOLOG
        } },
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
          style: {
            fontSize: ss.TEXT_SIZE
            color: @props.co.TEXT
          } },
          '工作模式'
        )
        (cE View, {
          style: {
            flexDirection: 'row'
            marginTop: ss.KB_PAD_V
            height: 50  # TODO
          } },
          @_render_one_button '普通模式', ! @props.is_nolog, @_on_set_mode_normal
          @_render_one_button '无痕模式', @props.is_nolog, @_on_set_mode_nolog
        )
      )
      # set co
      (cE View, {
        style: {
          # TODO
        } },
        (cE Text, {
          style: {
            fontSize: ss.TEXT_SIZE
            color: @props.co.TEXT
          } },
          '颜色主题'
        )
        (cE View, {
          style: {
            flexDirection: 'row'
            marginTop: ss.KB_PAD_V
            height: 50  # TODO
          } },
          @_render_one_button 'dark', @props.co_name, @props.on_set_co
          @_render_one_button 'light', @props.co_name, @props.on_set_co
        )
      )
      # set layout
      (cE View, {
        style: {
          # TODO
        } },
        (cE Text, {
          style: {
            fontSize: ss.TEXT_SIZE
            color: @props.co.TEXT
          } },
          '键盘布局'
        )
        (cE View, {
          style: {
            flexDirection: 'row'
            marginTop: ss.KB_PAD_V
            height: 50  # TODO
          } },
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
