# sub.coffee, a_pinyin/apk/src/ui/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  Text

  TouchableNativeFeedback
  TouchableWithoutFeedback
} = require 'react-native'

ss = require '../style'


PageTop = cC {
  displayName: 'PageTop'

  propTypes: {
    co: PropTypes.object.isRequired

    text: PropTypes.string.isRequired

    on_back: PropTypes.func
    on_click: PropTypes.func
  }

  _render_back: ->
    if @props.on_back?
      (cE TouchableNativeFeedback, {
        onPress: @props.on_back
        background: TouchableNativeFeedback.Ripple @props.co.BG_SEC
        },
        (cE View, {
          style: {
            width: ss.TOP_HEIGHT
            height: ss.TOP_HEIGHT
            flexDirection: 'row'
            alignItems: 'center'
            justifyContent: 'center'
          } },
          (cE Text, {
            style: {
              fontSize: ss.TITLE_SIZE
              color: @props.co.TEXT_SEC
            } },
            "<"
          )
        )
      )
    else  # placeholder
      (cE View, {
        style: {
          width: ss.TOP_HEIGHT
        } })

  _on_top_click: ->
    @props.on_click?()

  render: ->
    (cE View, {
      style: {
        height: ss.TOP_HEIGHT
        flexDirection: 'row'
        backgroundColor: @props.co.BG
        borderBottomWidth: ss.BORDER_WIDTH
        borderBottomColor: @props.co.BG_SEC
      } },
      (cE View, {
        style: {
          height: '100%'
          width: ss.TOP_HEIGHT
        } },
        @_render_back()
      )
      # top title
      (cE TouchableWithoutFeedback, {
        style: {
          height: '100%'
          flex: 1
          flexDirection: 'row'
        }
        onPress: @_on_top_click
      },
        (cE View, {
          style: {
            height: '100%'
            flex: 1
            flexDirection: 'row'
            alignItems: 'center'
            justifyContent: 'center'
          } },
          (cE Text, {
            style: {
              flex: 1
              color: @props.co.TEXT
              fontSize: ss.TITLE_SIZE
              textAlign: 'center'
            } },
            "#{@props.text}"
          )
        )
      )
      # right padding
      (cE View, {
        style: {
          width: ss.TOP_HEIGHT
        } })
    )
}

module.exports = {
  PageTop
}
