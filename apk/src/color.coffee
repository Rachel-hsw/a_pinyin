# color.coffee, a_pinyin/apk/src/

# main color
_MC_BLACK = 'hsl(0, 0%, 0%)'
_MC_WHITE = 'hsl(0, 0%, 100%)'
_MC_GRAY = 'hsl(0, 0%, 50%)'
_MC_BLUE = 'hsl(240, 100%, 80%)'
_MC_GREEN = 'hsl(120, 100%, 40%)'

_gen_color = (color_bg, color_fg, color_sec, color_nolog) ->
  {
    # BG color
    BG: color_bg
    BG_SEC: color_sec

    # button
    BG_BTN: color_sec
    # TODO danger button

    BG_TOUCH: color_fg

    # border
    BORDER: color_sec

    # text
    TEXT: color_fg
    TEXT_SEC: color_sec
    TEXT_BG: color_bg

    # other color
    # todo bg color
    TODO: 'rgb(255, 255, 0)'

    # nolog mode color
    NOLOG: color_nolog
  }

get_co = (co) ->
  switch co
    when 'dark'
      module.exports.dark
    when 'light'
      module.exports.light

module.exports = {
  dark: _gen_color _MC_BLACK, _MC_WHITE, _MC_GRAY, _MC_BLUE
  light: _gen_color _MC_WHITE, _MC_BLACK, _MC_GRAY, _MC_GREEN

  get_co
}
