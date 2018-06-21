# page_data_user_symbol2.coffee, a_pinyin/apk/src/ui/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  Text
  TextInput
  Button
} = require 'react-native'
{ default: IconF } = require 'react-native-vector-icons/Feather'

s = require './_style'
{
  PageTop
} = require './_sub'
SelectableList = require './_selectable_list'


PageDataUserSymbol2 = cC {
  displayName: 'PageDataUserSymbol2'

  propTypes: {
    co: PropTypes.object.isRequired

    list: PropTypes.arrayOf(PropTypes.string).isRequired
    is_loading: PropTypes.bool.isRequired

    on_load: PropTypes.func.isRequired
    on_add: PropTypes.func.isRequired
    on_rm: PropTypes.func.isRequired

    on_back: PropTypes.func.isRequired
  }

  componentDidMount: ->
    @props.on_load()

  getInitialState: ->
    {
      text: ''  # text to add
      show_add: false  # show add part

      select_count: 0
      flag_reset_list: false  # flag used to reset list internal state
    }

  _on_change_select_count: (select_count) ->
    @setState {
      select_count
    }

  _on_reset_list: ->
    @setState (prevState, props) ->
      {
        select_count: 0  # reset select count, too
        flag_reset_list: ! prevState.flag_reset_list
      }

  _on_refresh_list: ->
    @_on_reset_list()
    @props.on_load()

  _on_click_right: ->
    if (! @state.show_add) and (@state.select_count > 0)
      # reset select
      @_on_reset_list()
    else  # toggle add
      @setState (prevState, props) ->
        {
          show_add: ! prevState.show_add
        }

  _on_change_text: (text) ->
    @setState {
      text
    }

  _on_add: ->
    @props.on_add @state.text
    # reset state
    @setState {
      text: ''
    }

  _get_top_right: ->
    if @state.show_add
      '-'
    else if @state.select_count > 0
      # reset list select state
      {
        text: '取消'
        size_small: true
      }
    else
      '+'

  _check_add: ->
    text = @state.text
    # check no text (not empty text)
    if (! text?) or (text.length < 1)
      return true
    # check exist text
    if @props.list.indexOf(text) != -1
      return true
    # check pass
    false

  _render_add: ->
    if @state.show_add
      (cE View, {
        style: [
          s.dus2_add
          @props.co.border
        ] },
        (cE TextInput, {
          style: [
            s.dus2_text_input
            @props.co.ui_text
          ]
          placeholder: '在此输入文本'
          placeholderTextColor: @props.co.co.BG_SEC
          value: @state.text
          autoCapitalize: 'none'
          autoCorrect: false
          autoFocus: true
          onChangeText: @_on_change_text
          onSubmitEditing: @_on_add
          })
        # add button
        (cE Button, {
          title: '添加'
          onPress: @_on_add
          disabled: @_check_add()
          })
      )

  _render_list: ->
    (cE SelectableList, {
      co: @props.co
      list: @props.list
      is_loading: @props.is_loading
      placeholder: '没有项目'
      style: s.dus2_list
      on_change_select_count: @_on_change_select_count
      on_refresh: @_on_refresh_list
      on_rm: @props.on_rm
      # use the `key` to reset internal state
      key: "#{@props.list.length}+#{@state.flag_reset_list}"
      })

  render: ->
    (cE View, {
      style: s.fill_view
      },
      (cE PageTop, {
        co: @props.co
        text: '自定义输入'
        text_right: @_get_top_right()
        on_click_right: @_on_click_right
        on_back: @props.on_back
        })
      @_render_add()
      @_render_list()
    )
}

# connect for redux
{ connect } = require 'react-redux'

action = require '../redux/action'
op = require '../redux/op'

mapStateToProps = ($$state, props) ->
  {
    list: $$state.getIn(['dus2', 'list']).toJS()
    is_loading: $$state.getIn ['dus2', 'is_loading']
  }

mapDispatchToProps = (dispatch, props) ->
  o = Object.assign {}, props

  o.on_load = ->
    dispatch op.dus2_load()
  o.on_add = (text) ->
    dispatch op.dus2_add(text)
  o.on_rm = (list) ->
    dispatch op.dus2_rm(list)
  o


module.exports = connect(mapStateToProps, mapDispatchToProps)(PageDataUserSymbol2)
