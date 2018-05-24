# main.coffee, a_pinyin/apk/src/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  Text

  DeviceEventEmitter
} = require 'react-native'
Subscribable = require 'Subscribable'

ss = require './style'
{ get_co } = require './color'

im_native = require './im_native'

PageMain = require './ui/page_main'
PageAbout = require './ui/page_about'
PageDebug = require './ui/page_debug'


Main = cC {
  displayName: 'Main'
  mixins: [ Subscribable.Mixin ]

  propTypes: {
    co: PropTypes.object.isRequired

    on_native_event: PropTypes.func.isRequired
  }

  _on_native_event: (raw) ->
    event = JSON.parse raw
    @props.on_native_event event

  componentDidMount: ->
    # listen to native event
    @addListenerOn DeviceEventEmitter, im_native.A_PINYIN_NATIVE_EVENT, @_on_native_event

  getInitialState: ->
    {
      page: 'main'  # 'main', 'about', 'debug'
    }

  _on_show_page_main: ->
    @setState {
      page: 'main'
    }

  _on_show_page_about: ->
    @setState {
      page: 'about'
    }

  _on_show_page_debug: ->
    @setState {
      page: 'debug'
    }

  _render_page: ->
    switch @state.page
      when 'about'
        (cE PageAbout, {
          co: @props.co

          on_back: @_on_show_page_main
          })
      when 'debug'
        (cE PageDebug, {
          co: @props.co

          on_back: @_on_show_page_main
          })
      else  # 'main'
        (cE PageMain, {
          co: @props.co

          on_show_debug: @_on_show_page_debug
          on_show_about: @_on_show_page_about
          })

  render: ->
    (cE View, {
      style: {
        flex: 1
        flexDirection: 'column'
        backgroundColor: @props.co.BG
      } },
      @_render_page()
    )
}


# connect for redux
{ connect } = require 'react-redux'

action = require './redux/action'
op = require './redux/op'

mapStateToProps = ($$state, props) ->
  {
    co: get_co $$state.get('co')
  }

mapDispatchToProps = (dispatch, props) ->
  o = Object.assign {}, props
  o.on_native_event = (data) ->
    dispatch op.on_native_event_ui(data)

  o.set_co = (co) ->
    dispatch action.set_co(co)
  o

module.exports = connect(mapStateToProps, mapDispatchToProps)(Main)
