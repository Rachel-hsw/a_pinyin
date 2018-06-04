# page_db.coffee, a_pinyin/apk/src/ui/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  Text

  Button
} = require 'react-native'

config = require '../config'
im_native = require '../im_native'

{
  PageTop
  ScrollPage

  s
} = require './sub'


PageDb = cC {
  displayName: 'PageDb'

  propTypes: {
    co: PropTypes.object.isRequired

    no_check_db: PropTypes.bool.isRequired
    db: PropTypes.object.isRequired

    on_check_db: PropTypes.func.isRequired
    on_start_dl: PropTypes.func.isRequired
    on_clean_db: PropTypes.func.isRequired

    on_back: PropTypes.func.isRequired
  }

  componentDidMount: ->
    if ! @props.no_check_db
      @props.on_check_db()

  _render_text: (text) ->
    (cE Text, {
      style: [
        s.db_text
        @props.co.ui_text_sec
      ] },
      text
    )

  _render_title_text: (text) ->
    (cE Text, {
      style: [
        s.db_title_text
        @props.co.ui_text
      ] },
      text
    )

  _render_one_db: (db_name, desc) ->
    i = @props.db[db_name]
    # check db_version
    check = ''
    if i.db_version != config.CORE_DB_VERSION
      check = "  (错误: 格式版本 != #{config.CORE_DB_VERSION}  不匹配 !! )"

    (cE View, {
      style: s.db_pad_view
      },
      @_render_title_text "#{desc}  #{db_name}"
      @_render_text "路径  #{i.path}"
      @_render_text "大小  #{i.size} 字节"

      @_render_text "格式  #{i.db_version}#{check}"
      @_render_text "类型  #{i.db_type}"
      @_render_text "版本  #{i.data_version}"
      @_render_text "更新  #{i.last_update}"
    )

  _render_status: ->
    text = '未知'
    if @props.db.ok is true
      text = '正常.'
    else if @props.db.ok is false
      text = '错误或不存在 !'

    (cE View, {
      style: s.db_pad_view
      },
      @_render_title_text '状态'
      @_render_text text
      # TODO more db info ?
      @_render_dl_button()
    )

  _render_dl_button: ->
    # check doing status
    if @props.db.dling
      (cE View, {
        style: s.db_dl_button_view
        },
        @_render_text '正在下载, 请稍后 .. .'
      )
    else if @props.db.ok is false
      (cE View, {
        style: s.db_dl_button_view
        },
        (cE Button, {
          title: '下载数据库'
          onPress: @props.on_start_dl
          })
      )

  _render_clean_db: ->
    if @props.db.ok is true
      (cE View, {
        style: s.db_topad_view
        },
        @_render_title_text '数据库文件'
        @_render_text '整理数据库以优化性能.'
        (cE View, {
          style: s.db_button
          },
          (cE Button, {
            style: s.db_button
            title: '优化数据库'
            disabled: @props.db.cleaning
            onPress: @props.on_clean_db
            })
        )
      )
    # render nothing when db err

  render: ->
    (cE ScrollPage, {
      co: @props.co
      top: (cE PageTop, {
        co: @props.co
        text: '数据'
        on_back: @props.on_back
        })
      margin: true
      },
      @_render_one_db im_native.CORE_DATA_DB_NAME, '核心数据库'
      @_render_one_db im_native.USER_DATA_DB_NAME, '用户数据库'
      @_render_status()
      # placeholder
      (cE View, {
        style: s.fill_view
        })
      @_render_clean_db()
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
  o.on_check_db = ->
    dispatch op.check_db()
  o.on_clean_db = ->
    dispatch op.clean_user_db()

  o

module.exports = connect(mapStateToProps, mapDispatchToProps)(PageDb)
