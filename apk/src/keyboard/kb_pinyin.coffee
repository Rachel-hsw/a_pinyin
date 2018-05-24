# kb_pinyin.coffee, a_pinyin/apk/src/keyboard/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  Text
} = require 'react-native'

ss = require '../style'

KbTop = require './kb_top'
KbTopPinyin = require './kb_top_pinyin'
KbPinyinMore = require './kb_pinyin_more'

KbEnglish = require './kb_english'


_calc_top_pinyin_list = (raw) ->
  o = []
  # add first items
  if raw.length > 0
    o = o.concat raw[0]
  if raw.length > 1
    o = o.concat raw[1]

  # if no items, add more
  for i in [2... raw.length]
    if o.length > 0
      break
    o = o.concat raw[i]
  o


KbPinyin = cC {
  displayName: 'KbPinyin'
  propTypes: {
    co: PropTypes.object.isRequired
    layout: PropTypes.string.isRequired
    core_nolog: PropTypes.bool.isRequired

    pinyin: PropTypes.string.isRequired
    list: PropTypes.array.isRequired
    top_more: PropTypes.bool.isRequired

    on_set_top_more: PropTypes.func.isRequired

    on_set_kb: PropTypes.func.isRequired
    on_close: PropTypes.func.isRequired
    on_key_enter: PropTypes.func.isRequired

    on_text: PropTypes.func.isRequired
    on_reset: PropTypes.func.isRequired
    on_pinyin_delete: PropTypes.func.isRequired
    on_pinyin_select_item: PropTypes.func.isRequired
  }

  _on_top_more: ->
    @props.on_set_top_more true

  _on_more_back: ->
    @props.on_set_top_more false

  _render_top: ->
    show_top_list = false
    list = []
    if @props.list.length > 0
      show_top_list = true
      list = _calc_top_pinyin_list @props.list
    # show empty list, if pinyin is not empty
    else if @props.pinyin.length > 0
      show_top_list = true

    if show_top_list
      (cE KbTopPinyin, {
        co: @props.co
        list
        on_text: @props.on_pinyin_select_item
        on_more: @_on_top_more

        key: 1
        })
    else
      (cE KbTop, {
        co: @props.co
        kb: 'pinyin'
        is_nolog: @props.core_nolog
        on_set_kb: @props.on_set_kb
        on_close: @props.on_close

        key: 1
        })

  _render_body: ->
    if @props.top_more
      (cE KbPinyinMore, {
        co: @props.co
        list: @props.list
        on_text: @props.on_pinyin_select_item
        on_reset: @props.on_reset
        on_back: @_on_more_back

        key: 2
        })
    else
      (cE KbEnglish, {
        co: @props.co
        layout: @props.layout
        no_shift: true
        on_shift: @props.on_reset  # shift key is 'reset' key here

        on_text: @props.on_text
        on_key_delete: @props.on_pinyin_delete
        on_key_enter: @props.on_key_enter

        key: 2
        })

  render: ->
    [
      @_render_top()
      @_render_body()
    ]
}

# connect for redux
{ connect } = require 'react-redux'

action = require '../redux/action'
op = require '../redux/op'

mapStateToProps = ($$state, props) ->
  $$p = $$state.get 'pinyin'
  {
    pinyin: $$p.get 'raw'
    list: $$p.get('can').toJS()
    top_more: $$p.get 'top_more'
  }

mapDispatchToProps = (dispatch, props) ->
  o = Object.assign {}, props
  o.on_set_top_more = (top_more) ->
    dispatch action.pinyin_set({
      top_more
    })

  o.on_text = (c) ->
    # check text
    if c is ' '
      # space key press
      dispatch op.pinyin_space()
    else if ((c < 'a') or (c > 'z')) and (c != '\'')
      # not a pinyin char
      dispatch op.add_text(c)
    else  # got a pinyin char
      dispatch op.pinyin_add_char(c)

  o.on_reset = ->
    dispatch op.reset_pinyin()
  o.on_pinyin_delete = ->
    dispatch op.pinyin_delete()
  o.on_pinyin_select_item = (text) ->
    dispatch op.pinyin_select_item(text)
  o

module.exports = connect(mapStateToProps, mapDispatchToProps)(KbPinyin)
