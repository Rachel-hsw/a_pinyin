# _selectable_list.coffee, a_pinyin/apk/src/ui/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  FlatList
  TouchableNativeFeedback

  Text
  Button
} = require 'react-native'

s = require './_style'
{
  ListItem
} = require './_sub'


SelectableList = cC {
  displayName: 'SelectableList'

  propTypes: {
    co: PropTypes.object.isRequired

    list: PropTypes.arrayOf(PropTypes.string).isRequired
    is_loading: PropTypes.bool.isRequired
    placeholder: PropTypes.string
    style: PropTypes.any  # style to the View

    on_change_select_count: PropTypes.func.isRequired
    on_refresh: PropTypes.func.isRequired
    on_rm: PropTypes.func.isRequired
  }

  # react: change `key` of this component to reset internal state
  getInitialState: ->
    {
      select_map: {}  # index to select
      select_count: 0
    }

  componentDidMount: ->
    # reset parent select_count here
    @props.on_change_select_count 0

  _on_click_item: (index) ->
    @setState (prevState, props) ->
      # toggle select state
      select_count = prevState.select_count
      # clone a new select_map
      select_map = Object.assign {}, prevState.select_map

      if select_map[index]
        select_map[index] = false
        select_count -= 1
      else
        select_map[index] = true
        select_count += 1
      # report select_count change
      @props.on_change_select_count select_count

      {
        select_map
        select_count
      }

  _on_rm: ->
    # gen list
    o = []
    for i of @state.select_map
      if @state.select_map[i]
        o.push @props.list[i]
    @props.on_rm o
    # parent should reset the internal state of this component by change the `key`

  _gen_list_data: ->
    raw = @props.list
    sm = @state.select_map

    o = []
    for i in [0... raw.length]
      o.push {
        text: raw[i]
        is_selected: !! sm[i]
      }
    o

  _render_list_item: (it) ->
    {
      item
      index
    } = it

    (cE ListItem, {
      co: @props.co
      index
      is_selected: item.is_selected
      text: item.text
      on_click: @_on_click_item
      })

  _render_list: ->
    data = @_gen_list_data()

    (cE FlatList, {
      data
      renderItem: @_render_list_item
      extraData: {
        co: @props.co
      }
      keyExtractor: (item, index) ->
        "#{index}"
      style: s.sl_flatlist
      onRefresh: @props.on_refresh
      refreshing: @props.is_loading
      ListEmptyComponent: (cE Text, {
        style: [
          s.sl_placeholder
          @props.co.ui_text_sec
        ] },
        "#{@props.placeholder}"
      )
    })

  # remove button
  _render_rm: ->
    if @state.select_count > 0
      (cE View, {
        style: s.sl_rm_button
        },
        (cE Button, {
          title: "移除 #{@state.select_count} 个项目"
          onPress: @_on_rm
          })
      )

  render: ->
    (cE View, {
      style: @props.style
      },
      @_render_list()
      @_render_rm()
    )
}

module.exports = SelectableList
