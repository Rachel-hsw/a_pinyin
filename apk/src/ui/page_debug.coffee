# page_debug.coffee, a_pinyin/apk/src/ui/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  Text

  ScrollView

  TextInput
  Button
} = require 'react-native'

ss = require '../style'

{
  PageTop
} = require './sub'


PageDebug = cC {
  displayName: 'PageDebug'

  propTypes: {
    co: PropTypes.object.isRequired

    headless_count: PropTypes.number.isRequired
    core_is_input: PropTypes.bool.isRequired
    core_input_mode: PropTypes.number
    core_nolog: PropTypes.bool.isRequired

    on_back: PropTypes.func.isRequired
  }

  getInitialState: ->
    {
      show_text_input: true
    }

  _on_toggle_text_input: ->
    @setState {
      show_text_input: ! @state.show_text_input
    }

  _render_text_input: ->
    if @state.show_text_input
      (cE TextInput, {
        style: {
          color: @props.co.TEXT
        } })

  _render_debug: ->
    (cE View, {
      style: {
        flexDirection: 'column'
        margin: ss.TOP_PADDING
      } },
      @_render_text_input()

      # headless_count
      (cE Text, {
        style: {
          fontSize: ss.TEXT_SIZE
          color: @props.co.TEXT_SEC
        } },
        "+ headless count: #{@props.headless_count}"
      )
      # core status
      (cE Text, {
        style: {
          fontSize: ss.TEXT_SIZE
          color: @props.co.TEXT_SEC
        } },
        "+ core status: is_input #{@props.core_is_input}"
      )
      (cE Text, {
        style: {
          fontSize: ss.TEXT_SIZE
          color: @props.co.TEXT_SEC
        } },
        "+ core status: input_mode #{@props.core_input_mode}"
      )
      (cE Text, {
        style: {
          fontSize: ss.TEXT_SIZE
          color: @props.co.TEXT_SEC
        } },
        "+ core status: nolog #{@props.core_nolog}"
      )

      # toggle text button
      (cE Button, {
        title: 'toggle Text input'
        onPress: @_on_toggle_text_input
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
        text: 'DEBUG'
        on_back: @props.on_back
        })
      (cE ScrollView, {
        style: {
          flex: 1
          flexDirection: 'column'
        } },
        @_render_debug()
      )
    )
}

# connect for redux
{ connect } = require 'react-redux'

action = require '../redux/action'
op = require '../redux/op'

mapStateToProps = ($$state, props) ->
  {
    headless_count: $$state.getIn ['headless', 'count']
    core_is_input: $$state.getIn ['core', 'is_input']
    core_input_mode: $$state.getIn ['core', 'input_mode']
    core_nolog: $$state.getIn ['core', 'nolog']
  }

mapDispatchToProps = (dispatch, props) ->
  o = Object.assign {}, props

  o

module.exports = connect(mapStateToProps, mapDispatchToProps)(PageDebug)
