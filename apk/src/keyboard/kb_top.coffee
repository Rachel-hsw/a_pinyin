# kb_top.coffee, a_pinyin/apk/src/keyboard/

{ createElement: cE } = require 'react'
cC = require 'create-react-class'
PropTypes = require 'prop-types'

{
  View
  Text
} = require 'react-native'

ss = require '../style'

{ Touch } = require './_kb_sub'


KbTop = cC {
  displayName: 'KbTop'
  propTypes: {
    co: PropTypes.object.isRequired

    kb: PropTypes.string.isRequired
    is_nolog: PropTypes.bool.isRequired

    on_set_kb: PropTypes.func.isRequired
    on_close: PropTypes.func.isRequired
  }

  _render_button: (text, color, bg, on_click, font_weight) ->
    (cE View, {
      style: {
        height: '100%'
        width: ss.KB_TOP_WIDTH
      } },
      (cE Touch, {
        co: @props.co
        text
        font_size: ss.TITLE_SIZE
        font_weight
        color
        bg

        on_click
        })
    )

  # render the left most button
  _render_left: (name, text, kb) ->
    color = @props.co.TEXT_SEC
    bg = @props.co.BG
    on_click = =>
      @props.on_set_kb name
    font_weight = null
    # check current active
    if name is kb
      color = @props.co.BG
      bg = @props.co.TEXT_SEC
    # check nolog mode
    if @props.is_nolog
      text = '无'
      color = @props.co.NOLOG
      font_weight = 'bold'
    @_render_button text, color, bg, on_click, font_weight

  _render_one: (name, text, kb) ->
    color = @props.co.TEXT_SEC
    bg = @props.co.BG
    on_click = =>
      @props.on_set_kb name
    if name is kb
      color = @props.co.BG
      bg = @props.co.TEXT_SEC
    @_render_button text, color, bg, on_click

  render: ->
    (cE View, {
      style: {
        flexShrink: 0
        height: ss.KB_TOP_HEIGHT
        # top border
        borderTopWidth: ss.BORDER_WIDTH
        borderTopColor: @props.co.BORDER

        flexDirection: 'row'
      } },
      # buttons
      @_render_left 'more', '+', @props.kb
      @_render_one 'english', 'A', @props.kb
      @_render_one 'pinyin', '拼', @props.kb
      @_render_one 'number', '2', @props.kb
      @_render_one 'symbol', '@', @props.kb
      @_render_one 'symbol2', '。', @props.kb
      # space
      (cE View, {
        style: {
          flex: 1
        } })
      # close button
      @_render_button '-', @props.co.TEXT, @props.co.BG, @props.on_close
    )
}

module.exports = KbTop
