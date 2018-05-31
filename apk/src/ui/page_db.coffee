# page_db.coffee, a_pinyin/apk/src/ui/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  Text

  ScrollView
  Button
} = require 'react-native'

ss = require '../style'
config = require '../config'

{
  PageTop
} = require './sub'


PageDb = cC {
  displayName: 'PageDb'

  propTypes: {
    co: PropTypes.object.isRequired

    db: PropTypes.object.isRequired

    on_start_dl: PropTypes.func.isRequired
    on_back: PropTypes.func.isRequired
  }

  _render_one_db: (db_name, desc) ->
    (cE View, {
      style: {
        # TODO
        marginBottom: ss.TOP_PADDING
      } },
      (cE Text, {
        style: {
          color: @props.co.TEXT
          fontSize: ss.TITLE_SIZE
        } },
        "#{desc}  #{db_name}"
      )
      (cE Text, {
        style: {
          color: @props.co.TEXT_SEC
          fontSize: ss.TEXT_SIZE
        } },
        "路径 #{@props.db.db_path[db_name]}"
      )
      (cE Text, {
        style: {
          color: @props.co.TEXT_SEC
          fontSize: ss.TEXT_SIZE
        } },
        "大小 #{@props.db.db_size[db_name]} 字节"
      )
    )

  _render_status: ->
    text = '未知'
    if @props.db.ok is true
      text = '正常.'
    else if @props.db.ok is false
      text = '错误或不存在 !'

    (cE View, {
      style: {
        # TODO
      } },
      (cE Text, {
        style: {
          color: @props.co.TEXT
          fontSize: ss.TITLE_SIZE
        } },
        '状态'
      )
      (cE Text, {
        style: {
          color: @props.co.TEXT_SEC
          fontSize: ss.TEXT_SIZE
        } },
        text
      )
      # TODO more db info ?
      @_render_dl_button()
    )

  _render_dl_button: ->
    # check doing status
    if @props.db.dling
      (cE View, {
        style: {
          marginTop: ss.TOP_PADDING
        } },
        (cE Text, {
          style: {
            color: @props.co.TEXT_SEC
            fontSize: ss.TEXT_SIZE
          } },
          '正在下载, 请稍后 .. .'
        )
      )
    else if @props.db.ok is false
      (cE View, {
        style: {
          marginTop: ss.TOP_PADDING
        } },
        (cE Button, {
          title: '下载数据库'
          onPress: @props.on_start_dl
          })
      )

  render: ->
    (cE View, {
      style: {
        flex: 1
        flexDirection: 'column'
      } },
      (cE PageTop, {
        co: @props.co
        text: '数据库'
        on_back: @props.on_back
        })
      (cE ScrollView, {
        style: {
          flex: 1
          flexDirection: 'column'
        } },
        (cE View, {
          style: {
            flexDirection: 'column'
            margin: ss.TOP_PADDING
          } },
          @_render_one_db 'core_data.db', '核心数据库'
          @_render_one_db 'user_data.db', '用户数据库'
          @_render_status()
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
    db: $$state.get('db').toJS()
  }

mapDispatchToProps = (dispatch, props) ->
  o = Object.assign {}, props
  o.on_start_dl = ->
    dispatch op.dl_db()

  o

module.exports = connect(mapStateToProps, mapDispatchToProps)(PageDb)
