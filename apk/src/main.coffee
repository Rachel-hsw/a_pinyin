# main.coffee, a_pinyin/apk/src/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View

  DeviceEventEmitter
  PermissionsAndroid
  BackHandler
} = require 'react-native'
Subscribable = require 'Subscribable'

{ ss } = require './style'
{ get_co } = require './color'

im_native = require './im_native'

PageAbout = require './ui/page_about'
PageConfig = require './ui/page_config'
PageConfigPost = require './ui/page_config_post'
PageData = require './ui/page_data'
PageDataUserSymbol2 = require './ui/page_data_user_symbol2'
PageDb = require './ui/page_db'
PageMain = require './ui/page_main'

PageDebug = require './ui/page_debug'


_check_permissions = ->
  # storage
  try
    if ! await PermissionsAndroid.check PermissionsAndroid.PERMISSIONS.WRITE_EXTERNAL_STORAGE
      await PermissionsAndroid.request PermissionsAndroid.PERMISSIONS.WRITE_EXTERNAL_STORAGE, {
        title: 'A拼音 需要 读写存储权限'
        message: '用于存储输入法词典等重要数据.'
      }
  catch e
    # FIXME ignore all errors

Main = cC {
  displayName: 'Main'
  mixins: [ Subscribable.Mixin ]

  propTypes: {
    co: PropTypes.object.isRequired

    on_native_event: PropTypes.func.isRequired
    on_init: PropTypes.func.isRequired
  }

  _on_native_event: (raw) ->
    event = JSON.parse raw
    @props.on_native_event event

  componentDidMount: ->
    # listen to native event
    @addListenerOn DeviceEventEmitter, im_native.A_PINYIN_NATIVE_EVENT, @_on_native_event
    # listen on handware back button
    BackHandler.addEventListener 'hardwareBackPress', @_on_hardware_back

    await _check_permissions()
    if await @props.on_init()
      @_on_show_page_db true

  componentWillUnmount: ->
    BackHandler.removeEventListener 'hardwareBackPress', @_on_hardware_back

  getInitialState: ->
    {
      page: 'main'  # current page
      # avaliable pages:
      #   'about'
      #   'config'
      #   'config_post'
      #   'data'
      #   'data_user_symbol2'
      #   'db'
      #   'main'
      #
      #   'debug'
      no_check_db: false
    }

  # go to one page
  _on_show_page: (page) ->
    @setState {
      page
      no_check_db: false  # reset no_check_db here
    }

  # db is one special page
  _on_show_page_db: (no_check) ->
    no_check_db = false
    if no_check is true
      no_check_db = true

    @setState {
      page: 'db'
      no_check_db
    }

  # hardware_back or touch go back
  _on_back: ->
    page = switch @state.page
      when 'config_post'
        'config'
      when 'data_user_symbol2', 'db'
        'data'
      else  # default: go back to main page
        'main'
    @_on_show_page page

  _on_hardware_back: ->
    if @state.page is 'main'
      return false  # exit app
    else  # default: go back to upper page
      @_on_back()
    true

  _render_page: ->
    switch @state.page
      when 'about'
        (cE PageAbout, {
          co: @props.co

          on_back: @_on_back
          })
      when 'config'
        (cE PageConfig, {
          co: @props.co

          on_show_page: @_on_show_page
          on_back: @_on_back
          })
      when 'config_post'
        (cE PageConfigPost, {
          co: @props.co

          on_back: @_on_back
          })
      when 'data'
        (cE PageData, {
          co: @props.co

          on_show_page: @_on_show_page
          on_show_db: @_on_show_page_db
          on_back: @_on_back
          })
      when 'data_user_symbol2'
        (cE PageDataUserSymbol2, {
          co: @props.co

          on_back: @_on_back
          })
      when 'db'
        (cE PageDb, {
          co: @props.co
          no_check_db: @state.no_check_db

          on_back: @_on_back
          })
      when 'debug'
        (cE PageDebug, {
          co: @props.co

          on_back: @_on_back
          })
      else  # 'main'
        (cE PageMain, {
          co: @props.co

          on_show_page: @_on_show_page
          })

  render: ->
    (cE View, {
      style: [
        ss.ui_main_view
        @props.co.ui_main_view
      ] },
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
  o.on_init = ->
    await dispatch op.check_db()

  o.set_co = (co) ->
    dispatch action.set_co(co)
  o

module.exports = connect(mapStateToProps, mapDispatchToProps)(Main)
