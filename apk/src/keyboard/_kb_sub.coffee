# _kb_sub.coffee, a_pinyin/apk/src/keyboard/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'
TimerMixin = require 'react-timer-mixin'

{
  View
  Text
  TouchableWithoutFeedback
} = require 'react-native'

ss = require '../style'
config = require '../config'


Touch = cC {
  displayName: 'Touch'
  propTypes: {
    co: PropTypes.object.isRequired

    text: PropTypes.string.isRequired
    border: PropTypes.bool
    font_size: PropTypes.number
    font_weight: PropTypes.string
    color: PropTypes.string
    bg: PropTypes.string

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

  _on_touch_end: ->
    @setState {
      touch: false
    }
    @props.on_touch_end?()

  render: ->
    borderWidth = 0
    if @props.border
      borderWidth = ss.KB_BUTTON_BORDER_WIDTH
    fontSize = ss.KB_FONT_SIZE
    if @props.font_size?
      fontSize = @props.font_size
    # fontWeight
    fontWeight = 'normal'
    if @props.font_weight?
      fontWeight = @props.font_weight

    backgroundColor = @props.co.BG
    color = @props.co.TEXT
    if @props.color?
      color = @props.color
    if @props.bg
      backgroundColor = @props.bg
    if @state.touch
      color = @props.co.TEXT_SEC
      backgroundColor = @props.co.TEXT

    (cE TouchableWithoutFeedback, {
      onPress: @props.on_click
      onPressIn: @_on_touch_start
      onPressOut: @_on_touch_end

      style: {
        width: '100%'
        height: '100%'
      } },
      (cE View, {
        style: {
          width: '100%'
          height: '100%'
          justifyContent: 'center'
          alignItems: 'center'
          borderColor: @props.co.BORDER
          borderWidth
          backgroundColor
        } },
        (cE Text, {
          style: {
            fontSize
            fontWeight
            color
          } },
          @props.text
        )
      )
    )
}

KbShiftableButton = cC {
  displayName: 'KbShiftableButton'
  propTypes: {
    co: PropTypes.object.isRequired
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
      text
      on_click: @_on_click
      })
}

KbFlex = cC {
  displayName: 'KbFlex'
  propTypes: {
    flex: PropTypes.number
    # children
  }

  render: ->
    flex = 1
    if @props.flex?
      flex = @props.flex

    (cE View, {
      style: {
        flex
      } },
      @props.children
    )
}

KbLine = cC {
  displayName: 'KbLine'
  propTypes: {
    # TODO
    # children
  }

  render: ->
    (cE View, {
      style: {
        flex: 1
        flexDirection: 'row'
      } },
      @props.children
    )
}

KbButtonLayout = cC {
  displayName: 'KbButtonLayout'
  propTypes: {
    co: PropTypes.object.isRequired
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
    shift: PropTypes.bool

    on_shift: PropTypes.func.isRequired
  }

  render: ->
    color = @props.co.TEXT_SEC
    bg = @props.co.BG
    text = '⇧'
    if ! @props.shift?  # shift is null, for pinyin input
      text = 'ㄨ'
    else if @props.shift
      color = @props.co.BG
      bg = @props.co.TEXT_SEC

    (cE Touch, {
      co: @props.co
      text
      border: true
      color
      bg
      on_click: @props.on_shift
      })
}

KbSpaceButton = cC {
  displayName: 'KbSpaceButton'
  propTypes: {
    co: PropTypes.object.isRequired
    on_text: PropTypes.func.isRequired
  }

  _on_click: ->
    @props.on_text ' '

  render: ->
    (cE Touch, {
      co: @props.co
      text: '└──┘'
      border: true
      font_size: ss.KB_SPACE_BUTTON_FONT_SIZE
      color: @props.co.TEXT_SEC
      bg: @props.co.BG
      on_click: @_on_click
      })
}

KbDeleteKey = cC {
  displayName: 'KbDeleteKey'
  propTypes: {
    co: PropTypes.object.isRequired

    on_delete: PropTypes.func.isRequired
  }
  # TODO fix timer ?  (not work out of MainActivity)
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
    (cE Touch, {
      co: @props.co
      text: '⇦'
      border: true
      color: @props.co.TEXT_SEC

      on_touch_start: @_on_touch_start
      on_touch_end: @_on_touch_end
      on_click: @_on_delete
      })
}

KbEnterKey = cC {
  displayName: 'KbEnterKey'
  propTypes: {
    co: PropTypes.object.isRequired

    on_click: PropTypes.func.isRequired
  }

  render: ->
    (cE Touch, {
      co: @props.co
      text: '⏎'
      border: true
      color: @props.co.TEXT_SEC
      on_click: @props.on_click
      })
}

KbLayouts1097 = cC {
  displayName: 'KbLayouts1097'
  propTypes: {
    co: PropTypes.object.isRequired

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
          flex: 0.5
          })
        (cE KbButtonLayout, {
          co: @props.co
          layout: @props.layouts[1]
          shift: @props.shift
          on_text: @props.on_text
          })
        # right padding
        (cE KbFlex, {
          flex: 0.5
          })
      )
      # line 7
      (cE KbLine, {
        key: 3
        },
        # left: shift
        (cE KbFlex, {
          flex: 1.5
          },
          (cE KbShiftButton, {
            co: @props.co
            shift: @props.shift
            on_shift: @props.on_shift
            })
        )
        (cE KbButtonLayout, {
          co: @props.co
          layout: @props.layouts[2]
          shift: @props.shift
          on_text: @props.on_text
          })
        # right: delete key
        (cE KbFlex, {
          flex: 1.5
          },
          (cE KbDeleteKey, {
            co: @props.co
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
          flex: 1.5
          },
          (cE KbShiftButton, {
            co: @props.co
            shift: @props.shift
            on_shift: @props.on_shift
            })
        )
        (cE KbButtonLayout, {
          co: @props.co
          layout: @props.layouts[0]
          shift: @props.shift
          on_text: @props.on_text
          })
        # right: delete key
        (cE KbFlex, {
          flex: 1.5
          },
          (cE KbDeleteKey, {
            co: @props.co
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
          flex: 0.5
          })
        (cE KbButtonLayout, {
          co: @props.co
          layout: @props.layouts[2]
          shift: @props.shift
          on_text: @props.on_text
          })
        # right padding
        (cE KbFlex, {
          flex: 0.5
          })
      )
    ]
}

KbLineBottom = cC {
  displayName: 'KbLineBottom'
  propTypes: {
    co: PropTypes.object.isRequired

    shift: PropTypes.bool

    on_text: PropTypes.func.isRequired
    on_key_enter: PropTypes.func.isRequired
  }

  render: ->
    (cE View, {
      style: {
        flex: 1
        flexDirection: 'row'
      } },
      # left: quote key (' ")
      (cE KbFlex, {
        flex: 1.5
        },
        (cE KbShiftableButton, {
          co: @props.co
          text: '\''
          text_shift: '"'
          shift: @props.shift
          on_text: @props.on_text
          })
      )
      # ',<'
      (cE KbFlex, {
        flex: 1
        },
        (cE KbShiftableButton, {
          co: @props.co
          text: ','
          text_shift: '<'
          shift: @props.shift
          on_text: @props.on_text
          })
      )
      # space button
      (cE KbFlex, {
        flex: 5
        },
        (cE KbSpaceButton, {
          co: @props.co
          on_text: @props.on_text
          })
      )
      # '.>'
      (cE KbFlex, {
        flex: 1
        },
        (cE KbShiftableButton, {
          co: @props.co
          text: '.'
          text_shift: '>'
          shift: @props.shift
          on_text: @props.on_text
          })
      )
      # enter key
      (cE KbFlex, {
        flex: 1.5
        },
        (cE KbEnterKey, {
          co: @props.co
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
