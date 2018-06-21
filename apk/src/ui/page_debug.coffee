# page_debug.coffee, a_pinyin/apk/src/ui/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  Text

  TextInput
  Button
} = require 'react-native'

s = require './_style'
{
  PageTop
  ScrollPage
} = require './_sub'


PageDebug = cC {
  displayName: 'PageDebug'

  propTypes: {
    co: PropTypes.object.isRequired

    headless_count: PropTypes.number.isRequired
    core_is_input: PropTypes.bool.isRequired
    core_input_mode: PropTypes.number
    core_nolog: PropTypes.bool.isRequired

    on_exit_app: PropTypes.func.isRequired
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
        style: [
          @props.co.text
        ] })

  _render_text: (text) ->
    (cE Text, {
      style: [
        s.debug_text
        @props.co.ui_text_sec
      ] },
      text
    )

  render: ->
    (cE ScrollPage, {
      co: @props.co
      top: (cE PageTop, {
        co: @props.co
        text: 'DEBUG'
        on_back: @props.on_back
        })
      margin: true
      },
      # debug page body
      @_render_text_input()

      # headless_count
      @_render_text "+ headless count: #{@props.headless_count}"
      # core status
      @_render_text "+ core status: is_input #{@props.core_is_input}"
      @_render_text "+ core status: input_mode #{@props.core_input_mode}"
      @_render_text "+ core status: nolog #{@props.core_nolog}"

      # toggle text button
      (cE Button, {
        title: 'toggle Text input'
        onPress: @_on_toggle_text_input
        })

      # placeholder
      (cE View, {
        style: s.fill_view
        })
      # force-exit function
      (cE Button, {
        title: 'exit'
        onPress: @props.on_exit_app
        })
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
  o.on_exit_app = ->
    dispatch op.exit_app()

  o

module.exports = connect(mapStateToProps, mapDispatchToProps)(PageDebug)
