# _sub.coffee, a_pinyin/apk/src/ui/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  Text
  ScrollView

  TouchableNativeFeedback
  TouchableWithoutFeedback
} = require 'react-native'

s = require './_style'


PageTop = cC {
  displayName: 'PageTop'

  propTypes: {
    co: PropTypes.object.isRequired

    text: PropTypes.string.isRequired
    text_right: PropTypes.oneOfType [
      PropTypes.string
      PropTypes.shape {
        text: PropTypes.string.isRequired
        size_small: PropTypes.bool
      }
    ]

    on_back: PropTypes.func
    on_click: PropTypes.func
    on_click_right: PropTypes.func
  }

  _on_top_click: ->
    @props.on_click?()

  _render_button: (text, on_click, color, size_small) ->
    style = [  # Text
      s.top_back_text
      color
    ]
    if size_small
      style.push s.top_back_text_small

    (cE TouchableNativeFeedback, {
      onPress: on_click
      background: @props.co.touch_ripple
      },
      (cE View, {
        style: s.top_back_view
        },
        (cE Text, {
          style
          },
          text
        )
      )
    )

  _render_placeholder: ->
    (cE View, {
      style: s.top_placeholder
      })

  _render_back: ->
    if @props.on_back?
      @_render_button '<', @props.on_back, @props.co.ui_text_bg
    else
      @_render_placeholder()

  _render_right: ->
    if @props.text_right?
      size_small = false
      if typeof @props.text_right is 'string'
        text = @props.text_right
      else
        {
          text
          size_small
        } = @props.text_right

      @_render_button text, @props.on_click_right, @props.co.ui_text_sec, size_small
    else
      @_render_placeholder()

  render: ->
    (cE View, {
      style: [
        s.top_view
        @props.co.ui_top_view
      ] },
      # back button
      (cE View, {
        style: s.top_back_out_view
        },
        @_render_back()
      )
      # top title
      (cE TouchableWithoutFeedback, {
        style: s.top_title_touch
        onPress: @_on_top_click
        },
        (cE View, {
          style: s.top_title_view
          },
          (cE Text, {
            style: [
              s.top_title_text
              @props.co.ui_text
            ] },
            "#{@props.text}"
          )
        )
      )
      # right part
      (cE View, {
         style: s.top_back_out_view
        },
        @_render_right()
      )
    )
}

RightItem = cC {
  displayName: 'RightItem'

  propTypes: {
    co: PropTypes.object.isRequired

    text: PropTypes.string.isRequired
    text_sec: PropTypes.string

    on_click: PropTypes.func.isRequired
  }

  render: ->
    (cE View, {
      style: s.ri_view
      },
      (cE TouchableNativeFeedback, {
        onPress: @props.on_click
        background: @props.co.touch_ripple
        },
        (cE View, {
          style: s.ri_in_view
          },
          # left text
          (cE Text, {
            style: [
              s.ri_text
              @props.co.ui_text
            ] },
            @props.text
          )
          # sec text
          (cE Text, {
            style: [
              s.ri_text
              s.ri_text_sec
              @props.co.ui_text_nolog
            ] },
            @props.text_sec
          )
          # right >
          (cE Text, {
            style: [
              s.ri_right_text
              @props.co.ui_text_bg
            ] },
            ">"
          )
        )
      )
    )
}

ScrollPage = cC {
  displayName: 'ScrollPage'

  propTypes: {
    co: PropTypes.object.isRequired
    top: PropTypes.object.isRequired
    margin: PropTypes.bool
    children: PropTypes.node
  }

  render: ->
    in_view_style = [
      s.sp_view
    ]
    if @props.margin
      in_view_style.push s.sp_view_margin

    (cE View, {
      style: s.sp_view
      },
      # PageTop
      @props.top
      # main scroll content
      (cE ScrollView, {
        style: s.sp_view
        contentContainerStyle: s.sp_scrollview_container
        },
        (cE View, {
          style: in_view_style
          },
          # children
          @props.children
        )
      )
    )
}

module.exports = {
  PageTop
  RightItem
  ScrollPage
}
