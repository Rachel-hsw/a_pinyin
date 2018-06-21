# _kb_util.coffee, a_pinyin/apk/src/keybard/

{
  Vibration
} = require 'react-native'

config = require '../config'
{
  KB_FONT_SIZE
} = require '../style'


key_vibrate = (vibration_ms) ->
  if vibration_ms? and (vibration_ms > 0)
    Vibration.vibrate vibration_ms

# calc layouts
CL_BOARD_LINE_N = 4  # 4 lines per board
CL_BOARD_KEY_N = 10  # 10 buttons per line max
CL_BOARD_BUTTON = 1  # normal button size
CL_BOARD_SEC = 1.5  # sec button size
CL_BOARD_SPACE = 5  # space button size
CL_BOARD_HALF = 0.5  # half button (placeholder) size
CL_BOARD_LINE_10 = 10
CL_BOARD_LINE_9 = 9
CL_BOARD_LINE_7 = 7

LB_TYPE_TEXT = 'text'
LB_TYPE_SHIFT = 'shift'
LB_TYPE_DELETE = 'delete'
LB_TYPE_SPACE = ''
LB_TYPE_ENTER = 'enter'

# calc global data
_calc_global = (sx, sy, b_n = CL_BOARD_KEY_N) ->
  {
    # line size
    ls: sy / CL_BOARD_LINE_N
    # button size (unit 1)
    bs: sx / b_n
  }

_calc_layout = (g, y, layout, shift, x0) ->
  o = []
  h = g.ls
  w = g.bs
  x = x0
  # calc each normal button
  for i in [0... (layout.length / 2)]
    if shift
      text = layout[i * 2 + 1]
    else
      text = layout[i * 2]
    o.push {
      type: LB_TYPE_TEXT
      x
      y
      w
      h
      text
    }
    x += w
  o

# line with 10 normal buttons
# line: 10 x nb
_calc_line_10 = (g, y, layout, shift) ->
  # assert: layout.length == 10 * 2
  _calc_layout g, y, layout, shift, 0

# line with 9 normal buttons
# line: half + 9 x nb + half
_calc_line_9 = (g, y, layout, shift) ->
  # assert: layout.length == 9 * 2
  _calc_layout g, y, layout, shift, g.bs * CL_BOARD_HALF

# line with 7 normal buttons
# line: shift + 7 x nb + delete
_calc_line_7 = (g, y, layout, shift) ->
  # assert: layout.length == 7 * 2
  o = []
  h = g.ls
  # shift
  x = 0
  w = g.bs * CL_BOARD_SEC
  o.push {
    type: LB_TYPE_SHIFT
    x
    y
    w
    h
    shift
  }
  # 7 normal buttons
  x += w
  o = o.concat _calc_layout(g, y, layout, shift, x)
  # delete
  x += g.bs * CL_BOARD_LINE_7
  o.push {
    type: LB_TYPE_DELETE
    x
    y
    w
    h
  }
  o

# the bottom line
# line: '" + ,< + space + .> + enter
_calc_line_bottom  = (g, y, shift) ->
  o = []
  h = g.ls
  # '"
  x = 0
  w = g.bs * CL_BOARD_SEC
  if shift
    text = '\"'
  else
    text = '\''
  o.push {
    type: LB_TYPE_TEXT
    x
    y
    w
    h
    text
  }
  # ,<
  x += w
  w = g.bs
  if shift
    text = '<'
  else
    text = ','
  o.push {
    type: LB_TYPE_TEXT
    x
    y
    w
    h
    text
  }
  # space
  x += w
  w = g.bs * CL_BOARD_SPACE
  o.push {
    type: LB_TYPE_SPACE
    x
    y
    w
    h
  }
  # .>
  x += w
  w = g.bs
  if shift
    text = '>'
  else
    text = '.'
  o.push {
    type: LB_TYPE_TEXT
    x
    y
    w
    h
    text
  }
  # enter
  x += w
  w = g.bs * CL_BOARD_SEC
  o.push {
    type: LB_TYPE_ENTER
    x
    y
    w
    h
  }
  o

# args
#   sx: size_x (width) of parent View (box)
#   sy: size_y (height) of parent View (box)
#   layouts: keyboard layout string array
#   shift: keyboard shift state (default: false)
# return: layouts_data
calc_layouts_1097 = (sx, sy, layouts, shift) ->
  g = _calc_global sx, sy
  # line 1
  l1 = _calc_line_10 g, 0, layouts[0], shift
  # line 2
  l2 = _calc_line_9 g, g.ls, layouts[1], shift
  # line 3
  l3 = _calc_line_7 g, 2 * g.ls, layouts[2], shift
  # line 4
  l4 = _calc_line_bottom g, 3 * g.ls, shift

  [].concat l1, l2, l3, l4

calc_layouts_7109 = (sx, sy, layouts, shift) ->
  g = _calc_global sx, sy
  # line 1
  l1 = _calc_line_7 g, 0, layouts[0], shift
  # line 2
  l2 = _calc_line_10 g, g.ls, layouts[1], shift
  # line 3
  l3 = _calc_line_9 g, 2 * g.ls, layouts[2], shift
  # line 4
  l4 = _calc_line_bottom g, 3 * g.ls, shift

  [].concat l1, l2, l3, l4


# args
#   sx: size_x (width) of parent View (box)
#   sy: size_y (height) of parent View (box)
#   symbol_list: symbol array to show
# return: layouts_data
calc_symbol = (sx, sy, symbol_list) ->
  # assert: symbol_list.length == 32 == 4 * 8
  # assert: config.SYMBOL_PER_LINE == 8
  g = _calc_global sx, sy, config.SYMBOL_PER_LINE
  o = []
  for i in [0... 4]
    y = i * g.ls
    for j in [0... config.SYMBOL_PER_LINE]
      o.push {
        type: LB_TYPE_TEXT
        x: j * g.bs
        y: i * g.ls
        w: g.bs
        h: g.ls
        text: symbol_list[i * config.SYMBOL_PER_LINE + j]
      }
  o


# calc len based on measure text
_calc_symbol2_one_width = (x, width, unit) ->
  # assert: x > 0
  padding = unit - KB_FONT_SIZE
  # calc width, to 0.5 unit
  raw = (width + padding) / unit * 2
  f = Math.floor raw
  if raw > (f + 0.3)  # TODO 0.3 ?
    f += 1
  o = f / 2
  if o < 1
    o = 1  # o is at least one unit
  o

# get size (flex, width) for one symbol2 item
_calc_symbol2_len = (text, is_first_line, measured_width, unit_width) ->
  M = config.SYMBOL_PER_LINE  # max length of one item
  if is_first_line  # first line to put the paste button
    M -= 1

  o = _calc_symbol2_one_width text.length, measured_width, unit_width
  if o > M
    o = M
  o

# one item types for KbSymbol2
S2_TYPE_TEXT = 'text'
S2_TYPE_PASTE = 'paste'
S2_TYPE_PLACEHOLDER = ''

# args
#   sx: size_x (width) of parent View (box)
#   sy: size_y (height) of parent View (box)
#   symbol_list: array of raw symbol data
# return: [ [ KbSymbol2.one data ] ]
calc_symbol2 = (sx, sy, symbol_list, measured_widths) ->
  g = _calc_global sx, sy, config.SYMBOL_PER_LINE
  height = g.ls

  o = []
  # add first line (top pad)
  o.push []
  # next lines for each symbol item
  rest = config.SYMBOL_PER_LINE - 1  # one line capacity, for first line
  one = []

  _reset_one_line = ->
    if one.length > 0
      o.push one
    one = []
    rest = config.SYMBOL_PER_LINE

  _add_placeholder = ->
    # check and add placeholder
    if rest > 0
      one.push {
        type: S2_TYPE_PLACEHOLDER
        flex: rest
        height
      }

  _check_end_one_line = (l, is_first_line) ->
    if l > rest
      _add_placeholder()
      # add paste button at the end of first line
      if is_first_line
        one.push {
          type: S2_TYPE_PASTE
          flex: 1
          height
        }
      _reset_one_line()

  _check_end_last_line = ->
    if one.length > 0
      _add_placeholder()
      o.push one

  for i in [0... symbol_list.length]
    raw = symbol_list[i]  # TODO support more meta-data ?
    is_first_line = (o.length < 2)
    l = _calc_symbol2_len raw, is_first_line, measured_widths[i], g.bs

    _check_end_one_line l, is_first_line
    # add this to the line
    one.push {
      type: S2_TYPE_TEXT
      flex: l
      height
      text: raw
    }
    rest -= l
  # add last line
  _check_end_last_line()
  o


# width of one item to render for calc_pinyin_more
_calc_pinyin_more_one_width = (x) ->
  # assert: x > 0
  # fix for 2
  if x is 2
    1.5
  else if x > 9
    config.PINYIN_MORE_PER_LINE  # line_width
  else
    Math.floor(x / 2) + 1

# args
#   sx: size_x (width) of parent View (box)
#   sy: size_y (width) of parent View (box)
#   raw: [ [ text item to show ] ]
# return: [
#   [  # one line
#     {  # one item
#       type: PropTypes.string.isRequired
#       # type can be one of
#       #   'text': normal text
#       #   '': placeholder (else type, default)
#
#       # size (width)
#       flex: PropTypes.number.isRequired
#       height: PropTypes.number.isRequired  # FIXME height to render
#
#       # only for type: 'text'
#       text: PropTypes.string
#     }
#   ]  # empty line for sep
# ]
calc_pinyin_more = (sx, sy, raw) ->
  g = _calc_global sx, sy
  height = g.ls
  line_width = config.PINYIN_MORE_PER_LINE
  _one_width = _calc_pinyin_more_one_width

  o = []
  # add first line (top pad)
  o.push []

  rest = line_width  # rest width of one line
  one = []
  # check and commit line
  _commit_line = ->
    if one.length < 1
      return
    # check add null placeholder
    if rest > 0
      one.push {
        type: S2_TYPE_PLACEHOLDER
        flex: rest
        height
      }
    o.push one
    one = []
    rest = line_width

  for i in raw  # process each group
    for t in i  # process each text item
      w = _one_width t.length
      # check for too big w
      if w >= line_width
        _commit_line()
        # add one new line
        o.push [{
          type: S2_TYPE_TEXT
          flex: w
          height
          text: t
        }]
        continue
      # check line rest length
      if rest >= w
        one.push {
          type: S2_TYPE_TEXT
          flex: w
          height
          text: t
        }
        rest -= w
        if rest < 1
          _commit_line()
        continue
      # overflow, commit exist line
      _commit_line()

      one.push {
        type: S2_TYPE_TEXT
        flex: w
        height
        text: t
      }
      rest -= w
    # check last line
    _commit_line()
    # add bottom line (sep)
    if o.length > 0
      if o[o.length - 1].length > 0
        o.push []
  o


module.exports = {
  key_vibrate

  LB_TYPE_TEXT
  LB_TYPE_SHIFT
  LB_TYPE_DELETE
  LB_TYPE_SPACE
  LB_TYPE_ENTER

  calc_layouts_1097
  calc_layouts_7109

  S2_TYPE_TEXT
  S2_TYPE_PASTE
  S2_TYPE_PLACEHOLDER

  calc_symbol
  calc_symbol2

  calc_pinyin_more
}
