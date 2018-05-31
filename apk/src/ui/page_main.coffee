# page_main.coffee, a_pinyin/apk/src/ui/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  Text

  ScrollView
  TouchableNativeFeedback

  Dimensions
  Image
} = require 'react-native'

ss = require '../style'

{
  PageTop
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
  }

  _render_main_logo: ->
    (cE Image, {
      source: img.MAIN_LOGO
      resizeMode: 'contain'
      style: {
        width: Dimensions.get('window').width
        height: Dimensions.get('window').width
      } })

  _render_about_button: ->
    @_render_one_button '关于', @props.on_show_about, ''

  _render_db_button: ->
    sec = ''
    if @props.db_ok is false
      sec = '错误 !'
    @_render_one_button '数据库', @props.on_show_db, sec

  _render_one_button: (text, on_click, sec) ->
    (cE View, {
      style: {
        height: ss.TOP_HEIGHT
      } },
      (cE TouchableNativeFeedback, {
        onPress: on_click
        background: TouchableNativeFeedback.Ripple @props.co.BG_SEC
        },
        (cE View, {
          style: {
            height: ss.TOP_HEIGHT
            width: '100%'
            flexDirection: 'row'
            justifyContent: 'center'
            alignItems: 'center'
          } },
          # left text
          (cE Text, {
            style: {
              paddingLeft: ss.TOP_PADDING
              fontSize: ss.TITLE_SIZE
              color: @props.co.TEXT
            } },
            text
          )
          # sec text
          (cE Text, {
            style: {
              flex: 1
              paddingLeft: ss.TOP_PADDING
              fontSize: ss.TITLE_SIZE
              color: @props.co.NOLOG
            } },
            sec
          )
          # right >
          (cE Text, {
            style: {
              width: ss.TOP_HEIGHT
              fontSize: ss.TITLE_SIZE
              color: @props.co.TEXT_SEC
              textAlign: 'center'
            } },
            ">"
          )
        )
      )
    )

  render: ->
    (cE View, {
      style: {
        flex: 1
        flexDirection: 'column'
      } },
      (cE PageTop, {
        co: @props.co
        text: 'A拼音'
        on_click: @props.on_show_debug
        })
      (cE ScrollView, {
        style: {
          flex: 1
          flexDirection: 'column'
        }
        contentContainerStyle: {
          flexGrow: 1
        } },
        (cE View, {
          style: {
            flex: 1
            flexDirection: 'column'
          } },
          @_render_main_logo()
          # gap
          (cE View, {
            style: {
              flex: 1
            } })
          @_render_db_button()
          @_render_about_button()
        )
      )
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
