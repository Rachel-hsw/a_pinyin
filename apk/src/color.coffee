# color.coffee, a_pinyin/apk/src/

{
  StyleSheet
  TouchableNativeFeedback
} = require 'react-native'

# main color
_MC_BLACK = 'hsl(0, 0%, 0%)'
_MC_WHITE = 'hsl(0, 0%, 100%)'

_MC_GRAY = 'hsl(0, 0%, 50%)'  # pure gray

# for nolog color
_MC_BLUE = 'hsl(240, 100%, 80%)'
_MC_GREEN = 'hsl(120, 100%, 40%)'

# for sec colors
_MC_GRAY_1 = 'hsl(0, 0%, 30%)'  # dark gray
_MC_GRAY_2 = 'hsl(0, 0%, 70%)'  # light gray

# create co obj
_gen_color = (mc) ->
  {
    color_bg
    color_fg
    color_sec_bg
    color_sec_fg
    color_nolog
    color_gray  # FIXME
  } = mc

  {
    # BG color
    BG: color_bg
    BG_SEC: color_sec_bg

    # button
    BG_BTN: color_sec_bg

    BG_TOUCH: color_fg

    # border
    BORDER: color_sec_bg

    # text
    TEXT: color_fg
    TEXT_SEC: color_sec_fg
    TEXT_BG: color_bg

    # other color
    # todo bg color
    TODO: 'rgb(255, 255, 0)'

    GRAY: color_gray

    # nolog mode color
    NOLOG: color_nolog
  }

co_dark = _gen_color {
  color_bg: _MC_BLACK
  color_fg: _MC_WHITE
  color_sec_bg: _MC_GRAY_1
  color_sec_fg: _MC_GRAY_2
  color_nolog: _MC_BLUE
  color_gray: _MC_GRAY
}
co_light = _gen_color {
  color_bg: _MC_WHITE
  color_fg: _MC_BLACK
  color_sec_bg: _MC_GRAY_2
  color_sec_fg: _MC_GRAY  # use light color here
  color_nolog: _MC_GREEN
  color_gray: _MC_GRAY
}

# create color stylesheet
_gen_co_ss = (co) ->
  o = StyleSheet.create {
    # kb: keyboard color

    # TouchableCore (View)
    kb_tc: {
    }
    kb_tc_active: {
      backgroundColor: co.TEXT
    }
    # SimpleTouch (Text)
    kb_st: {
      color: co.TEXT
    }
    kb_st_active: {
      color: co.BG
    }
    # sec button
    kb_sec: {  # View
      borderColor: co.BORDER
    }
    kb_sec_text: {  # Text
      color: co.TEXT_SEC
    }
    # KbShiftButton
    kb_sb_active: {  # View
      backgroundColor: co.TEXT_SEC
    }
    kb_sb_text_active: {  # Text
      color: co.BG
    }

    # kb_more
    kb_more_button_view: {
      borderColor: co.BORDER
    }
    kb_more_button_view_active: {
      backgroundColor: co.TEXT_SEC
    }
    kb_more_button_text: {
      color: co.TEXT_SEC
    }
    kb_more_button_text_active: {
      color: co.BG
    }

    kb_more_nolog_text: {
      color: co.NOLOG
    }
    kb_more_title: {
      color: co.TEXT
    }

    # kb_top
    kb_top_view: {
    }
    kb_top_view_active: {
      backgroundColor: co.GRAY
    }
    kb_top_text: {
      color: co.TEXT_SEC
    }
    kb_top_text_active: {
      color: co.BG
    }
    kb_top_text_nolog: {
      color: co.NOLOG
    }
    # kb_top_pinyin
    kb_top_pinyin_right: {  # View
      backgroundColor: co.BG
    }

    # the whole keyboard
    keyboard_view: {
      backgroundColor: co.BG
    }

    border: {
      borderColor: co.BORDER
    }
    # ui: main UI color
    ui_text: {
      color: co.TEXT
    }
    ui_text_sec: {
      color: co.TEXT_SEC
    }
    ui_text_bg: {
      color: co.BG_SEC
    }
    ui_text_nolog: {
      color: co.NOLOG
    }
    ui_top_view: {
      backgroundColor: co.BG
      borderBottomColor: co.BORDER
    }
    ui_license_text: {
      color: co.TEXT
      backgroundColor: co.BG_SEC
    }
    ui_main_view: {
      backgroundColor: co.BG
    }
  }
  # add more
  o.co = co
  # TouchableNativeFeedback.Ripple
  o.touch_ripple = TouchableNativeFeedback.Ripple co.TEXT_SEC
  o

get_co = (co) ->
  switch co
    when 'dark'
      module.exports.dark
    when 'light'
      module.exports.light

module.exports = {
  dark: _gen_co_ss co_dark
  light: _gen_co_ss co_light

  get_co
}
