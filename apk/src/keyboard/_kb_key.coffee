# _kb_key.coffee, a_pinyin/apk/src/keyboard/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'
TimerMixin = require 'react-timer-mixin'

{
  View
  Text
} = require 'react-native'

config = require '../config'
s = require './_kb_style'
{
  key_vibrate
} = require './_kb_util'


# a simple View with touch function
TouchableCore = cC {
  displayName: 'TouchableCore'
  propTypes: {
    co: PropTypes.object.isRequired
    style: PropTypes.any  # style for the View
    children: PropTypes.node

    on_click: PropTypes.func.isRequired
    on_touch_start: PropTypes.func
    on_touch_end: PropTypes.func
  }

  getInitialState: ->
    {
      touch: false
      layout: null  # layout for touchable View (size)
    }

  _onLayout: (evt) ->
    @setState {
      layout: evt.nativeEvent.layout
    }

  _onStartShouldSetResponder: (evt) ->
    true

  _onResponderGrant: (evt) ->
    # touch start
    @props.on_touch_start?()
    # call parent before change state
    @setState {
      touch: true
    }

  _on_touch_end: (evt) ->
    if @state.touch
      @props.on_touch_end?()
    @setState {
      touch: false
    }

  _onResponderRelease: (evt) ->
    # click
    @_on_touch_end evt

    # check cancel touch
    if ! @state.layout?
      return  # no layout, not a real touch
    if ! @state.touch
      return  # no touch

    # FIXME check cancel touch
    size_x = @state.layout.width
    size_y = @state.layout.height
    touch_x = evt.nativeEvent.locationX
    touch_y = evt.nativeEvent.locationY
    # FIXME a BUG here
    if (touch_x < 0) or (touch_x > size_x)
      return
    if (touch_y < 0) or (touch_y > size_y)
      return
    # touch check pass
    @props.on_click?()

  _onResponderTerminationRequest: (evt) ->
    true

  _onResponderTerminate: (evt) ->
    # touch end, without click (cancel)
    @_on_touch_end evt

  render: ->
    # merge styles
    style = [
      s.tc
      @props.co.kb_tc
    ]
    if @state.touch
      style.push s.tc_active
      style.push @props.co.kb_tc_active
    style.push @props.style

    (cE View, {
      style

      onLayout: @_onLayout
      onStartShouldSetResponder: @_onStartShouldSetResponder
      onResponderGrant: @_onResponderGrant
      onResponderRelease: @_onResponderRelease
      onResponderTerminationRequest: @_onResponderTerminationRequest
      onResponderTerminate: @_onResponderTerminate
      },
      @props.children
    )
}

# a touchable component simple to use
SimpleTouch = cC {
  displayName: 'SimpleTouch'
  propTypes: {
    co: PropTypes.object.isRequired
    style: PropTypes.any  # style for Text
    style_view: PropTypes.any  # style for the View
    text: PropTypes.string.isRequired
    text_cb: PropTypes.string  # replace with on_click(props.text_cb)
    # vibration support
    vibration_ms: PropTypes.number

    on_click: PropTypes.func.isRequired  # callback(props.text)
    on_touch_start: PropTypes.func
    on_touch_end: PropTypes.func
  }

  # NOTE dup of touch state
  getInitialState: ->
    {
      touch: false
    }

  _on_touch_start: ->
    @setState {
      touch: true
    }
    key_vibrate @props.vibration_ms
    @props.on_touch_start?()

  _on_touch_end: ->
    @setState {
      touch: false
    }
    @props.on_touch_end?()

  _on_click: ->
    # check text_cb first
    if @props.text_cb?
      @props.on_click?(@props.text_cb)
    else
      @props.on_click?(@props.text)

  render: ->
    # merge styles
    style = [
      s.st
      @props.co.kb_st
    ]
    if @state.touch
      style.push s.st_active
      style.push @props.co.kb_st_active
    style.push @props.style

    (cE TouchableCore, {
      co: @props.co
      style: @props.style_view
      on_click: @_on_click
      on_touch_start: @_on_touch_start
      on_touch_end: @_on_touch_end
      },
      (cE Text, {
        style
        },
        @props.text
      )
    )
}


# text for special buttons
TEXT_BUTTON_SHIFT = '⇧'
TEXT_BUTTON_RESET = 'ㄨ'
TEXT_BUTTON_SPACE = '└──┘'
TEXT_KEY_ENTER = '⏎'
TEXT_KEY_DELETE = '⇦'

KbShiftButton = cC {
  displayName: 'KbShiftButton'
  propTypes: {
    co: PropTypes.object.isRequired
    style: PropTypes.any  # style for the View
    vibration_ms: PropTypes.number.isRequired
    shift: PropTypes.bool

    on_click: PropTypes.func.isRequired
  }

  render: ->
    text = TEXT_BUTTON_SHIFT
    if ! @props.shift?  # shift is null, for pinyin input
      text = TEXT_BUTTON_RESET

    # merge styles
    style = [  # Text
      @props.co.kb_sec_text
    ]
    style_view = [
      s.sec
      @props.co.kb_sec
    ]
    if @props.shift
      style.push @props.co.kb_sb_text_active
      style_view.push @props.co.kb_sb_active
    style_view.push @props.style

    (cE SimpleTouch, {
      co: @props.co
      style
      style_view
      text
      vibration_ms: @props.vibration_ms
      on_click: @props.on_click
      })
}

# for space button and enter key
KbSecButton = cC {
  displayName: 'KbSecButton'
  propTypes: {
    co: PropTypes.object.isRequired
    style: PropTypes.any  # style for the View
    style_text: PropTypes.any  # style for Text
    text: PropTypes.string.isRequired
    vibration_ms: PropTypes.number.isRequired

    on_click: PropTypes.func.isRequired
  }

  render: ->
    # merge styles
    style = [  # Text
      @props.co.kb_sec_text
      @props.style_text
    ]
    style_view = [
      s.sec
      @props.co.kb_sec
      @props.style
    ]

    (cE SimpleTouch, {
      co: @props.co
      style
      style_view
      text: @props.text
      vibration_ms: @props.vibration_ms
      on_click: @props.on_click
      })
}

KbDeleteKey = cC {
  displayName: 'KbDeleteKey'
  propTypes: {
    co: PropTypes.object.isRequired
    style: PropTypes.any  # style for the View
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
    # merge styles
    style = [  # Text
      @props.co.kb_sec_text
    ]
    style_view = [
      s.sec
      @props.co.kb_sec
      @props.style
    ]

    (cE SimpleTouch, {
      co: @props.co
      style
      style_view
      text: TEXT_KEY_DELETE
      vibration_ms: @props.vibration_ms
      on_click: @_on_delete
      on_touch_start: @_on_touch_start
      on_touch_end: @_on_touch_end
      })
}


# sec text, support icon children, no border
KbSecIconButton = cC {
  displayName: 'KbSecIconButton'
  propTypes: {
    co: PropTypes.object.isRequired
    style: PropTypes.any  # style for the View
    style_text: PropTypes.any  # style for Text
    vibration_ms: PropTypes.number.isRequired
    children: PropTypes.node

    on_click: PropTypes.func.isRequired
  }

  _on_touch_start: ->
    key_vibrate @props.vibration_ms

  render: ->
    # merge styles
    style = [
      s.st
      @props.co.kb_sec_text
      # no text style when touch active
      @props.style_text
    ]

    (cE TouchableCore, {
      co: @props.co
      style: @props.style
      on_click: @props.on_click
      on_touch_start: @_on_touch_start
      },
      (cE Text, {
        style
        },
        @props.children
      )
    )
}

module.exports = {
  TouchableCore
  SimpleTouch

  TEXT_BUTTON_SHIFT
  TEXT_BUTTON_RESET
  TEXT_BUTTON_SPACE
  TEXT_KEY_ENTER
  TEXT_KEY_DELETE

  KbShiftButton
  KbSecButton
  KbDeleteKey

  KbSecIconButton
}
