# page_data.coffee, a_pinyin/apk/src/ui/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  Text
} = require 'react-native'

s = require './_style'
{
  PageTop
  ScrollPage
  RightItem
} = require './_sub'


PageData = cC {
  displayName: 'PageData'

  propTypes: {
    co: PropTypes.object.isRequired

    db_ok: PropTypes.bool

    on_show_page: PropTypes.func.isRequired
    on_show_db: PropTypes.func.isRequired
    on_back: PropTypes.func.isRequired
  }

  _on_show_page_user_symbol2: ->
    @props.on_show_page 'data_user_symbol2'

  _on_show_select_mirror: ->
    @props.on_show_page 'select_mirror'

  # show notice text if not db_ok
  _render_db_button: ->
    text_sec = ''
    if @props.db_ok is false
      text_sec = '错误 !'

    (cE RightItem, {
      co: @props.co
      text: '数据库'
      text_sec
      on_click: @props.on_show_db
      })

  _render_select_mirror: ->
    if @props.db_ok is false
      (cE RightItem, {
        co: @props.co
        text: '选择下载镜像'
        on_click: @_on_show_select_mirror
        })

  render: ->
    (cE ScrollPage, {
      co: @props.co
      top: (cE PageTop, {
        co: @props.co
        text: '数据'
        on_back: @props.on_back
        })
      },
      # page user_symbol2
      (cE RightItem, {
        co: @props.co
        text: '自定义输入'
        on_click: @_on_show_page_user_symbol2
        })
      # placeholder
      (cE View, { style: s.fill_view })
      # select mirror
      @_render_select_mirror()
      # page db
      @_render_db_button()
    )
}

# connect for redux
{ connect } = require 'react-redux'

action = require '../redux/action'
op = require '../redux/op'

mapStateToProps = ($$state, props) ->
  {
    db_ok: $$state.getIn ['db', 'ok']
  }

mapDispatchToProps = (dispatch, props) ->
  o = Object.assign {}, props

  o

module.exports = connect(mapStateToProps, mapDispatchToProps)(PageData)
