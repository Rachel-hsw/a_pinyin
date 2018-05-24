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

    on_show_debug: PropTypes.func.isRequired
    on_show_about: PropTypes.func.isRequired
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
    (cE View, {
      style: {
        height: ss.TOP_HEIGHT
      } },
      (cE TouchableNativeFeedback, {
        onPress: @props.on_show_about
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
          (cE Text, {
            style: {
              flex: 1
              paddingLeft: ss.TOP_PADDING
              fontSize: ss.TITLE_SIZE
              color: @props.co.TEXT
            } },
            "关于"
          )
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
          @_render_about_button()
        )
      )
    )
}

module.exports = PageMain
