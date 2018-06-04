# color.coffee, a_pinyin/apk/src/

{
  StyleSheet
  TouchableNativeFeedback
} = require 'react-native'

# main color
_MC_BLACK = 'hsl(0, 0%, 0%)'
_MC_WHITE = 'hsl(0, 0%, 100%)'
_MC_GRAY = 'hsl(0, 0%, 50%)'
_MC_BLUE = 'hsl(240, 100%, 80%)'
_MC_GREEN = 'hsl(120, 100%, 40%)'

# create co obj
_gen_color = (color_bg, color_fg, color_sec, color_nolog) ->
  {
    # BG color
    BG: color_bg
    BG_SEC: color_sec

    # button
    BG_BTN: color_sec

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

co_dark = _gen_color _MC_BLACK, _MC_WHITE, _MC_GRAY, _MC_BLUE
co_light = _gen_color _MC_WHITE, _MC_BLACK, _MC_GRAY, _MC_GREEN

# create color stylesheet
_gen_co_ss = (co) ->
  o = StyleSheet.create {
    # kb: keyboard color
    kb_touch_view: {
      backgroundColor: co.BG
      borderColor: co.BORDER
    }
    kb_touch_view_active: {
      backgroundColor: co.TEXT
    }
    kb_touch_text: {
      color: co.TEXT
    }
    kb_touch_text_active: {
      color: co.TEXT_SEC
    }

    border: {
      borderColor: co.BORDER
    }

    # kb sec button
    kb_sec_text: {
      color: co.TEXT_SEC
    }

    kb_shift_view_active: {
      backgroundColor: co.TEXT_SEC
    }
    kb_shift_text_active: {
      color: co.BG
    }

    # kb_top
    kb_top_view: {
      backgroundColor: co.BG
    }
    kb_top_view_active: {
      backgroundColor: co.TEXT_SEC
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

    kb_more_button_view: {
      backgroundColor: co.BG
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

    keyboard_view: {
      backgroundColor: co.BG
    }
    # ui: main UI color
    ui_text: {
      color: co.TEXT
    }
    ui_text_sec: {
      color: co.TEXT_SEC
    }
    ui_text_nolog: {
      color: co.NOLOG
    }
    ui_top_view: {
      backgroundColor: co.BG
      borderBottomColor: co.BG_SEC
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
  o.touch_ripple = TouchableNativeFeedback.Ripple co.BG_SEC
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
