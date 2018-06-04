# sub.coffee, a_pinyin/apk/src/ui/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  StyleSheet

  View
  Text
  ScrollView

  TouchableNativeFeedback
  TouchableWithoutFeedback
} = require 'react-native'

style = require '../style'
{
  ss
} = style
# local styles
s = StyleSheet.create {
  # PageTop
  top_back_view: {
    width: style.TOP_HEIGHT
    height: style.TOP_HEIGHT
    flexDirection: 'row'
    alignItems: 'center'
    justifyContent: 'center'
  }
  top_back_text: {
    fontSize: style.TITLE_SIZE
  }
  top_placeholder: {
    width: style.TOP_HEIGHT
  }
  top_view: {
    height: style.TOP_HEIGHT
    flexDirection: 'row'
    borderBottomWidth: style.BORDER_WIDTH
  }
  top_back_out_view: {
    height: '100%'
    width: style.TOP_HEIGHT
  }
  top_title_touch: {
    height: '100%'
    flex: 1
    flexDirection: 'row'
  }
  top_title_view: {
    height: '100%'
    flex: 1
    flexDirection: 'row'
    alignItems: 'center'
    justifyContent: 'center'
  }
  top_title_text: {
    flex: 1
    fontSize: style.TITLE_SIZE
    textAlign: 'center'
  }
  # RightItem
  ri_view: {
    height: style.TOP_HEIGHT
  }
  ri_in_view: {
    height: style.TOP_HEIGHT
    width: '100%'
    flexDirection: 'row'
    justifyContent: 'center'
    alignItems: 'center'
  }
  ri_text: {
    paddingLeft: style.TOP_PADDING
    fontSize: style.TITLE_SIZE
  }
  ri_text_sec: {
    flex: 1
    textAlign: 'right'
  }
  ri_right_text: {
    width: style.TOP_HEIGHT
    fontSize: style.TITLE_SIZE
    textAlign: 'center'
  }
  # ScrollPage
  sp_view: {
    flex: 1
    flexDirection: 'column'
  }
  sp_scrollview_container: {
    flexGrow: 1
  }
  sp_view_margin: {
    margin: style.TOP_PADDING
  }

  fill_view: {
    flex: 1
  }

  # PageAbout
  about_title_text_1: {
    fontSize: style.TITLE_SIZE
    paddingBottom: style.TOP_PADDING / 2
  }
  about_text: {
    fontSize: style.TEXT_SIZE
    paddingBottom: style.TOP_PADDING / 2
  }
  about_title_text: {
    fontSize: style.TITLE_SIZE
    paddingTop: style.TOP_PADDING / 2
    paddingBottom: style.TOP_PADDING / 2
  }
  about_license_text: {
    fontSize: style.TEXT_SIZE
    padding: style.TOP_PADDING / 2
  }

  # PageDebug
  debug_text: {
    fontSize: style.TEXT_SIZE
  }

  # PageDb
  db_pad_view: {
    marginBottom: style.TOP_PADDING
  }
  db_title_text: {
    fontSize: style.TITLE_SIZE
  }
  db_text: {
    fontSize: style.TEXT_SIZE
  }
  db_dl_button_view: {
    marginTop: style.TOP_PADDING
  }
  db_topad_view: {
    marginTop: style.TOP_PADDING
  }
  db_button: {
    marginTop: style.TOP_PADDING / 2
  }

  # ConfigItem
  config_item_view: {
    flex: 0
    flexShrink: 0
    margin: style.TOP_PADDING / 2
    marginTop: 0
    flexDirection: 'row'
    justifyContent: 'center'
    alignItems: 'center'
    paddingBottom: style.TOP_PADDING / 2
    #borderBottomWidth: style.BORDER_WIDTH / 2  # FIXME
    marginBottom: style.TOP_PADDING / 2
  }
  config_item_left_view: {
    flex: 1
    flexDirection: 'column'
  }
  config_item_right_view: {
    #height: '100%'  # FIXME
    flexDirection: 'column'
    justifyContent: 'center'
    alignItems: 'center'
  }
  config_item_title_text: {
    fontSize: style.TITLE_SIZE
  }
  config_item_text: {
    fontSize: style.TEXT_SIZE
    marginTop: style.TOP_PADDING / 2
  }
  # PageConfig
  config_input: {
    fontSize: style.TITLE_SIZE
    textAlign: 'right'
    width: style.TITLE_SIZE * 3
  }

  # TODO
}


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
        background: @props.co.touch_ripple
        },
        (cE View, {
          style: s.top_back_view
          },
          (cE Text, {
            style: [
              s.top_back_text
              @props.co.ui_text_sec
            ] },
            "<"
          )
        )
      )
    else  # placeholder
      (cE View, {
        style: s.top_placeholder
        })

  _on_top_click: ->
    @props.on_click?()

  render: ->
    (cE View, {
      style: [
        s.top_view
        @props.co.ui_top_view
      ] },
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
      # right padding
      (cE View, {
        style: s.top_placeholder
        })
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
              @props.co.ui_text_sec
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
    #children
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

  s  # UI styles center
}
