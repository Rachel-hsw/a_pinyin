# page_select_mirror.coffee, a_pinyin/apk/src/ui/

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
  ListItem
} = require './_sub'


PageSelectMirror = cC {
  displayName: 'PageSelectMirror'

  propTypes: {
    co: PropTypes.object.isRequired

    dl_mirror: PropTypes.string.isRequired
    mirror_list: PropTypes.arrayOf(PropTypes.string).isRequired

    on_change_mirror: PropTypes.func.isRequired
    on_back: PropTypes.func.isRequired
  }

  _render_mirror_list: ->
    o = []
    for i in @props.mirror_list
      o.push (cE ListItem, {
        key: "#{i}"

        co: @props.co
        text: i
        index: i
        is_selected: (i is @props.dl_mirror)
        on_click: @props.on_change_mirror
        })
    o

  render: ->
    (cE ScrollPage, {
      co: @props.co
      top: (cE PageTop, {
        co: @props.co
        text: '选择下载镜像'
        on_back: @props.on_back
        })
      },
      @_render_mirror_list()
    )
}

# connect for redux
{ connect } = require 'react-redux'

action = require '../redux/action'
op = require '../redux/op'
config = require '../config'

mapStateToProps = ($$state, props) ->
  mirror_list = []
  for k of config.DB_REMOTE_URL
    mirror_list.push k

  {
    dl_mirror: $$state.get 'dl_mirror'
    mirror_list
  }

mapDispatchToProps = (dispatch, props) ->
  o = Object.assign {}, props

  o.on_change_mirror = (mirror) ->
    dispatch action.set_dl_mirror(mirror)
  o

module.exports = connect(mapStateToProps, mapDispatchToProps)(PageSelectMirror)
