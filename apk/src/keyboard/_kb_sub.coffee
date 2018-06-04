# _kb_sub.coffee, a_pinyin/apk/src/keyboard/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'
TimerMixin = require 'react-timer-mixin'

{
  StyleSheet

  View
  Text
  TouchableWithoutFeedback

  Vibration
} = require 'react-native'

style = require '../style'
config = require '../config'

{
  ss
} = style
# local styles
s = StyleSheet.create {
  touch_touchable: {
    width: '100%'
    height: '100%'
  }
  touch_view: {
    width: '100%'
    height: '100%'
    justifyContent: 'center'
    alignItems: 'center'
    borderWidth: 0
  }
  touch_text: {
    fontSize: style.KB_FONT_SIZE
    fontWeight: 'normal'
  }
  # kb sec button
  sec_view: {
    borderWidth: style.BORDER_WIDTH / 2
  }

  kb_flex: {
    flex: 1  # default flex: 1
  }
  kb_line: {
    flex: 1
    flexDirection: 'row'
  }

  kb_space_text: {
    fontSize: style.KB_SPACE_BUTTON_FONT_SIZE
  }

  # flex values
  flex_05: {
    flex: 0.5
  }
  flex_15: {
    flex: 1.5
  }
  flex_5: {
    flex: 5
  }

  line_bottom_view: {
    flex: 1
    flexDirection: 'row'
  }
}


Touch = cC {
  displayName: 'Touch'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number

    text: PropTypes.string.isRequired

    #view_style: {
    #  borderWidth
    #  backgroundColor
    #}
    #text_style: {
    #  fontSize
    #  fontWeight
    #  color
    #}

    on_click: PropTypes.func.isRequired
    on_touch_start: PropTypes.func
    on_touch_end: PropTypes.func
  }

  getInitialState: ->
    {
      touch: false
    }

  _on_touch_start: ->
    @setState {
      touch: true
    }
    @props.on_touch_start?()
    # vibration
    if @props.vibration_ms? and (@props.vibration_ms > 0)
      Vibration.vibrate @props.vibration_ms

  _on_touch_end: ->
    @setState {
      touch: false
    }
    @props.on_touch_end?()

  render: ->
    # merge styles
    view_style = [
      s.touch_view
      @props.co.kb_touch_view
      @props.view_style
    ]
    text_style = [
      s.touch_text
      @props.co.kb_touch_text
      @props.text_style
    ]
    if @state.touch
      view_style.push @props.co.kb_touch_view_active
      text_style.push @props.co.kb_touch_text_active

    (cE TouchableWithoutFeedback, {
      onPress: @props.on_click
      onPressIn: @_on_touch_start
      onPressOut: @_on_touch_end

      style: s.touch_touchable
      },
      (cE View, {
        style: view_style
        },
        (cE Text, {
          style: text_style
          },
          @props.text
        )
      )
    )
}

KbShiftableButton = cC {
  displayName: 'KbShiftableButton'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired
    text: PropTypes.string.isRequired
    text_shift: PropTypes.string.isRequired
    shift: PropTypes.bool

    on_text: PropTypes.func.isRequired
  }

  _on_click: ->
    text = @props.text
    if @props.shift
      text = @props.text_shift
    @props.on_text text

  render: ->
    text = @props.text
    if @props.shift
      text = @props.text_shift

    (cE Touch, {
      co: @props.co
      vibration_ms: @props.vibration_ms
      text
      on_click: @_on_click
      })
}

KbFlex = cC {
  displayName: 'KbFlex'
  propTypes: {
    #style: {
    #  flex
    #}
    # children
  }

  render: ->
    (cE View, {
      style: [
        s.kb_flex
        @props.style
      ] },
      @props.children
    )
}

KbLine = cC {
  displayName: 'KbLine'
  propTypes: {
    # children
  }

  render: ->
    (cE View, {
      style: s.kb_line
      },
      @props.children
    )
}

KbButtonLayout = cC {
  displayName: 'KbButtonLayout'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired
    layout: PropTypes.string.isRequired
    shift: PropTypes.bool
    on_text: PropTypes.func.isRequired
  }

  render: ->
    o = []
    for i in [0... @props.layout.length / 2]
      o.push (cE KbFlex, {
        key: i
        },
        (cE KbShiftableButton, {
          co: @props.co
          vibration_ms: @props.vibration_ms
          text: @props.layout[i * 2]
          text_shift: @props.layout[i * 2 + 1]
          shift: @props.shift
          on_text: @props.on_text
        })
      )
    o
}

KbShiftButton = cC {
  displayName: 'KbShiftButton'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired
    shift: PropTypes.bool

    on_shift: PropTypes.func.isRequired
  }

  render: ->
    view_style = [
      s.sec_view
    ]
    text_style = [
      @props.co.kb_sec_text
    ]

    text = '⇧'
    if ! @props.shift?  # shift is null, for pinyin input
      text = 'ㄨ'
    else if @props.shift
      view_style.push @props.co.kb_shift_view_active
      text_style.push @props.co.kb_shift_text_active

    (cE Touch, {
      co: @props.co
      vibration_ms: @props.vibration_ms
      text
      view_style
      text_style
      on_click: @props.on_shift
      })
}

KbSpaceButton = cC {
  displayName: 'KbSpaceButton'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired
    on_text: PropTypes.func.isRequired
  }

  _on_click: ->
    @props.on_text ' '

  render: ->
    view_style = [
      s.sec_view
    ]
    text_style = [
      s.kb_space_text
      @props.co.kb_sec_text
    ]
    (cE Touch, {
      co: @props.co
      vibration_ms: @props.vibration_ms
      text: '└──┘'
      view_style
      text_style
      on_click: @_on_click
      })
}

KbDeleteKey = cC {
  displayName: 'KbDeleteKey'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired

    on_delete: PropTypes.func.isRequired
  }
  mixins: [ TimerMixin ]

  _on_touch_start: ->
    @_first_timer = @setTimeout @_start_multi_delete, config.DELETE_KEY_DELAY_FIRST
    @_cancel_one_delete = false
    @_multi_delete = false

  _on_touch_end: ->
    @clearInterval @_first_timer
    @clearInterval @_timer
    if @_multi_delete
      @_cancel_one_delete = true

  _start_multi_delete: ->
    @_timer = @setInterval @_on_delete, config.DELETE_KEY_DELAY_MS
    @props.on_delete()  # first delete

    @_multi_delete = true

  _on_delete: ->
    if @_cancel_one_delete
      @_cancel_one_delete = false
    else
      @props.on_delete()

  render: ->
    view_style = [
      s.sec_view
    ]
    text_style = [
      @props.co.kb_sec_text
    ]
    (cE Touch, {
      co: @props.co
      vibration_ms: @props.vibration_ms
      text: '⇦'
      view_style
      text_style

      on_touch_start: @_on_touch_start
      on_touch_end: @_on_touch_end
      on_click: @_on_delete
      })
}

KbEnterKey = cC {
  displayName: 'KbEnterKey'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired

    on_click: PropTypes.func.isRequired
  }

  render: ->
    view_style = [
      s.sec_view
    ]
    text_style = [
      @props.co.kb_sec_text
    ]
    (cE Touch, {
      co: @props.co
      vibration_ms: @props.vibration_ms
      text: '⏎'
      view_style
      text_style
      on_click: @props.on_click
      })
}

KbLayouts1097 = cC {
  displayName: 'KbLayouts1097'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired

    shift: PropTypes.bool
    layouts: PropTypes.array.isRequired

    on_text: PropTypes.func.isRequired
    on_shift: PropTypes.func.isRequired
    on_key_delete: PropTypes.func.isRequired
  }

  render: ->
    [
      # line 10
      (cE KbLine, {
        key: 1
        },
        (cE KbButtonLayout, {
          co: @props.co
          vibration_ms: @props.vibration_ms
          layout: @props.layouts[0]
          shift: @props.shift
          on_text: @props.on_text
          })
      )
      # line 9
      (cE KbLine, {
        key: 2
        },
        # left padding
        (cE KbFlex, {
          style: s.flex_05
          })
        (cE KbButtonLayout, {
          co: @props.co
          vibration_ms: @props.vibration_ms
          layout: @props.layouts[1]
          shift: @props.shift
          on_text: @props.on_text
          })
        # right padding
        (cE KbFlex, {
          style: s.flex_05
          })
      )
      # line 7
      (cE KbLine, {
        key: 3
        },
        # left: shift
        (cE KbFlex, {
          style: s.flex_15
          },
          (cE KbShiftButton, {
            co: @props.co
            vibration_ms: @props.vibration_ms
            shift: @props.shift
            on_shift: @props.on_shift
            })
        )
        (cE KbButtonLayout, {
          co: @props.co
          vibration_ms: @props.vibration_ms
          layout: @props.layouts[2]
          shift: @props.shift
          on_text: @props.on_text
          })
        # right: delete key
        (cE KbFlex, {
          style: s.flex_15
          },
          (cE KbDeleteKey, {
            co: @props.co
            vibration_ms: @props.vibration_ms
            on_delete: @props.on_key_delete
            })
        )
      )
    ]
}

KbLayouts7109 = cC {
  displayName: 'KbLayouts7109'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired

    shift: PropTypes.bool
    layouts: PropTypes.array.isRequired

    on_text: PropTypes.func.isRequired
    on_shift: PropTypes.func.isRequired
    on_key_delete: PropTypes.func.isRequired
  }

  render: ->
    [
      # line 7
      (cE KbLine, {
        key: 1
        },
        # left: shift
        (cE KbFlex, {
          style: s.flex_15
          },
          (cE KbShiftButton, {
            co: @props.co
            vibration_ms: @props.vibration_ms
            shift: @props.shift
            on_shift: @props.on_shift
            })
        )
        (cE KbButtonLayout, {
          co: @props.co
          vibration_ms: @props.vibration_ms
          layout: @props.layouts[0]
          shift: @props.shift
          on_text: @props.on_text
          })
        # right: delete key
        (cE KbFlex, {
          style: s.flex_15
          },
          (cE KbDeleteKey, {
            co: @props.co
            vibration_ms: @props.vibration_ms
            on_delete: @props.on_key_delete
            })
        )
      )
      # line 10
      (cE KbLine, {
        key: 2
        },
        (cE KbButtonLayout, {
          co: @props.co
          vibration_ms: @props.vibration_ms
          layout: @props.layouts[1]
          shift: @props.shift
          on_text: @props.on_text
          })
      )
      # line 9
      (cE KbLine, {
        key: 3
        },
        # left padding
        (cE KbFlex, {
          style: s.flex_05
          })
        (cE KbButtonLayout, {
          co: @props.co
          vibration_ms: @props.vibration_ms
          layout: @props.layouts[2]
          shift: @props.shift
          on_text: @props.on_text
          })
        # right padding
        (cE KbFlex, {
          style: s.flex_05
          })
      )
    ]
}

KbLineBottom = cC {
  displayName: 'KbLineBottom'
  propTypes: {
    co: PropTypes.object.isRequired
    vibration_ms: PropTypes.number.isRequired

    shift: PropTypes.bool

    on_text: PropTypes.func.isRequired
    on_key_enter: PropTypes.func.isRequired
  }

  render: ->
    (cE View, {
      style: s.line_bottom_view
      },
      # left: quote key (' ")
      (cE KbFlex, {
        style: s.flex_15
        },
        (cE KbShiftableButton, {
          co: @props.co
          vibration_ms: @props.vibration_ms
          text: '\''
          text_shift: '"'
          shift: @props.shift
          on_text: @props.on_text
          })
      )
      # ',<'
      (cE KbFlex, null,
        (cE KbShiftableButton, {
          co: @props.co
          vibration_ms: @props.vibration_ms
          text: ','
          text_shift: '<'
          shift: @props.shift
          on_text: @props.on_text
          })
      )
      # space button
      (cE KbFlex, {
        style: s.flex_5
        },
        (cE KbSpaceButton, {
          co: @props.co
          vibration_ms: @props.vibration_ms
          on_text: @props.on_text
          })
      )
      # '.>'
      (cE KbFlex, null,
        (cE KbShiftableButton, {
          co: @props.co
          vibration_ms: @props.vibration_ms
          text: '.'
          text_shift: '>'
          shift: @props.shift
          on_text: @props.on_text
          })
      )
      # enter key
      (cE KbFlex, {
        style: s.flex_15
        },
        (cE KbEnterKey, {
          co: @props.co
          vibration_ms: @props.vibration_ms
          on_click: @props.on_key_enter
          })
      )
    )
}

module.exports = {
  Touch
  KbShiftableButton
  KbFlex
  KbLine
  KbButtonLayout
  KbShiftButton
  KbSpaceButton
  KbDeleteKey
  KbEnterKey
  KbLayouts1097
  KbLayouts7109
  KbLineBottom
}
