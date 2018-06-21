# page_config.coffee, a_pinyin/apk/src/ui/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  Text
  TextInput

  Switch
} = require 'react-native'

# for core config
im_native = require '../im_native'

s = require './_style'
{
  PageTop
  ScrollPage
} = require './_sub'


ConfigItem = cC {
  displayName: 'ConfigItem'

  propTypes: {
    co: PropTypes.object.isRequired

    text: PropTypes.string.isRequired
    text_sec: PropTypes.string.isRequired
    children: PropTypes.node  # right control
  }

  render: ->
    (cE View, {
      style: [
        s.config_item_view
        @props.co.border
      ] },
      (cE View, {
        style: s.config_item_left_view
        },
        (cE Text, {
          style: [
            s.config_item_title_text
            @props.co.ui_text
          ] },
          @props.text
        )
        (cE Text, {
          style: [
            s.config_item_text
            @props.co.ui_text_sec
          ] },
          @props.text_sec
        )
      )
      # right part
      (cE View, {
        style: s.config_item_right_view
        },
        @props.children
      )
    )
}

PageConfig = cC {
  displayName: 'PageConfig'

  propTypes: {
    co: PropTypes.object.isRequired

    is_light_theme: PropTypes.bool.isRequired
    vibration_ms: PropTypes.number.isRequired
    core_level: PropTypes.number

    on_init: PropTypes.func.isRequired

    on_change_theme: PropTypes.func.isRequired
    on_set_vibration_ms: PropTypes.func.isRequired
    on_change_core_level: PropTypes.func.isRequired

    on_show_page: PropTypes.func.isRequired
    on_back: PropTypes.func.isRequired
  }

  componentDidMount: ->
    @props.on_init()

  _on_show_page_post: ->
    @props.on_show_page 'config_post'

  _on_change_theme: ->
    @props.on_change_theme(! @props.is_light_theme)

  _on_change_vibration_ms: (text) ->
    if text.trim().length < 1
      n = 0
    else
      n = Number.parseInt text
    if ! Number.isNaN(n)
      @props.on_set_vibration_ms n

  _on_change_core_level: ->
    @props.on_change_core_level @props.core_level

  _render_theme: ->
    text_sec = '当前是 深色主题.'
    if @props.is_light_theme
      text_sec = '当前是 浅色主题.'

    (cE ConfigItem, {
      co: @props.co
      text: '启用浅色界面'
      text_sec
      },
      (cE Switch, {
        value: @props.is_light_theme
        onValueChange: @_on_change_theme
        })
    )

  _render_vibration: ->
    (cE ConfigItem, {
      co: @props.co
      text: '按键振动时间'
      text_sec: '单位: 毫秒 (ms)  设为 0 禁用振动.'
      },
      (cE TextInput, {
        value: "#{@props.vibration_ms}"
        onChangeText: @_on_change_vibration_ms
        maxLength: 4  # TODO
        style: [
          s.config_input
          @props.co.ui_text
        ] })
    )

  _render_core_level: ->
    value = false
    disabled = false
    if ! @props.core_level?
      disabled = true
    else if @props.core_level is im_native.CORE_LEVEL_MAX
      value = true

    (cE ConfigItem, {
      co: @props.co
      text: '启用生僻汉字'
      text_sec: '可以输入常用 7000 汉字之外的\n汉字 ( 3 万多个).'
      },
      (cE Switch, {
        value
        disabled
        onValueChange: @_on_change_core_level
        })
    )

  render: ->
    (cE ScrollPage, {
      co: @props.co
      top: (cE PageTop, {
        co: @props.co
        text: '设置'
        on_back: @props.on_back
        })
      margin: true
      },
      # UI config
      @_render_theme()
      @_render_vibration()
      # core config
      @_render_core_level()
      # TODO
      # placeholder
      (cE View, {
        style: s.fill_view
        })
    )
}

# connect for redux
{ connect } = require 'react-redux'

action = require '../redux/action'
op = require '../redux/op'

mapStateToProps = ($$state, props) ->
  is_light_theme = false
  if $$state.get('co') is 'light'
    is_light_theme = true

  $$config = $$state.get 'config'
  {
    is_light_theme
    vibration_ms: $$config.get 'vibration_ms'
    core_level: $$config.get 'core_level'
  }

mapDispatchToProps = (dispatch, props) ->
  o = Object.assign {}, props
  o.on_init = ->
    dispatch op.load_core_config()

  o.on_change_theme = (raw) ->
    co = if raw
        'light'
      else
        'dark'
    dispatch action.set_co(co)
  o.on_set_vibration_ms = (value) ->
    dispatch action.update_config({
      vibration_ms: value
    })

  o.on_change_core_level = (old_level) ->
    level = if old_level is im_native.CORE_LEVEL_MAX
        im_native.CORE_LEVEL_DEFAULT
      else
        im_native.CORE_LEVEL_MAX
    dispatch op.set_core_level(level)

  o

module.exports = connect(mapStateToProps, mapDispatchToProps)(PageConfig)
