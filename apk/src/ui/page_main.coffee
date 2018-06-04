# page_main.coffee, a_pinyin/apk/src/ui/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  Text

  Dimensions
  Image
} = require 'react-native'

{
  PageTop
  RightItem
  ScrollPage

  s
} = require './sub'
img = require '../img'


PageMain = cC {
  displayName: 'PageMain'

  propTypes: {
    co: PropTypes.object.isRequired
    db_ok: PropTypes.bool

    on_show_debug: PropTypes.func.isRequired
    on_show_about: PropTypes.func.isRequired
    on_show_db: PropTypes.func.isRequired
    on_show_config: PropTypes.func.isRequired
  }

  _render_main_logo: ->
    (cE Image, {
      source: img.MAIN_LOGO
      resizeMode: 'contain'
      style: {
        width: Dimensions.get('window').width
        height: Dimensions.get('window').width
      } })

  _render_db_button: ->
    sec = ''
    if @props.db_ok is false
      sec = '错误 !'
    @_render_one_button '数据', @props.on_show_db, sec

  _render_one_button: (text, on_click, text_sec) ->
    (cE RightItem, {
      co: @props.co
      text
      text_sec
      on_click
      })

  _get_top_text: ->
    if __DEV__
      'A拼音 (DEV)'
    else
      'A拼音'

  render: ->
    (cE ScrollPage, {
      co: @props.co
      top: (cE PageTop, {
        co: @props.co
        text: @_get_top_text()
        on_click: @props.on_show_debug
        })
      },
      @_render_main_logo()
      # gap
      (cE View, { style: s.fill_view })
      # config page
      @_render_one_button '设置', @props.on_show_config, ''
      @_render_db_button()
      # about button
      @_render_one_button '关于', @props.on_show_about, ''
    )
}

# connect for redux
{ connect } = require 'react-redux'

action = require '../redux/action'
op = require '../redux/op'

mapStateToProps = ($$state, props) ->
  {
    db_ok: $$state.getIn ['db', 'ok']
  }

mapDispatchToProps = (dispatch, props) ->
  o = Object.assign {}, props

  o

module.exports = connect(mapStateToProps, mapDispatchToProps)(PageMain)
